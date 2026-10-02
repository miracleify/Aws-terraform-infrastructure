variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "db_subnet_cidrs" {
  type = list(string)
}

variable "secrets_arn" {
  type = string
}



variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
}


variable "ecr_repo_name" {
  description = "ECR repository name"
  type        = string
}


variable "ecr_image" {
  description = "Full ECR image URI"
  type        = string
}

variable "enable_rds" {
  description = "Whether to create RDS resources"
  type        = bool
  default     = true
}

variable "ecs_desired_count" {
  type    = number
  default = 1
}

variable "autoscaling_min_capacity" {
  description = "Minimum ECS autoscaling capacity"
  type        = number
}

variable "autoscaling_max_capacity" {
  description = "Maximum ECS autoscaling capacity"
  type        = number
}



variable "app_port" {
  type    = number
  default = 3000
}

variable "nat_eip_allocation_id" {
  description = "Existing NAT EIP Allocation ID"
  type        = string
  default     = null
}

variable "node_env" {
  type = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for ALB HTTPS listener"
  type        = string
}


variable "alert_email" {
  description = "Email for monitoring alerts"
  type        = string
}

variable "alert_phone" {
  description = "Phone number for critical SMS alerts"
  type        = string
}

#slack
variable "enable_slack" {
  type    = bool
  default = true
}

variable "slack_webhook_url" {
  type      = string
  sensitive = true
}


#Discord

variable "enable_discord" {
  type    = bool
  default = false
}

variable "discord_webhook_url" {
  type      = string
  sensitive = true
}

#sms

variable "enable_sms" {
  type    = bool
  default = false
}


variable "create_eip" {
  description = "Create NAT Elastic IP"
  type        = bool
  default     = false
}