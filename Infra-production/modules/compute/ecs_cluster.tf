resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster-${var.environment}"

  # deeper operational telemetry metrics
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.project_name}-cluster-${var.environment}"
    Project     = var.project_name
    Environment = var.environment
  }
}