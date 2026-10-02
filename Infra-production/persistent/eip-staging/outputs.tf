output "allocation_id" {
  value = var.create_eip ? aws_eip.nat[0].id : null
}

output "public_ip" {
  value = var.create_eip ? aws_eip.nat[0].public_ip : null
}