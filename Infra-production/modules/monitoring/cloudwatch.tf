############################################
# ECS CPU (GENERAL → Email only)
############################################
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${var.project_name}-cpu-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    ClusterName = "${var.project_name}-cluster-${var.environment}"
    ServiceName = "${var.project_name}-service-${var.environment}"
  }

  alarm_description = "ECS CPU usage too high"

  alarm_actions = [
    aws_sns_topic.alerts_email.arn
  ]
}

############################################
# ECS Memory (GENERAL → Email only)
############################################
resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  alarm_name          = "${var.project_name}-memory-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    ClusterName = "${var.project_name}-cluster-${var.environment}"
    ServiceName = "${var.project_name}-service-${var.environment}"
  }

  alarm_description = "ECS memory usage too high"

  alarm_actions = [
    aws_sns_topic.alerts_email.arn
  ]
}

############################################
# ALB 5XX Errors (CRITICAL → Slack + Email)
############################################
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.project_name}-alb-5xx-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_description = "ALB returning too many 5xx errors"

  alarm_actions = [
    aws_sns_topic.alerts_critical.arn,
    aws_sns_topic.alerts_email.arn
  ]
}

############################################
# WAF Block Spike (CRITICAL → Slack + Email)
############################################
resource "aws_cloudwatch_metric_alarm" "waf_block_spike" {
  alarm_name          = "${var.project_name}-waf-block-spike-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period              = 300
  statistic           = "Sum"
  threshold           = 100

  dimensions = {
    WebACL = var.waf_name
    Region = "us-east-1"
  }

  alarm_description = "WAF blocking unusually high traffic"

  alarm_actions = [
    aws_sns_topic.alerts_critical.arn,
    aws_sns_topic.alerts_email.arn
  ]
}





############################################
# ALB High Latency (CRITICAL → Slack + Email)
############################################
resource "aws_cloudwatch_metric_alarm" "alb_high_latency" {
  alarm_name          = "${var.project_name}-alb-high-latency-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_description = "ALB target response time too high"

  alarm_actions = [
    aws_sns_topic.alerts_critical.arn,
    aws_sns_topic.alerts_email.arn
  ]
}


############################################
# ECS Running Task Count Low #ECS Deployment Failure
# (CRITICAL → Slack + Email)
############################################
resource "aws_cloudwatch_metric_alarm" "ecs_running_tasks_low" {
  alarm_name          = "${var.project_name}-ecs-running-tasks-low-${var.environment}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "RunningTaskCount"
  namespace           = "ECS/ContainerInsights"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    ClusterName = "${var.project_name}-cluster-${var.environment}"
    ServiceName = "${var.project_name}-service-${var.environment}"
  }

  alarm_description = "ECS running task count too low"

  alarm_actions = [
    aws_sns_topic.alerts_critical.arn,
    aws_sns_topic.alerts_email.arn
  ]
}


############################################
# AWS Billing Alarm
# (CRITICAL → Email Only)
############################################
resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = "${var.project_name}-billing-alarm-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = 21600 # every six hours
  statistic           = "Maximum"
  threshold           = 50

  dimensions = {
    Currency = "USD"
  }

  alarm_description = "AWS estimated charges exceeded threshold"

  alarm_actions = [
    aws_sns_topic.alerts_email.arn
  ]
}



############################################
# XpressWallet Provider Health
# (CRITICAL → Slack + Email)
############################################

resource "aws_cloudwatch_metric_alarm" "xpresswallet_health" {
  alarm_name          = "${var.project_name}-xpresswallet-health-${var.environment}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2

  metric_name = "XpressWalletHealth"
  namespace   = "FintechApp/ThirdParty"

  period    = 300
  statistic = "Minimum"
  threshold = 1

  alarm_description = "XpressWallet provider is unavailable or TLS validation failed."

  treat_missing_data = "breaching"

  alarm_actions = [
    aws_sns_topic.alerts_critical.arn,
    aws_sns_topic.alerts_email.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts_email.arn
  ]
}