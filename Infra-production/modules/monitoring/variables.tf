variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix (not full ARN)"
  type        = string
}

variable "waf_name" {
  description = "WAF Web ACL name"
  type        = string
}

# Alerts selection setup

variable "alert_email" {
  type = string
}

variable "alert_phone" {
  type = string
}

variable "enable_sms" {
  type    = bool
  default = false
}

variable "enable_slack" {
  type    = bool
  default = true
}

variable "enable_discord" {
  type    = bool
  default = false
}

variable "slack_webhook_url" {
  type      = string
  sensitive = true
}

variable "discord_webhook_url" {
  type      = string
  sensitive = true
}

variable "ecs_cluster_arn" {
  type = string
}

############################################
# XpressWallet Health Check
############################################

variable "xpresswallet_base_url" {
  description = "XpressWallet production API base URL"
  type        = string
  default     = "https://payment.xpress-wallet.com/api/v1"
}

variable "xpresswallet_health_schedule" {
  description = "How often EventBridge runs the XpressWallet health check"
  type        = string
  default     = "rate(5 minutes)"
}
