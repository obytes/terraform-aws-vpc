locals {
  public_subnet_count = var.create_public_subnets && var.max_subnet_count == 0 && length(flatten(var.azs_list_names)) == 0 ? length(flatten(data.aws_availability_zones.azs.names)) : var.create_public_subnets && length(flatten(var.azs_list_names)) > 0 ? length(flatten(var.azs_list_names)) : var.create_private_subnets && var.max_subnet_count != 0 ? var.max_subnet_count : var.create_public_subnets && var.include_all_azs ? length(flatten(data.aws_availability_zones.azs.names)) : 0
}
module "public_label" {
  source = "github.com/obytes/terraform-aws-tag.git?ref=v1.0.1"
  attributes = ["public"]
  random_string = module.label.random_string
  context = module.label.context
}

resource "aws_subnet" "public" {
  count = local.public_subnet_count
  cidr_block = cidrsubnet(
  var.cidr_block,
  ceil(log(length(flatten(var.include_all_azs ? data.aws_availability_zones.azs.names : var.azs_list_names)) * 2, 2)),
  count.index + local.public_subnet_count)
  availability_zone = length(var.azs_list_names) > 0 ? element(var.azs_list_names,count.index) : element(data.aws_availability_zones.azs.names,count.index)
  vpc_id = join("", aws_vpc._.*.id)
  tags = merge(module.public_label.tags, map("VPC", join("", aws_vpc._.*.id),
  "Availability Zone", length(var.azs_list_names) > 0 ? element(var.azs_list_names,count.index) : element(data.aws_availability_zones.azs.names,count.index),
  "Name", join(module.public_label.delimiter, [module.public_label.id,  count.index])
  ))
}

#FIXME: ADD VPC DEFAULT ROUTE TABLE

