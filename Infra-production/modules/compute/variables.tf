variable "project_name" {}
variable "environment" {}

variable "private_subnets" {
  type = list(string)
}

variable "ecs_sg_id" {}

variable "target_group_arn" {}


variable "ecr_image" {}

variable "secrets_arn" {
  type = string
}


variable "ecs_desired_count" {
  type = number
}

variable "app_port" {
  type = number
}


variable "node_env" {
  type = string
}

variable "autoscaling_min_capacity" {
  type    = number
  default = 3
}

variable "autoscaling_max_capacity" {
  type    = number
  default = 10
}