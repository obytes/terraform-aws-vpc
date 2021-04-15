output "pub_subnet_ids" {
  description = "Public Subnet IDs"
  value       = aws_subnet.public.*.id
}

output "prv_subnet_ids" {
  description = "Private Subnet IDs"
  value       = aws_subnet.private.*.id
}

output "pub_subnet_cidrs" {
  description = "Public Subnet cidr_blocks"
  value       = aws_subnet.public.*.cidr_block
}

output "prv_subnet_cidrs" {
  description = "Private Subnet cidr_blocks"
  value       = aws_subnet.private.*.cidr_block
}

output "pub_route_table_ids" {
  description = "Public route table ids"
  value       = aws_route_table.public.*.id
}

output "prv_route_table_ids" {
  description = "private route table ids"
  value       = aws_route_table.private.*.id
}

output "nat_gw_ids" {
  description = "aws nat gateway id(s)"
  value       = aws_nat_gateway._.*.id
}

output "elastc_ips" {
  description = "AWS eip public ips"
  value       = aws_eip._.*.public_ip
}

output "availability_zones" {
  description = "List of Availability Zones where subnets were created"
  value       = signum(length(var.azs_list_names)) == 1 ? var.azs_list_names : data.aws_availability_zones.azs.names
}

output "nat_ips" {
  description = "IP Addresses in use for NAT"
  value       = coalescelist(data.aws_eip._.*.public_ip, var.nat_eips_list, aws_eip._.*.public_ip)
}

output "vpc_cidr_block" {
  value       = var.cidr_block
  description = "CIDR Block of the VPC"
}

output "vpc_id" {
  value       = aws_vpc._.*.id
  description = "VPC ID"
}

output "vpc_sg_id" {
  value = aws_default_security_group._.*.id
}

output "vpc_dhcp_dns_list" {
  value = aws_vpc_dhcp_options._.*.domain_name_servers
}
