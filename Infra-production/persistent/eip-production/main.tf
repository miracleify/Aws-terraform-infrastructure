resource "aws_eip" "nat_static" {
  count = var.create_eip ? 1 : 0

  domain = "vpc"

  tags = {
    Name    = "fintech-app-shared-nat-eip"
    Purpose = "Stable outbound IP"
  }

  lifecycle {
    prevent_destroy = true
  }
}