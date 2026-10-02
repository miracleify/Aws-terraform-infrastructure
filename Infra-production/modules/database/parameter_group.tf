resource "aws_db_parameter_group" "postgres" {
  name   = "${var.project_name}-pg-${var.environment}"
  family = "postgres15"

  parameter {
    name  = "log_statement"
    value = "all"
  }

  tags = {
    Name        = "${var.project_name}-pg-${var.environment}"
    Environment = var.environment
  }
}