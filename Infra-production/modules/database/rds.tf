resource "aws_db_instance" "postgres" {
  identifier = "${var.project_name}-db-${var.environment}"

  engine         = "postgres"
  engine_version = "15"
  instance_class = "db.t4g.micro"

  allocated_storage = 20

  db_name  = "fintechapp"
  username = var.db_username
  password = var.db_password

  # 🔐 SECURITY
  publicly_accessible    = false
  vpc_security_group_ids = [var.rds_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name

  # 🔐 ENCRYPTION
  storage_encrypted = true

  # 📦 BACKUP
  backup_retention_period = 1
  skip_final_snapshot     = true # dev only

  # ⚙️ PARAMETER GROUP
  parameter_group_name = aws_db_parameter_group.postgres.name

  tags = {
    Name        = "${var.project_name}-rds-${var.environment}"
    Environment = var.environment
  }
}