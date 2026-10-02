############################################
# ECS Deployment Success Event
############################################
resource "aws_cloudwatch_event_rule" "ecs_deployment_success" {
  name        = "${var.project_name}-ecs-deployment-success-${var.environment}"
  description = "Capture successful ECS deployments"

  event_pattern = jsonencode({
    source = ["aws.ecs"]

    detail-type = [
      "ECS Deployment State Change"
    ]

    detail = {
      eventName = [
        "SERVICE_DEPLOYMENT_COMPLETED"
      ]

      clusterArn = [
        var.ecs_cluster_arn
      ]
    }
  })
}

############################################
# EventBridge → SNS
############################################
resource "aws_cloudwatch_event_target" "ecs_deployment_success_target" {
  rule      = aws_cloudwatch_event_rule.ecs_deployment_success.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.alerts_critical.arn
}

############################################
# Allow EventBridge To Publish To SNS
############################################
resource "aws_sns_topic_policy" "eventbridge_sns_policy" {
  arn = aws_sns_topic.alerts_critical.arn

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowEventBridgePublish"
        Effect = "Allow"

        Principal = {
          Service = "events.amazonaws.com"
        }

        Action = "sns:Publish"

        Resource = aws_sns_topic.alerts_critical.arn
      }
    ]
  })
}


############################################
# ECS Deployment Started Event
############################################
resource "aws_cloudwatch_event_rule" "ecs_deployment_started" {
  name        = "${var.project_name}-ecs-deployment-started-${var.environment}"
  description = "Capture ECS deployment start events"

  event_pattern = jsonencode({
    source = ["aws.ecs"]

    detail-type = [
      "ECS Deployment State Change"
    ]

    detail = {
      eventName = [
        "SERVICE_DEPLOYMENT_IN_PROGRESS"
      ]

      clusterArn = [
        var.ecs_cluster_arn
      ]
    }
  })
}

############################################
# EventBridge → SNS
############################################
resource "aws_cloudwatch_event_target" "ecs_deployment_started_target" {
  rule      = aws_cloudwatch_event_rule.ecs_deployment_started.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.alerts_critical.arn
}




############################################
# ECS Deployment Failed Event
############################################
resource "aws_cloudwatch_event_rule" "ecs_deployment_failed" {
  name        = "${var.project_name}-ecs-deployment-failed-${var.environment}"
  description = "Capture failed ECS deployments"

  event_pattern = jsonencode({
    source = ["aws.ecs"]

    detail-type = [
      "ECS Deployment State Change"
    ]

    detail = {
      eventName = [
        "SERVICE_DEPLOYMENT_FAILED"
      ]

      clusterArn = [
        var.ecs_cluster_arn
      ]
    }
  })
}

############################################
# EventBridge → SNS
############################################
resource "aws_cloudwatch_event_target" "ecs_deployment_failed_target" {
  rule      = aws_cloudwatch_event_rule.ecs_deployment_failed.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.alerts_critical.arn
}



############################################
# XpressWallet Health Check Schedule
############################################

resource "aws_cloudwatch_event_rule" "xpresswallet_health_schedule" {
  name                = "${var.project_name}-xpresswallet-health-${var.environment}"
  description         = "Run XpressWallet health check every 5 minutes"
  schedule_expression = var.xpresswallet_health_schedule
}

############################################
# EventBridge -> Lambda
############################################

resource "aws_cloudwatch_event_target" "xpresswallet_health_target" {
  rule      = aws_cloudwatch_event_rule.xpresswallet_health_schedule.name
  target_id = "RunXpressWalletHealthCheck"
  arn       = aws_lambda_function.xpresswallet_health.arn
}

############################################
# Allow EventBridge To Invoke Lambda
############################################

resource "aws_lambda_permission" "allow_eventbridge_xpresswallet" {
  statement_id  = "AllowExecutionFromEventBridgeXpressWallet"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.xpresswallet_health.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.xpresswallet_health_schedule.arn
}