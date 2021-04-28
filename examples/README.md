## USAGE

```hcl 
module "example1" {
  source                  = "github.com/obytes/terraform-aws-vpc.git?ref=v1.0.2"
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

```

### Output
```hcl
Outputs:

availability_zones = tolist([
  "us-east-1f",
  "us-east-1d",
  "us-east-1e",
])
elastc_ips = [
  "x.x.y.y",
]
nat_gw_ids = [
  "nat-07a9700996c75ea92",
]
nat_ips = [
  "x.x.xy.z",
]
prv_route_table_ids = [
  "rtb-0124950eadfac1941",
]
prv_subnet_cidrs = [
  "172.16.0.0/22",
  "172.16.4.0/22",
  "172.16.8.0/22",
]
prv_subnet_ids = [
  "subnet-03b65547c3d63da69",
  "subnet-03fb8b8b982d25e96",
  "subnet-05c07ac16399e998e",
]
pub_route_table_ids = [
  "rtb-0a9df01a1b51dd6c7",
]
pub_subnet_cidrs = [
  "172.16.12.0/22",
  "172.16.16.0/22",
  "172.16.20.0/22",
]
pub_subnet_ids = [
  "subnet-0154e71e59cde4e99",
  "subnet-0548f318ce47485ac",
  "subnet-06ecadc37cb7598bb",
]
vpc_cidr_block = "172.16.0.0/18"
vpc_id = [
  "vpc-05fced6a69b476603",
]
vpc_dhcp_dns_list = [
  tolist([
    "AmazonProvidedDNS",
  ]),
]
vpc_sg_id = [
  "sg-03b89ccf54f576a04",
]


```
