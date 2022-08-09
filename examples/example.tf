module "label" {
  source              = "github.com/obytes/terraform-aws-tag.git?ref=v1.0.8"
  project_name        = "pto"
  region              = "eu-west-2"
  environment         = "qa"
  company_name        = "genius"
  prefix_order        = ["project_name", "company_name", "environment"]
  prefix_length_limit = 12
}

module "example1" {
  source                  = "../"
  enabled                 = true
  prefix                  = module.label.id
  delimiter               = module.label.delimiter
  name                    = "vpc"
  additional_tags         = module.label.tags
  cidr_block              = "172.16.0.0/18"
  enable_dns_hostnames    = true
  enable_nat_gateway      = true
  enable_internet_gateway = true
  create_public_subnets   = true
  max_subnet_count        = 3
  single_nat_gateway      = true
  additional_default_route_table_tags = {
    Managed = "Terraform"
    Default = "Yes"
  }
  additional_public_subnet_tags = {
    "kubernetes.io/cluster/cluster-name" = "shared"
    "kubernetes.io/role/elb"             = 1
  }
  additional_private_subnet_tags = {
    "kubernetes.io/cluster/cluster-name" = "shared"
    "kubernetes.io/role/internal-elb"    = 1
  }
}
