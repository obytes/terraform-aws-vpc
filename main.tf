locals {
  enabled                       = var.enabled
  internet_gateway_count        = var.enable_internet_gateway && local.enabled && var.create_public_subnets ? 1 : 0
  custom_default_security_group = var.create_custom_security_group && local.enabled ? true : false
  az_name_list                  = length(flatten(var.azs_list_names)) > 0 ? var.azs_list_names : data.aws_availability_zones.azs.names
  availability_zones            = length(var.azs_list_names) > 0 ? var.azs_list_names : data.aws_availability_zones.azs.names
  name                          = var.name != null ? join(var.delimiter, [var.prefix, var.name]) : var.prefix
  delimiter                     = var.delimiter != null ? var.delimiter : "-"
}


resource "aws_vpc" "_" {
  count                            = local.enabled ? 1 : 0
  cidr_block                       = var.cidr_block
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6_cidr_block
  tags                             = merge(var.additional_tags, tomap({ Name = local.name }))
}

resource "aws_default_security_group" "_" {
  count  = local.custom_default_security_group ? 1 : 0
  vpc_id = aws_vpc._[count.index].id

  tags = merge(var.additional_tags, tomap({ "Type" = "Default Security Group", "VPC" = join("", aws_vpc._.*.id), "Name" = local.name }))

  dynamic "ingress" {
    for_each = var.default_security_group_ingress
    content {
      self             = lookup(ingress.value, "self", null)
      from_port        = lookup(ingress.value, "from_port", null)
      to_port          = lookup(ingress.value, "to_port", null)
      protocol         = lookup(ingress.value, "protocol", null)
      description      = lookup(ingress.value, "description", null)
      cidr_blocks      = compact(split(",", lookup(ingress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(ingress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(ingress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(ingress.value, "security_groups", "")))
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress
    content {
      self             = lookup(egress.value, "self", null)
      from_port        = lookup(egress.value, "from_port", 0)
      to_port          = lookup(egress.value, "to_port", 0)
      protocol         = lookup(egress.value, "protocol", "-1")
      description      = lookup(egress.value, "description", "")
      cidr_blocks      = compact(split(",", lookup(egress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(egress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(egress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(egress.value, "security_groups", "")))
    }
  }
}

resource "aws_internet_gateway" "_" {
  count  = local.internet_gateway_count
  vpc_id = aws_vpc._[count.index].id
  tags   = merge(var.additional_tags, tomap({ "VPC" = aws_vpc._[count.index].id, "Type" = "internet Gateway", "Name" = local.name }))
}

resource "aws_default_route_table" "_" {
  count                  = local.enabled && var.manage_default_route_table ? 1 : 0
  default_route_table_id = aws_vpc._[count.index].default_route_table_id
  dynamic "route" {
    for_each = var.additional_default_route_table_routes
    content {
      cidr_block      = route.value.cidr_block
      ipv6_cidr_block = lookup(route.value, "ipv6_cidr_block", null)
      # One of the following targets must be provided
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = merge(var.additional_tags, tomap({ "Name" = local.name }),
    var.additional_default_route_table_tags
  )
}

resource "aws_vpc_dhcp_options" "_" {
  count                = local.enabled ? 1 : 0
  domain_name          = var.vpc_dhcp_domain_name
  domain_name_servers  = var.vpc_domain_name_servers
  ntp_servers          = var.vpc_dhcp_ntp_servers
  netbios_name_servers = var.vpc_dhcp_netbios_name_servers
  netbios_node_type    = var.vpc_dhcp_netbios_node_type

  tags = merge(var.additional_tags, tomap({ "Name" = join(local.delimiter, [local.name, "dhcp-ops"]) }))
}

resource "aws_vpc_dhcp_options_association" "dhcp-assoc" {
  count           = local.enabled ? 1 : 0
  vpc_id          = aws_vpc._[count.index].id
  dhcp_options_id = aws_vpc_dhcp_options._[count.index].id
}
