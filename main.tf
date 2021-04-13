locals {
  enabled  = module.label.enabled
  internet_gateway_count = var.enable_internet_gateway && local.enabled && var.create_public_subnets ? 1 : 0
  custom_default_security_group = var.create_custom_security_group && local.enabled ? true : false
  az_name_list = length(flatten(var.azs_list_names)) > 0 ? var.azs_list_names : data.aws_availability_zones.azs.names
}

module "vpc_label" {
  source = "github.com/obytes/terraform-aws-tag.git?ref=v1.0.1"
  random_string = module.label.random_string
  context = module.label.context
}

resource "aws_vpc" "_" {
  count = local.enabled ? 1 : 0
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6_cidr_block
  tags = module.label.tags
}

resource "aws_default_security_group" "_" {
  count = local.custom_default_security_group ? 1: 0
  vpc_id = aws_vpc._[count.index].id

  tags = merge(module.label.tags, map("Type", "Default Security Group", "VPC", join("", aws_vpc._.*.id)))

  dynamic "ingress" {
    for_each = var.default_security_group_ingress
    content {
      self = lookup(ingress.value, "self", null )
      from_port = lookup(ingress.value, "from_port", null )
      to_port = lookup(ingress.value, "to_port", null)
      protocol = lookup(ingress.value, "protocol", null )
      description = lookup(ingress.value, "description", null )
      cidr_blocks = compact(split(",",lookup(ingress.value,"cidr_blocks","" )))
      ipv6_cidr_blocks = compact(split(",", lookup(ingress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(ingress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(ingress.value, "security_groups", "")))
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress
    content {
      self = lookup(egress.value,"self", null )
      from_port = lookup(egress.value, "from_port", 0 )
      to_port = lookup(egress.value, "to_port", 0)
      protocol = lookup(egress.value, "protocol", "-1" )
      description = lookup(egress.value, "description", "" )
      cidr_blocks = compact(split(",",lookup(egress.value,"cidr_blocks","" )))
      ipv6_cidr_blocks = compact(split(",", lookup(egress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(egress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(egress.value, "security_groups", "")))
    }
  }
}

resource "aws_internet_gateway" "_" {
  count = local.internet_gateway_count
  vpc_id = aws_vpc._[count.index].id
  tags = merge(module.vpc_label.tags, map("VPC", aws_vpc._[count.index].id, "Type", "internet Gateway"))
}
