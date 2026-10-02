variable "project_name" {}
variable "environment" {}

variable "alb_arn" {
  description = "ALB ARN to attach WAF"
  type        = string
}