############################################
# Discord Lambda Function
############################################

resource "aws_lambda_function" "discord_notifier" {
  count         = var.enable_discord ? 1 : 0
  function_name = "${var.project_name}-discord-alert-${var.environment}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  filename         = "${path.module}/lambda/discord.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/discord.zip")

  environment {
    variables = {
      DISCORD_WEBHOOK_URL = var.discord_webhook_url
    }
  }
}

############################################
# SNS → Discord Lambda
############################################

resource "aws_sns_topic_subscription" "discord" {
  count     = var.enable_discord ? 1 : 0
  topic_arn = aws_sns_topic.alerts_critical.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.discord_notifier[0].arn
}

############################################
# Permission
############################################

resource "aws_lambda_permission" "discord_allow_sns" {
  count         = var.enable_discord ? 1 : 0
  statement_id  = "AllowExecutionFromSNSDiscord"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.discord_notifier[0].function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alerts_critical.arn
}