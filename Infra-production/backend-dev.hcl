bucket         = "YOUR_TERRAFORM_STATE_BUCKET"
key            = "dev/infra-v2/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "YOUR_TERRAFORM_LOCK_TABLE"
encrypt        = true