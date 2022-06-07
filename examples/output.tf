output "pub_subnet_ids" {
  description = "Public Subnet IDs"
  value       = module.example1.pub_subnet_ids
}

output "prv_subnet_ids" {
  description = "Private Subnet IDs"
  value       = module.example1.prv_subnet_ids
}

output "pub_subnet_cidrs" {
  description = "Public Subnet cidr_blocks"
  value       = module.example1.pub_subnet_cidrs
}

output "prv_subnet_cidrs" {
  description = "Private Subnet cidr_blocks"
  value       = module.example1.prv_subnet_cidrs
}

output "pub_route_table_ids" {
  description = "Public route table ids"
  value       = module.example1.pub_route_table_ids
}

output "prv_route_table_ids" {
  description = "private route table ids"
  value       = module.example1.prv_route_table_ids
}

output "nat_gw_ids" {
  description = "aws nat gateway id(s)"
  value       = module.example1.nat_gw_ids
}

output "elastc_ips" {
  description = "AWS eip public ips"
  value       = module.example1.elastc_ips
}

output "availability_zones" {
  description = "List of Availability Zones where subnets were created"
  value       = module.example1.availability_zones
}

output "nat_ips" {
  description = "IP Addresses in use for NAT"
  value       = module.example1.nat_ips
}

output "vpc_id" {
  value = module.example1.vpc_id
}

output "vpc_cidr_block" {
  value = module.example1.vpc_cidr_block
}

output "vpc_sg_id" {
  value = module.example1.vpc_sg_id
}

output "vpc_dhcp_dns_list" {
  value = module.example1.vpc_dhcp_dns_list
}

output "vpc_name" {
  value = module.example1.vpc_name
}