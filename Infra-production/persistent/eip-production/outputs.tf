output "nat_eip_allocation_id" {
  value = var.create_eip ? aws_eip.nat_static[0].id : null
}

output "nat_public_ip" {
  value = var.create_eip ? aws_eip.nat_static[0].public_ip : null
}