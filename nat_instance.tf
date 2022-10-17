locals {
  private_enabled  = local.enabled && var.private_subnets_enabled
  private4_enabled = local.private_enabled && local.ipv4_enabled
  ipv4_enabled     = local.enabled && var.ipv4_enabled
  nat_gateway_setting = var.nat_instance_enabled == true ? var.enable_nat_gateway == true : !(
    var.enable_nat_gateway == false # not true or null
  )
  nat_instance_setting = local.nat_gateway_setting ? false : var.nat_instance_enabled == true # not false or null
  nat_instance_useful  = local.private4_enabled
  nat_instance_enabled = local.nat_instance_useful && local.nat_instance_setting
  need_nat_ami_id      = local.nat_instance_enabled && length(var.nat_instance_ami_id) == 0
  nat_instance_ami_id  = local.need_nat_ami_id ? data.aws_ami.nat_instance[0].id : try(var.nat_instance_ami_id[0], "")
}

resource "aws_security_group" "nat_instance" {
  count       = local.nat_instance_enabled ? 1 : 0
  description = "Security Group for NAT Instance"
  vpc_id      = join("", aws_vpc._.*.id)
  tags = merge(var.additional_tags, var.additional_private_subnet_tags, tomap({ "VPC" = join("", aws_vpc._.*.id),
    "Availability Zone" = length(var.azs_list_names) > 0 ? element(var.azs_list_names, count.index) : element(data.aws_availability_zones.azs.names, count.index),
    "Name" = join(local.delimiter, [local.name, local.az_map_list_short[local.availability_zones[count.index]]]) }
  ))
}

resource "aws_security_group_rule" "nat_instance_egress" {
  count = local.nat_instance_enabled ? 1 : 0

  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.nat_instance.*.id)
  type              = "egress"
}

resource "aws_security_group_rule" "nat_instance_ingress" {
  count = local.nat_instance_enabled ? 1 : 0

  description       = "Allow ingress traffic from the VPC CIDR block"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.cidr_block]
  security_group_id = join("", aws_security_group.nat_instance.*.id)
  type              = "ingress"
}

# aws --region us-west-2 ec2 describe-images --owners amazon --filters Name="name",Values="amzn-ami-vpc-nat*" Name="virtualization-type",Values="hvm"
data "aws_ami" "nat_instance" {
  count = local.need_nat_ami_id ? 1 : 0

  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-comparison.html
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html
# https://dzone.com/articles/nat-instance-vs-nat-gateway
resource "aws_instance" "nat_instance" {
  count = local.nat_instance_enabled ? 1 : 0

  ami                    = local.nat_instance_ami_id
  instance_type          = var.nat_instance_type
  subnet_id              = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.nat_instance[0].id]

  tags = merge(
    var.additional_tags,
    {
      "Name" = join(local.delimiter, [local.name, count.index]),
      "VPC"  = join("", aws_vpc._.*.id)
    }
  )

  # Required by NAT
  # https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html#EIP_Disable_SrcDestCheck
  source_dest_check           = false
  associate_public_ip_address = true

  ebs_optimized = true
  key_name      = join("-", [local.name, "key"])
}

resource "aws_eip_association" "nat_instance" {
  count = local.nat_instance_enabled ? 1 : 0

  instance_id   = aws_instance.nat_instance[count.index].id
  allocation_id = aws_eip._[count.index].id
}

# If private IPv4 subnets and NAT Instance are both enabled, create a
# default route from private subnet to NAT Instance in each subnet

resource "aws_route" "nat_instance" {
  count = local.enabled && var.nat_instance_enabled ? 1 : 0

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  network_interface_id   = element(aws_instance.nat_instance.*.primary_network_interface_id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.private]

  timeouts {
    create = var.route_create_timeout
    delete = var.route_delete_timeout
  }
}
