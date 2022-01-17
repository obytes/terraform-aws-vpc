
#=============#
#   V P C     #
#=============#

variable "include_all_azs" {
  type        = bool
  default     = true
  description = <<-EOL
  Boolean, weather to include all Availability Zones in the region where the provider is running
  Default is `true`, set this to `false` if you would like to have specific azs
  EOL
}

variable "azs_list_names" {
  type        = list(string)
  default     = []
  description = "A list to include all the AZs you would like to configure such as `us-east-1a`, `us-east-1b`"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = <<-EOL
  Should be true if you want to provision a single shared NAT Gateway across all of your private networks
  EOL
}

variable "nat_gateway_per_az" {
  type        = bool
  default     = false
  description = "Should be true if you want only one NAT Gateway per availability zone."
}

variable "enable_internet_gateway" {
  type        = bool
  default     = false
  description = <<-EOL
  IGW, This boolean variables controls the creation of Internet Gateway
  For IGW to be created this variable and var.create_public_subnets should set to true
  EOL
}

variable "create_private_subnets" {
  type        = bool
  default     = true
  description = "Ability to create private subnets in all configured AZs"
}

variable "create_public_subnets" {
  type        = bool
  default     = false
  description = <<-EOL
  Ability to create private subnets in all configured AZs, if this set to true
  the `enable_internet_gateway` should also be true for the subnets to be associated to IGW
  EOL
}

variable "create_custom_security_group" {
  type        = bool
  default     = true
  description = <<-EOL
  Boolean, to enable the creation of a custom default_security_group
  if set to `false` the AWS default VPC security rule will be applied, for more reference https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html#DefaultSecurityGroup
  if set to `true` a new default security group will be created with only `egress` traffic allowed
  EOL
}

variable "cidr_block" {
  type        = string
  default     = null
  description = "VPC CIDR Block, The allowed block size is between a /16 netmask (65,536 IP addresses) and /28 netmask (16 IP addresses)."
  validation {
    condition     = contains((regex("(^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\/((1[6-9])||(2[0-9]))$)", var.cidr_block)), var.cidr_block)
    error_message = "Error, The CIDR is not valid, The allowed block size is between a /16 netmask (65,536 IP addresses) and /28 netmask (16 IP addresses)."
  }
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults true."
}

variable "enable_ipv6_cidr_block" {
  type        = bool
  default     = false
  description = <<-EOL
  Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses,
  or the size of the CIDR block. Default is `false`
  EOL
}

variable "default_security_group_ingress" {
  type        = list(map(string))
  default     = []
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
      from_port   = "0"
      to_port     = "0"
      protocol    = "-1"
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
  type        = number
  default     = 0
  description = "A Number to indicate the max subnets to be created, if not set it will create one subnet/az"
}

variable "nat_eips_list" {
  type        = list(string)
  default     = []
  description = "A List, of NAT IPs to be used by the NAT_GW"
}

variable "manage_default_route_table" {
  type        = bool
  default     = true
  description = "Should be true, to manage the default route table"
}

variable "additional_default_route_table_routes" {
  type        = list(map(string))
  default     = []
  description = <<-EOL
  List, of routes to be added to the default route table ID
  Example,
  [
    {
      cidr_block = "172.17.18.19/30" # Required
      ipv6_cidr_block = "::/0" # Optional
      destination_prefix_list_id = "pl-0570a1d2d725c16be" # Optional
      #One of the following target arguments must be supplied:
      egress_only_gateway_id = ""
      gateway_id = ""
      instance_id = ""
      nat_gateway_id = ""
      vpc_peering_connection_id = ""
      vpc_endpoint_id = ""
      transit_gateway_id = ""
      network_interface_id = ""
    }
  ]
  EOL
}

variable "additional_default_route_table_tags" {
  type        = map(string)
  default     = null
  description = "Additional, map of tags to be added to the `default_route_table` tags"
}

variable "map_public_ip_on_lunch" {
  type        = bool
  default     = false
  description = "(Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false."
}

variable "additional_public_route_tags" {
  type        = map(string)
  default     = null
  description = "Additional, map of tags to be added to the public `aws_route_table` tags"
}

variable "additional_private_route_tags" {
  type        = map(string)
  default     = null
  description = "Additional, map of tags to be added to the private `aws_route_table` tags"
}

variable "additional_private_subnet_tags" {
  type        = map(string)
  default     = null
  description = "Additional, map of tags to be added to the private `aws_subnet` resources"
}

variable "additional_public_subnet_tags" {
  type        = map(string)
  default     = null
  description = "Additional, map of tags to be added to the private `aws_subnets` resources"
}

variable "route_create_timeout" {
  type        = string
  default     = "5m"
  description = "A timeout for the aws_route_table creation, default is 5m"
}

variable "route_delete_timeout" {
  type        = string
  default     = "5m"
  description = "A timeout for the aws_route_table deletion, default is 5m"
}

variable "vpc_domain_name_servers" {
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
  description = "(Optional) List of name servers to configure in /etc/resolv.conf. If you want to use the default AWS nameservers you should set this to AmazonProvidedDNS."
}

variable "vpc_dhcp_domain_name" {
  type        = string
  default     = null
  description = " (Optional) the suffix domain name to use by default when resolving non Fully Qualified Domain Names. In other words, this is what ends up being the search value in the /etc/resolv.conf file."
}

variable "vpc_dhcp_ntp_servers" {
  type        = list(string)
  default     = []
  description = "(Optional) List of NTP servers to configure."
}
variable "vpc_dhcp_netbios_name_servers" {
  type        = list(string)
  default     = []
  description = " (Optional) List of NETBIOS name servers."
}
variable "vpc_dhcp_netbios_node_type" {
  type        = number
  default     = null
  description = "(Optional) The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network. For more information about these node types, see RFC 2132."
}
