data "aws_availability_zones" "azs" {

}

data "aws_eip" "_" {
  count = local.enabled ? length(var.nat_eips_list) : 0
  public_ip = element(var.nat_eips_list,count.index )
}