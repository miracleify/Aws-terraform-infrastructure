############################################
# Slack Lambda Function
############################################

resource "aws_lambda_function" "slack_notifier" {
  count         = var.enable_slack ? 1 : 0
  function_name = "${var.project_name}-slack-alert-${var.environment}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  filename         = "${path.module}/lambda/slack.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/slack.zip")

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }
}

############################################
# SNS → Lambda Subscription
############################################

resource "aws_sns_topic_subscription" "slack" {
  count     = var.enable_slack ? 1 : 0
  topic_arn = aws_sns_topic.alerts_critical.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.slack_notifier[0].arn
}

############################################
# Permission for SNS to invoke Lambda
############################################

resource "aws_lambda_permission" "allow_sns" {
  count         = var.enable_slack ? 1 : 0
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.slack_notifier[0].function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alerts_critical.arn
}