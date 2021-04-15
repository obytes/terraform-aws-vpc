module "example1" {
  source                  = "../"
  environment             = "qa"
  project_name            = "on-cost"
  cidr_block              = "172.16.0.0/18"
  enable_dns_hostnames    = true
  enable_nat_gateway      = true
  enable_internet_gateway = true
  create_public_subnets   = true
  max_subnet_count        = 3
  single_nat_gateway      = true
  azs_list_names          = ["us-east-1f", "us-east-1d", "us-east-1e"]
  additional_default_route_table_tags = {
    Managed = "Terraform"
    Default = "Yes"
  }

}
