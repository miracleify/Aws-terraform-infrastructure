resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "${var.project_name}-redis-${var.environment}"
  description          = "Redis replication group"

  engine         = "redis"
  engine_version = "7.1"
  node_type      = "cache.t4g.small"
  port           = 6379

  parameter_group_name = "default.redis7"

  automatic_failover_enabled = true
  multi_az_enabled           = true

  num_cache_clusters = 2

  subnet_group_name = aws_elasticache_subnet_group.redis.name

  security_group_ids = [
    aws_security_group.redis_sg.id
  ]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  auto_minor_version_upgrade = true

  tags = {
    Name        = "${var.project_name}-redis-${var.environment}"
    Project     = var.project_name
    Environment = var.environment
  }
}