# Terraform AWS VPC 

## SUMMARY
A Terraform module to create AWS VPC along with its resources:
 - VPC Default Security Group
 - VPC Default Routing Table
 - NAT Gateway(s) and Internet Gateways
 - Public and Private Subnets

### Example

Below is an example how to call and use the module, kindly check the example folder for more detailed output

```hcl 
module "example1" {
  source                  = "github.com/obytes/terraform-aws-vpc.git?ref=v1.0.2"
  environment             = "qa"
  project_name            = "on-cost"
  region                  = "eu-west-2"
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

}

```

### Validation
This Module Supports the following validation on Inputs:
 - `cidr_blocks` : A validation to verify the CIDR Block based don AWS requirements, The allowed block size is between a /16 netmask (65,536 IP addresses) and /28 netmask (16 IP addresses).

### Subnet Naming Convention
A shortcode of the availability group will be appended to the subnet name

### Scenarios

 - NAT Gateways
   - Single NAT Gateway - Default Scenario
      - `enable_nat_gateway` is set tot true
      - `single_nat_gateway` is set to true
      - `nat_gateway_per_az` is set to false
    - NAT Gateway per AZ
      - `enable_nat_gateway` is set to true
      - `single_nat_gateway` is set to false
      - `nat_gateway_per_az` is set to true 
 
 >Note: if `single_nat_gateway` and `nat_gateway_per_az` are both set to true, `single_nat_gateway` takes precedence.
 
 - AWS EIPs (Elastic_IPs)
   - Create New EIPs - Default Scenario 
     -  `var.nat_eips_list` is empty
   - Re-use Existing EIPs
     - `var.nat_eips_list` is populated with alist of elastic_ips from your AWS account.
 
 - Subnet Count 
    - Subnet / AZ - Default Scenario
      - `enable_private_subnet` or `var.enable_public_subnet` is set to true
      - `var.max_subnet_count` is set to 0
    - Limited Subnets
      - `var.max_subnet_count` is not 0 e.g. 1, 4
 - VPC Default Security Group
   - Create custom security group - default scenario
     - `var.create_custom_security_group` is set to true
     - the security group has no ingress rules
     - the security group allow all egress traffic

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.35.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label"></a> [label](#module\_label) | github.com/obytes/terraform-aws-tag.git?ref=v1.0.1 |  |
| <a name="module_nat_label"></a> [nat\_label](#module\_nat\_label) | github.com/obytes/terraform-aws-tag.git?ref=v1.0.1 |  |
| <a name="module_private_label"></a> [private\_label](#module\_private\_label) | github.com/obytes/terraform-aws-tag.git?ref=v1.0.1 |  |
| <a name="module_public_label"></a> [public\_label](#module\_public\_label) | github.com/obytes/terraform-aws-tag.git?ref=v1.0.1 |  |
| <a name="module_vpc_label"></a> [vpc\_label](#module\_vpc\_label) | github.com/obytes/terraform-aws-tag.git?ref=v1.0.1 |  |

## Resources

| Name | Type |
|------|------|
| [aws_default_route_table._](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/default_route_table) | resource |
| [aws_default_security_group._](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/default_security_group) | resource |
| [aws_eip._](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/eip) | resource |
| [aws_internet_gateway._](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway._](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/nat_gateway) | resource |
| [aws_route.private_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/route) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/subnet) | resource |
| [aws_vpc._](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options._](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.dhcp-assoc](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/data-sources/availability_zones) | data source |
| [aws_eip._](https://registry.terraform.io/providers/hashicorp/aws/3.35.0/docs/data-sources/eip) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_default_route_table_routes"></a> [additional\_default\_route\_table\_routes](#input\_additional\_default\_route\_table\_routes) | List, of routes to be added to the default route table ID<br>Example,<br>[<br>  {<br>    cidr\_block = "172.17.18.19/30" # Required<br>    ipv6\_cidr\_block = "::/0" # Optional<br>    destination\_prefix\_list\_id = "pl-0570a1d2d725c16be" # Optional<br>    #One of the following target arguments must be supplied:<br>    egress\_only\_gateway\_id = ""<br>    gateway\_id = ""<br>    instance\_id = ""<br>    nat\_gateway\_id = ""<br>    vpc\_peering\_connection\_id = ""<br>    vpc\_endpoint\_id = ""<br>    transit\_gateway\_id = ""<br>    network\_interface\_id = ""<br>  }<br>] | `list(map(string))` | `[]` | no |
| <a name="input_additional_default_route_table_tags"></a> [additional\_default\_route\_table\_tags](#input\_additional\_default\_route\_table\_tags) | Additional, map of tags to be added to the `default_route_table` tags | `map(string)` | `null` | no |
| <a name="input_additional_private_route_tags"></a> [additional\_private\_route\_tags](#input\_additional\_private\_route\_tags) | Additional, map of tags to be added to the private `aws_route_table` tags | `map(string)` | `null` | no |
| <a name="input_additional_public_route_tags"></a> [additional\_public\_route\_tags](#input\_additional\_public\_route\_tags) | Additional, map of tags to be added to the public `aws_route_table` tags | `map(string)` | `null` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional Tags, tags which can be accessed by module.<name>.tags\_as\_list not added to <module>.<name>.<tags> | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | A list of attributes e.g. `private`, `shared`, `cost_center` | `list(string)` | `null` | no |
| <a name="input_azs_list_names"></a> [azs\_list\_names](#input\_azs\_list\_names) | A list to include all the AZs you would like to configure such as `us-east-1a`, `us-east-1b` | `list(string)` | `[]` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | VPC CIDR Block, The allowed block size is between a /16 netmask (65,536 IP addresses) and /28 netmask (16 IP addresses). | `string` | `"172.16.0.0/18"` | no |
| <a name="input_context"></a> [context](#input\_context) | n/a | `any` | <pre>{<br>  "additional_tags": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": "qa",<br>  "name": null,<br>  "prefix_length_limit": 0,<br>  "prefix_order": [<br>    "environment",<br>    "project_name",<br>    "region",<br>    "name",<br>    "attributes"<br>  ],<br>  "project_name": "on-cost",<br>  "random_string": null,<br>  "regex_substitute_chars": null,<br>  "region": null,<br>  "tag_key_case": "title",<br>  "tag_value_case": "lower",<br>  "tags": {}<br>}</pre> | no |
| <a name="input_create_custom_security_group"></a> [create\_custom\_security\_group](#input\_create\_custom\_security\_group) | Boolean, to enable the creation of a custom default\_security\_group<br>if set to `false` the AWS default VPC security rule will be applied, for more reference https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html#DefaultSecurityGroup<br>if set to `true` a new default security group will be created with only `egress` traffic allowed | `bool` | `true` | no |
| <a name="input_create_private_subnets"></a> [create\_private\_subnets](#input\_create\_private\_subnets) | Ability to create private subnets in all configured AZs | `bool` | `true` | no |
| <a name="input_create_public_subnets"></a> [create\_public\_subnets](#input\_create\_public\_subnets) | Ability to create private subnets in all configured AZs, if this set to true<br>the `enable_internet_gateway` should also be true for the subnets to be associated to IGW | `bool` | `true` | no |
| <a name="input_default_security_group_egress"></a> [default\_security\_group\_egress](#input\_default\_security\_group\_egress) | Egress Rules, List of maps of ingress rules to set on the default security group<br>Default egress rule is to allow all outgoing connections on any protocol.<br>Example<br>[<br>  {<br>    from\_port = 80<br>    to\_port = 80<br>    protocol = "tcp"  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group#protocol<br>    cidr\_blocks = ["0.0.0.0/0"]<br>    description = "Ingress Rule to Allow port 80 protocol TCP from Anywhere"<br>    self = true\|false # Whether the security group itself will be added as a source to this egress rule.<br>  }<br>] | `list(map(string))` | <pre>[<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "from_port": "0",<br>    "protocol": "-1",<br>    "to_port": "0"<br>  }<br>]</pre> | no |
| <a name="input_default_security_group_ingress"></a> [default\_security\_group\_ingress](#input\_default\_security\_group\_ingress) | Ingress Rules, List of maps of ingress rules to set on the default security group<br>Example<br>[<br>  {<br>    from\_port = 80<br>    to\_port = 80<br>    protocol = "tcp"  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group#protocol<br>    cidr\_blocks = ["0.0.0.0/0"]<br>    description = "Ingress Rule to Allow port 80 protocol TCP from Anywhere"<br>    self = true\|false # Whether the security group itself will be added as a source to this egress rule.<br>  }<br>] | `list(map(string))` | `[]` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `project_name`, `environment`, `region` and, `name`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false. | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | A boolean flag to enable/disable DNS support in the VPC. Defaults true. | `bool` | `true` | no |
| <a name="input_enable_internet_gateway"></a> [enable\_internet\_gateway](#input\_enable\_internet\_gateway) | IGW, This boolean variables controls the creation of Internet Gateway<br>For IGW to be created this variable and var.create\_public\_subnets should set to true | `bool` | `true` | no |
| <a name="input_enable_ipv6_cidr_block"></a> [enable\_ipv6\_cidr\_block](#input\_enable\_ipv6\_cidr\_block) | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses,<br>or the size of the CIDR block. Default is `false` | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | A boolean to enable or disable tagging/labeling module | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, the environment name such as 'stg', 'prd', 'dev' | `string` | `null` | no |
| <a name="input_include_all_azs"></a> [include\_all\_azs](#input\_include\_all\_azs) | Boolean, weather to include all Availability Zones in the region where the provider is running<br>Default is `true`, set this to `false` if you would like to have specific azs | `bool` | `true` | no |
| <a name="input_manage_default_route_table"></a> [manage\_default\_route\_table](#input\_manage\_default\_route\_table) | Should be true, to manage the default route table | `bool` | `true` | no |
| <a name="input_map_public_ip_on_lunch"></a> [map\_public\_ip\_on\_lunch](#input\_map\_public\_ip\_on\_lunch) | (Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false. | `bool` | `false` | no |
| <a name="input_max_subnet_count"></a> [max\_subnet\_count](#input\_max\_subnet\_count) | A Number to indicate the max subnets to be created, if not set it will create one subnet/az | `number` | `3` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the service/solution such as vpc, ec2 | `string` | `null` | no |
| <a name="input_nat_eips_list"></a> [nat\_eips\_list](#input\_nat\_eips\_list) | A List, of NAT IPs to be used by the NAT\_GW | `list(string)` | `[]` | no |
| <a name="input_nat_gateway_per_az"></a> [nat\_gateway\_per\_az](#input\_nat\_gateway\_per\_az) | Should be true if you want only one NAT Gateway per availability zone. | `bool` | `false` | no |
| <a name="input_prefix_length_limit"></a> [prefix\_length\_limit](#input\_prefix\_length\_limit) | The minimum number of chars required for the id/Name desired (minimum =7)<br>Set it to `0` for unlimited number of chars, `full_id` | `number` | `null` | no |
| <a name="input_prefix_order"></a> [prefix\_order](#input\_prefix\_order) | The order of the Name tag<br>Defaults to, `["environment", "project_name", "region", "name"]`<br>at least one should be provided | `list(string)` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The project name or organization name, could be fullName or abbreviation such as `ex` | `string` | `null` | no |
| <a name="input_random_string"></a> [random\_string](#input\_random\_string) | A Random string, that will be appended to `id` in case of using `prefix_length_limit`<br>Using the default value which is `null`, the string will be created using the `random` terraform provider | `string` | `null` | no |
| <a name="input_regex_substitute_chars"></a> [regex\_substitute\_chars](#input\_regex\_substitute\_chars) | a regex to replace empty chars in `project_name`, `environment`, `region` and, `name`<br>defaults to `"\[a-zA-Z0-9]\"`, replacing any chars other than chars and digits | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Environment name such as us-east-1, ap-west-1, eu-central-1 | `string` | `null` | no |
| <a name="input_route_create_timeout"></a> [route\_create\_timeout](#input\_route\_create\_timeout) | A timeout for the aws\_route\_table creation, default is 5m | `string` | `"5m"` | no |
| <a name="input_route_delete_timeout"></a> [route\_delete\_timeout](#input\_route\_delete\_timeout) | A timeout for the aws\_route\_table deletion, default is 5m | `string` | `"5m"` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `true` | no |
| <a name="input_tag_key_case"></a> [tag\_key\_case](#input\_tag\_key\_case) | The letter case of output tag keys<br>Possible values are `lower', `upper` and `title`<br>defaults to `title`<br>` | `string` | `null` | no |
| <a name="input_tag_value_case"></a> [tag\_value\_case](#input\_tag\_value\_case) | The letter case of output tag values<br>Possible values are `lower', `upper` and `title`<br>defaults to `lower`<br>` | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags, Tags to be generated by this module which can be access by module.<name>.tags e.g. map('CostCenter', 'Production') | `map(string)` | `{}` | no |
| <a name="input_vpc_dhcp_domain_name"></a> [vpc\_dhcp\_domain\_name](#input\_vpc\_dhcp\_domain\_name) | (Optional) the suffix domain name to use by default when resolving non Fully Qualified Domain Names. In other words, this is what ends up being the search value in the /etc/resolv.conf file. | `string` | `null` | no |
| <a name="input_vpc_dhcp_netbios_name_servers"></a> [vpc\_dhcp\_netbios\_name\_servers](#input\_vpc\_dhcp\_netbios\_name\_servers) | (Optional) List of NETBIOS name servers. | `list(string)` | `[]` | no |
| <a name="input_vpc_dhcp_netbios_node_type"></a> [vpc\_dhcp\_netbios\_node\_type](#input\_vpc\_dhcp\_netbios\_node\_type) | (Optional) The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network. For more information about these node types, see RFC 2132. | `number` | `null` | no |
| <a name="input_vpc_dhcp_ntp_servers"></a> [vpc\_dhcp\_ntp\_servers](#input\_vpc\_dhcp\_ntp\_servers) | (Optional) List of NTP servers to configure. | `list(string)` | `[]` | no |
| <a name="input_vpc_domain_name_servers"></a> [vpc\_domain\_name\_servers](#input\_vpc\_domain\_name\_servers) | (Optional) List of name servers to configure in /etc/resolv.conf. If you want to use the default AWS nameservers you should set this to AmazonProvidedDNS. | `list(string)` | <pre>[<br>  "AmazonProvidedDNS"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | List of Availability Zones where subnets were created |
| <a name="output_elastc_ips"></a> [elastc\_ips](#output\_elastc\_ips) | AWS eip public ips |
| <a name="output_nat_gw_ids"></a> [nat\_gw\_ids](#output\_nat\_gw\_ids) | aws nat gateway id(s) |
| <a name="output_nat_ips"></a> [nat\_ips](#output\_nat\_ips) | IP Addresses in use for NAT |
| <a name="output_prv_route_table_ids"></a> [prv\_route\_table\_ids](#output\_prv\_route\_table\_ids) | private route table ids |
| <a name="output_prv_subnet_cidrs"></a> [prv\_subnet\_cidrs](#output\_prv\_subnet\_cidrs) | Private Subnet cidr\_blocks |
| <a name="output_prv_subnet_ids"></a> [prv\_subnet\_ids](#output\_prv\_subnet\_ids) | Private Subnet IDs |
| <a name="output_pub_route_table_ids"></a> [pub\_route\_table\_ids](#output\_pub\_route\_table\_ids) | Public route table ids |
| <a name="output_pub_subnet_cidrs"></a> [pub\_subnet\_cidrs](#output\_pub\_subnet\_cidrs) | Public Subnet cidr\_blocks |
| <a name="output_pub_subnet_ids"></a> [pub\_subnet\_ids](#output\_pub\_subnet\_ids) | Public Subnet IDs |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | CIDR Block of the VPC |
| <a name="output_vpc_dhcp_dns_list"></a> [vpc\_dhcp\_dns\_list](#output\_vpc\_dhcp\_dns\_list) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
| <a name="output_vpc_sg_id"></a> [vpc\_sg\_id](#output\_vpc\_sg\_id) | n/a |
