output "ecr_repository_url" {
  value = module.registry.repository_url
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}


output "nat_eip_allocation_id" {
  description = "Static IP for outbound traffic (For  vendors)"
  value       = module.network.nat_eip_allocation_id
}

# database outputs (safe with toggle)
output "db_endpoint" {
  value = var.enable_rds ? module.database[0].db_endpoint : null
}

output "db_port" {
  value = var.enable_rds ? module.database[0].db_port : null
}

output "db_name" {
  value = var.enable_rds ? module.database[0].db_name : null
}


output "redis_endpoint" {
  value = module.cache.redis_endpoint
}

output "redis_port" {
  value = module.cache.redis_port
}