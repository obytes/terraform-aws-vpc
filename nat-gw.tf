locals {
  nat_gateway_count = var.single_nat_gateway && var.enable_nat_gateway && local.enabled? 1 : var.nat_gateway_per_az && var.enable_nat_gateway && local.enabled ? length(data.aws_availability_zones.azs.names) : var.enable_nat_gateway && local.enabled ? 1 : 0
  reuse_existing_eips = length(var.nat_eips_list) > 0
  nat_gateway_eip_count   = local.reuse_existing_eips ? 0 : local.nat_gateway_count
  eip_allocation_ids = local.reuse_existing_eips ? data.aws_eip._.*.id : aws_eip._.*.id
}

module "nat_label" {
  source = "github.com/obytes/terraform-aws-tag.git?ref=v1.0.1"
  attributes = ["nat"]
  random_string = module.label.random_string
  context = module.label.context
}

resource "aws_eip" "_" {
  count = local.enabled ? local.nat_gateway_eip_count : 0
  vpc = true
  tags = merge(module.nat_label.tags, map("Name", join(module.nat_label.delimiter, [module.nat_label.id, count.index])))
}

resource "aws_nat_gateway" "_" {
  count = local.enabled && var.enable_nat_gateway ? local.nat_gateway_count : 0
  allocation_id = element(local.eip_allocation_ids,count.index )
  subnet_id = element(aws_subnet.public.*.id, count.index)
  tags = merge(module.nat_label.tags, map("Name", join(module.nat_label.delimiter, [module.nat_label.id, count.index])))

    lifecycle {
    create_before_destroy = true
  }
}