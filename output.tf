output "enabled" {
  value = module.label.enabled
}

output "tags" {
  value = module.label.tags
}

output "id" {
  value = module.label.id
}

output "random_string" {
  value = module.label.random_string
}

output "nat_gateway_count" {
  value = local.nat_gateway_count
}