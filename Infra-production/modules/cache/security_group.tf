resource "aws_security_group" "redis_sg" {
  name        = "${var.project_name}-redis-sg-${var.environment}"
  description = "Allow Redis access from ECS only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.ecs_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-redis-sg-${var.environment}"
    Project     = var.project_name
    Environment = var.environment
  }
}