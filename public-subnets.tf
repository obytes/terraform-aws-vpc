locals {
  public_subnet_count = var.create_public_subnets && var.max_subnet_count == 0 && length(flatten(var.azs_list_names)) == 0 ? length(flatten(data.aws_availability_zones.azs.names)) : var.create_public_subnets && length(flatten(var.azs_list_names)) > 0 ? length(flatten(var.azs_list_names)) : var.create_private_subnets && var.max_subnet_count != 0 ? var.max_subnet_count : var.create_public_subnets && var.include_all_azs ? length(flatten(data.aws_availability_zones.azs.names)) : 0
}
module "public_label" {
  source = "github.com/obytes/terraform-aws-tag.git?ref=v1.0.1"
  attributes = ["pub"]
  random_string = module.label.random_string
  context = module.label.context
}

resource "aws_subnet" "public" {
  count = local.public_subnet_count

  cidr_block = cidrsubnet(
  var.cidr_block,
  ceil(log(length(flatten(var.include_all_azs ? data.aws_availability_zones.azs.names : var.azs_list_names)) * 2, 2)),
  count.index + local.public_subnet_count)

  availability_zone = element(local.availability_zones, count.index )
  vpc_id = join("", aws_vpc._.*.id)
  map_public_ip_on_launch = var.map_public_ip_on_lunch
  tags = merge(module.public_label.tags, map("VPC", join("", aws_vpc._.*.id),
  "Availability Zone", length(var.azs_list_names) > 0 ? element(var.azs_list_names,count.index) : element(data.aws_availability_zones.azs.names,count.index),
  "Name", join(module.public_label.delimiter, [module.public_label.id,  local.az_map_list_short[local.availability_zones[count.index]]])
  ))
}

resource "aws_route_table" "public" {
  count = local.enabled && local.public_subnet_count > 0 ? 1 : 0
  vpc_id = aws_vpc._[count.index].id

  tags = merge(module.public_label.tags, map("Name", join(module.public_label.delimiter, [module.public_label.id, "public-route"])),
          var.additional_public_route_tags
  )
}

resource "aws_route" "public_internet_gateway" {
  count = local.enabled && local.internet_gateway_count > 0 && local.public_subnet_count > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway._[0].id

  timeouts {
    create = var.route_create_timeout
    delete = var.route_delete_timeout
  }
}

resource "aws_route_table_association" "public" {
  count = local.enabled && local.public_subnet_count > 0 ? local.public_subnet_count : 0
  route_table_id = aws_route_table.public[0].id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}





