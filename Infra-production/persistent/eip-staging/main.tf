resource "aws_eip" "nat" {
  count = var.create_eip ? 1 : 0

  domain = "vpc"

  tags = {
    Name    = "staging-nat-eip"
    purpose = "stable outbound ip"
  }

  # Temporarily comment out the lifecycle block
  # lifecycle {
  #   prevent_destroy = true
  # }
}