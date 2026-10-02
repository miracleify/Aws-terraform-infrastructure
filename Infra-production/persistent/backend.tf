terraform {
  backend "s3" {
    bucket         = "YOUR_TERRAFORM_STATE_BUCKET"
    key            = "dev/persistent-eip/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "YOUR_TERRAFORM_LOCK_TABLE"
    encrypt        = true
  }
}