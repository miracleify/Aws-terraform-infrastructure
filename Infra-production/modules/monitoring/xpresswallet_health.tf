############################################
# XpressWallet Health Check Lambda
############################################

resource "aws_lambda_function" "xpresswallet_health" {
  function_name = "${var.project_name}-xpresswallet-health-${var.environment}"

  filename         = "${path.module}/lambda/xpresswallet-health.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/xpresswallet-health.zip")

  role    = aws_iam_role.lambda_role.arn
  runtime = "nodejs20.x"
  handler = "xpresswallet-health.handler"

  timeout     = 15
  memory_size = 128

  environment {
    variables = {
      XPRESS_BASE_URL  = var.xpresswallet_base_url
      METRIC_NAMESPACE = "FintechApp/ThirdParty"
      METRIC_NAME      = "XpressWalletHealth"
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Service     = "monitoring"
  }
}