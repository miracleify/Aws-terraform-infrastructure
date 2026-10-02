resource "aws_ecr_repository" "repo" {
  name         = var.repo_name
  force_delete = false

  #lifecycle {
  # prevent_destroy = true
  # }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = var.repo_name
    Project     = var.project_name
    Environment = var.environment
  }
}