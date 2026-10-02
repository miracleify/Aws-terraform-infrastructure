resource "aws_ecs_task_definition" "task" {
  family                   = "${var.project_name}-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  runtime_platform {
    cpu_architecture = "X86_64"
  }


  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = var.ecr_image
      essential = true

      portMappings = [
        {
          containerPort = var.app_port
          protocol      = "tcp"
        }
      ]

      # ✅ NON-SENSITIVE CONFIG ONLY
      environment = [
        { name = "NODE_ENV", value = var.node_env },
        { name = "PORT", value = tostring(var.app_port) },
      ]

      # 🔐 SECRETS FROM AWS SECRETS MANAGER
      secrets = [
        # For MongoDB Atlas
        { name = "MONGO_URL", valueFrom = "${var.secrets_arn}:MONGO_URL::" },

        # JWT Secret Key (use a strong random string)
        { name = "JWT_SECRET", valueFrom = "${var.secrets_arn}:JWT_SECRET::" },

        # Client and Frontend URLs
        { name = "CLIENT_URL", valueFrom = "${var.secrets_arn}:CLIENT_URL::" },
        { name = "FRONTEND_URL", valueFrom = "${var.secrets_arn}:FRONTEND_URL::" },

        # Cloudinary Configuration (for file uploads)
        { name = "CLOUDINARY_CLOUD_NAME", valueFrom = "${var.secrets_arn}:CLOUDINARY_CLOUD_NAME::" },
        { name = "CLOUDINARY_API_KEY", valueFrom = "${var.secrets_arn}:CLOUDINARY_API_KEY::" },
        { name = "CLOUDINARY_API_SECRET", valueFrom = "${var.secrets_arn}:CLOUDINARY_API_SECRET::" },

        # Paystack Payment Gateway
        { name = "PAYSTACK_SECRET_KEY", valueFrom = "${var.secrets_arn}:PAYSTACK_SECRET_KEY::" },
        { name = "PAYSTACK_TRANSFER_RECONCILE_CRON_ENABLED", valueFrom = "${var.secrets_arn}:PAYSTACK_TRANSFER_RECONCILE_CRON_ENABLED::" },

        # Email Service - Resend
        { name = "RESEND_API_KEY", valueFrom = "${var.secrets_arn}:RESEND_API_KEY::" },
        { name = "RESEND_FROM_EMAIL", valueFrom = "${var.secrets_arn}:RESEND_FROM_EMAIL::" },

        # RabbitMQ Message Queue
        { name = "RABBITMQ_URL", valueFrom = "${var.secrets_arn}:RABBITMQ_URL::" },

        #VTpass
        { name = "VTPASS_API_KEY", valueFrom = "${var.secrets_arn}:VTPASS_API_KEY::" },
        { name = "VTPASS_PUBLIC_KEY", valueFrom = "${var.secrets_arn}:VTPASS_PUBLIC_KEY::" },
        { name = "VTPASS_SECRET_KEY", valueFrom = "${var.secrets_arn}:VTPASS_SECRET_KEY::" },
        { name = "VTPASS_BASE_URL", valueFrom = "${var.secrets_arn}:VTPASS_BASE_URL::" },

        #Firebase
        { name = "FIREBASE_PROJECT_ID", valueFrom = "${var.secrets_arn}:FIREBASE_PROJECT_ID::" },
        { name = "FIREBASE_CLIENT_EMAIL", valueFrom = "${var.secrets_arn}:FIREBASE_CLIENT_EMAIL::" },
        { name = "FIREBASE_PRIVATE_KEY", valueFrom = "${var.secrets_arn}:FIREBASE_PRIVATE_KEY::" },

        #BuyPower API Credentials

        { name = "BUYPPOWER_TOKEN", valueFrom = "${var.secrets_arn}:BUYPPOWER_TOKEN::" },
        { name = "BUYPPOWER_BASE_URL", valueFrom = "${var.secrets_arn}:BUYPPOWER_BASE_URL::" },

        # QOREID
        { name = "QOREID_CLIENT_ID", valueFrom = "${var.secrets_arn}:QOREID_CLIENT_ID::" },
        { name = "QOREID_SECRET_KEY", valueFrom = "${var.secrets_arn}:QOREID_SECRET_KEY::" },
        { name = "QOREID_BASE_URL", valueFrom = "${var.secrets_arn}:QOREID_BASE_URL::" },

        # Twilio SMS / WhatsApp / Verify
        { name = "TWILIO_ACCOUNT_SID", valueFrom = "${var.secrets_arn}:TWILIO_ACCOUNT_SID::" },
        { name = "TWILIO_AUTH_TOKEN", valueFrom = "${var.secrets_arn}:TWILIO_AUTH_TOKEN::" },
        { name = "TWILIO_PHONE_NUMBER", valueFrom = "${var.secrets_arn}:TWILIO_PHONE_NUMBER::" },
        { name = "TWILIO_WHATSAPP_NUMBER", valueFrom = "${var.secrets_arn}:TWILIO_WHATSAPP_NUMBER::" },
        { name = "TWILIO_VERIFY_SERVICE_SID", valueFrom = "${var.secrets_arn}:TWILIO_VERIFY_SERVICE_SID::" },
        { name = "TWILIO_MESSAGING_SERVICE_SID", valueFrom = "${var.secrets_arn}:TWILIO_MESSAGING_SERVICE_SID::" },


        # Google Places API for Geocoding (Optional)
        { name = "GOOGLE_CLIENT_ID", valueFrom = "${var.secrets_arn}:GOOGLE_CLIENT_ID::" },
        { name = "GOOGLE_PLACES_API_KEY", valueFrom = "${var.secrets_arn}:GOOGLE_PLACES_API_KEY::" },

        # Encryption Key (must be exactly 32 characters for AES-256)
        { name = "ENCRYPTION_KEY", valueFrom = "${var.secrets_arn}:ENCRYPTION_KEY::" },

        # Xpress Service
        { name = "XPRESS_API_KEY", valueFrom = "${var.secrets_arn}:XPRESS_API_KEY::" },
        { name = "XPRESS_BASE_URL", valueFrom = "${var.secrets_arn}:XPRESS_BASE_URL::" },
        { name = "XPRESS_INBOUND_RECONCILE_CRON_ENABLED", valueFrom = "${var.secrets_arn}:XPRESS_INBOUND_RECONCILE_CRON_ENABLED::" },

        # Platform Merchant
        { name = "PLATFORM_MERCHANT_USER_ID", valueFrom = "${var.secrets_arn}:PLATFORM_MERCHANT_USER_ID::" },

        # Redis
        { name = "REDIS_HOST", valueFrom = "${var.secrets_arn}:REDIS_HOST::" },
        { name = "REDIS_PORT", valueFrom = "${var.secrets_arn}:REDIS_PORT::" },
        { name = "REDIS_TLS", valueFrom = "${var.secrets_arn}:REDIS_TLS::" },
        { name = "REDIS_ENABLED", valueFrom = "${var.secrets_arn}:REDIS_ENABLED::" },

        #fraud Alert
        { name = "FRAUD_ALERT_EMAIL_TO", valueFrom = "${var.secrets_arn}:FRAUD_ALERT_EMAIL_TO::" },
        { name = "FRAUD_ALERT_SLACK_WEBHOOK_URL", valueFrom = "${var.secrets_arn}:FRAUD_ALERT_SLACK_WEBHOOK_URL::" },


      ]

      # 📊 LOGGING (KEEP THIS)
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project_name}-${var.environment}"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}