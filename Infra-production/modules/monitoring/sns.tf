############################################
# SNS Topics
############################################

# General alerts (email only)
resource "aws_sns_topic" "alerts_email" {
  name = "${var.project_name}-alerts-email-${var.environment}"
}

# Critical alerts (email + optional channels)
resource "aws_sns_topic" "alerts_critical" {
  name = "${var.project_name}-alerts-critical-${var.environment}"
}

############################################
# Email Subscriptions
############################################

# Email for general alerts
resource "aws_sns_topic_subscription" "email_general" {
  topic_arn = aws_sns_topic.alerts_email.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Email for critical alerts
resource "aws_sns_topic_subscription" "email_critical" {
  topic_arn = aws_sns_topic.alerts_critical.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

############################################
# SMS Subscription (OPTIONAL)
############################################

resource "aws_sns_topic_subscription" "sms_critical" {
  count     = var.enable_sms ? 1 : 0
  topic_arn = aws_sns_topic.alerts_critical.arn
  protocol  = "sms"
  endpoint  = var.alert_phone
}