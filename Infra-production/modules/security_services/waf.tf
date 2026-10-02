resource "aws_wafv2_web_acl" "main" {
  name        = "${var.project_name}-waf-${var.environment}"
  description = "WAF for ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-waf-${var.environment}"
    sampled_requests_enabled   = true
  }

  # =========================================================
  # Avatar Upload Rate Protection
  # =========================================================
  rule {
    name     = "avatar-upload-rate-limit"
    priority = 0

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 100
        aggregate_key_type = "IP"

        scope_down_statement {
          byte_match_statement {
            search_string = "/api/v1/users/avatar"

            field_to_match {
              uri_path {}
            }

            positional_constraint = "EXACTLY"

            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "avatar-upload-rate-limit"
      sampled_requests_enabled   = true
    }
  }

  # =========================================================
  # TEMP FIX: Allow product upload endpoint
  # =========================================================
  rule {
    name     = "allow-product-upload-bypass"
    priority = 5

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        search_string = "/api/v1/products"

        field_to_match {
          uri_path {}
        }

        positional_constraint = "STARTS_WITH"

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allow-product-upload-bypass"
      sampled_requests_enabled   = true
    }
  }



  # =========================================================
  # Auth Login Rate Protection
  # =========================================================
  rule {
    name     = "auth-login-rate-limit"
    priority = 6

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 20
        aggregate_key_type = "IP"

        scope_down_statement {
          byte_match_statement {
            search_string = "/api/v1/auth/login"

            field_to_match {
              uri_path {}
            }

            positional_constraint = "EXACTLY"

            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "auth-login-rate-limit"
      sampled_requests_enabled   = true
    }
  }

  # =========================================================
  # Registration OTP Send Protection
  # =========================================================
  rule {
    name     = "auth-register-send-otp-rate-limit"
    priority = 7

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10
        aggregate_key_type = "IP"

        scope_down_statement {
          byte_match_statement {
            search_string = "/api/v1/auth/register/send-otp"

            field_to_match {
              uri_path {}
            }

            positional_constraint = "EXACTLY"

            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "auth-register-send-otp-rate-limit"
      sampled_requests_enabled   = true
    }
  }

  # =========================================================
  # Registration OTP Verify Protection
  # =========================================================
  rule {
    name     = "auth-register-verify-otp-rate-limit"
    priority = 8

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10
        aggregate_key_type = "IP"

        scope_down_statement {
          byte_match_statement {
            search_string = "/api/v1/auth/register/verify-otp"

            field_to_match {
              uri_path {}
            }

            positional_constraint = "EXACTLY"

            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "auth-register-verify-otp-rate-limit"
      sampled_requests_enabled   = true
    }
  }

  # =========================================================
  # Forgot Password Protection
  # =========================================================
  rule {
    name     = "auth-forgot-password-rate-limit"
    priority = 9

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10
        aggregate_key_type = "IP"

        scope_down_statement {
          byte_match_statement {
            search_string = "/api/v1/auth/forgot-password"

            field_to_match {
              uri_path {}
            }

            positional_constraint = "EXACTLY"

            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "auth-forgot-password-rate-limit"
      sampled_requests_enabled   = true
    }
  }







  # =========================================================
  # Rate limiting
  # =========================================================
  rule {
    name     = "rate-limit-global"
    priority = 10

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit-global"
      sampled_requests_enabled   = true
    }
  }

  # =========================================================
  # AWS Managed Rule: Common threats
  # =========================================================
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          name = "SizeRestrictions_BODY"

          action_to_use {
            count {}
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "common-rules"
      sampled_requests_enabled   = true
    }
  }

  # =========================================================
  # Known bad inputs (SQLi, XSS, etc)
  # =========================================================
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "bad-inputs"
      sampled_requests_enabled   = true
    }
  }

  # =========================================================
  # IP reputation (botnets, attackers)
  # =========================================================
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "ip-reputation"
      sampled_requests_enabled   = true
    }
  }
}

# =========================================================
# WAF → ALB Association
# =========================================================
resource "aws_wafv2_web_acl_association" "alb_assoc" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}


# =========================================================
# WAF CloudWatch Log Group
# =========================================================
resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "aws-waf-logs-${var.project_name}-${var.environment}"
  retention_in_days = 30
}

# =========================================================
# WAF Logging Configuration
# =========================================================
resource "aws_wafv2_web_acl_logging_configuration" "main" {
  resource_arn = aws_wafv2_web_acl.main.arn

  log_destination_configs = [
    aws_cloudwatch_log_group.waf_logs.arn
  ]
}