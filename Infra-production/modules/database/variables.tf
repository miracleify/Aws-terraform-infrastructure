variable "project_name" {}
variable "environment" {}

variable "db_subnets" {
  type = list(string)
}

variable "rds_sg_id" {}

variable "db_username" {}
variable "db_password" {}