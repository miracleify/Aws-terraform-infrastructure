resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.project_name}-redis-subnet-${var.environment}"
  subnet_ids = var.private_subnets

  tags = {
    Name        = "${var.project_name}-redis-subnet-${var.environment}"
    Project     = var.project_name
    Environment = var.environment
  }
}