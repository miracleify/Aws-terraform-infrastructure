############################################
# CloudWatch Dashboard
############################################
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [

      ##########################################
      # ECS CPU
      ##########################################
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title   = "ECS CPU Utilization"
          view    = "timeSeries"
          stacked = false
          region  = "us-east-1"

          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              "${var.project_name}-cluster-${var.environment}",
              "ServiceName",
              "${var.project_name}-service-${var.environment}"
            ]
          ]

          stat   = "Average"
          period = 60
        }
      },

      ##########################################
      # ECS Memory
      ##########################################
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title   = "ECS Memory Utilization"
          view    = "timeSeries"
          stacked = false
          region  = "us-east-1"

          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              "${var.project_name}-cluster-${var.environment}",
              "ServiceName",
              "${var.project_name}-service-${var.environment}"
            ]
          ]

          stat   = "Average"
          period = 60
        }
      },

      ##########################################
      # ALB Request Count
      ##########################################
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title   = "ALB Request Count"
          view    = "timeSeries"
          stacked = false
          region  = "us-east-1"

          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]

          stat   = "Sum"
          period = 60
        }
      },

      ##########################################
      # ALB Latency
      ##########################################
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title   = "ALB Target Response Time"
          view    = "timeSeries"
          stacked = false
          region  = "us-east-1"

          metrics = [
            [
              "AWS/ApplicationELB",
              "TargetResponseTime",
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]

          stat   = "Average"
          period = 60
        }
      },

      ##########################################
      # ALB 5XX Errors
      ##########################################
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6

        properties = {
          title   = "ALB 5XX Errors"
          view    = "timeSeries"
          stacked = false
          region  = "us-east-1"

          metrics = [
            [
              "AWS/ApplicationELB",
              "HTTPCode_Target_5XX_Count",
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]

          stat   = "Sum"
          period = 60
        }
      },

      ##########################################
      # WAF Blocked Requests
      ##########################################
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6

        properties = {
          title   = "WAF Blocked Requests"
          view    = "timeSeries"
          stacked = false
          region  = "us-east-1"

          metrics = [
            [
              "AWS/WAFV2",
              "BlockedRequests",
              "WebACL",
              var.waf_name,
              "Region",
              "us-east-1"
            ]
          ]

          stat   = "Sum"
          period = 300
        }
      }
    ]
  })
}