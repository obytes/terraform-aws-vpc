
#=============#
#   V P C     #
#=============#

variable "include_all_azs" {
  type = bool
  default = true
  description = <<-EOL
  Boolean, weather to include all Availability Zones in the region where the provider is running
  Default is `true`, set this to `false` if you would like to have specific azs
  EOL
}

variable "azs_list_names" {
  type = list(string)
  default = []
  description = "A list to include all the AZs you would like to configure such as `us-east-1a`, `us-east-1b`"
}

variable "enable_nat_gateway" {
  type = bool
  default = true
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
}

variable "single_nat_gateway" {
  type = bool
  default = false
  description = <<-EOL
  Should be true if you want to provision a single shared NAT Gateway across all of your private networks
  EOL
}

variable "nat_gateway_per_az" {
  type = bool
  default = false
  description = "Should be true if you want only one NAT Gateway per availability zone."
}

variable "enable_internet_gateway" {
  type = bool
  default = true
  description = <<-EOL
  IGW, This boolean variables controls the creation of Internet Gateway
  For IGW to be created this variable and var.create_public_subnets should set to true
  EOL
}

variable "create_private_subnets" {
  type = bool
  default = true
  description = "Ability to create private subnets in all configured AZs"
}

variable "create_public_subnets" {
  type = bool
  default = true
  description = <<-EOL
  Ability to create private subnets in all configured AZs, if this set to true
  the `enable_internet_gateway` should also be true for the subnets to be associated to IGW
  EOL
}

variable "create_custom_security_group" {
  type = bool
  default = true
  description = <<-EOL
  Boolean, to enable the creation of a custom default_security_group
  if set to `false` the AWS default VPC security rule will be applied, for more reference https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html#DefaultSecurityGroup
  if set to `true` a new default security group will be created with only `egress` traffic allowed
  EOL
}

variable "cidr_block" {
  type = string
  default = "172.16.0.0/18"
  description = "VPC CIDR Block, The allowed block size is between a /16 netmask (65,536 IP addresses) and /28 netmask (16 IP addresses)."
  validation {
    condition = contains((regex("(^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\/((1[6-9])||(2[0-9]))$)", var.cidr_block)), var.cidr_block)
    error_message = "Error, The CIDR is not valid, The allowed block size is between a /16 netmask (65,536 IP addresses) and /28 netmask (16 IP addresses)."
  }
}

variable "enable_dns_hostnames" {
  type = bool
  default = true
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
}

variable "enable_dns_support" {
  type = bool
  default = true
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults true."
}

variable "enable_ipv6_cidr_block" {
  type = bool
  default = false
  description = <<-EOL
  Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses,
  or the size of the CIDR block. Default is `false`
  EOL
}

variable "default_security_group_ingress" {
  type = list(map(string))
  default = []
  description = <<-EOL
  Ingress Rules, List of maps of ingress rules to set on the default security group
  Example
  [
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group#protocol
      cidr_blocks = ["0.0.0.0/0"]
      description = "Ingress Rule to Allow port 80 protocol TCP from Anywhere"
      self = true|false # Whether the security group itself will be added as a source to this egress rule.
    }
  ]
  EOL
}

variable "default_security_group_egress" {
  type = list(map(string))
  default = [
    {
      from_port = "0"
      to_port = "0"
      protocol = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  description = <<-EOL
  Egress Rules, List of maps of ingress rules to set on the default security group
  Default egress rule is to allow all outgoing connections on any protocol.
  Example
  [
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group#protocol
      cidr_blocks = ["0.0.0.0/0"]
      description = "Ingress Rule to Allow port 80 protocol TCP from Anywhere"
      self = true|false # Whether the security group itself will be added as a source to this egress rule.
    }
  ]
  EOL
}


variable "max_subnet_count" {
  type = number
  default = 2
  description = "A Number to indicate the max subnets to be created, if not set it will create one subnet/az"
}

variable "nat_eips_list" {
  type = list(string)
  default = []
  description = "A List, of NAT IPs to be used by the NAT_GW"
}