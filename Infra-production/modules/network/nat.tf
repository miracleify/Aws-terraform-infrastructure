resource "aws_nat_gateway" "nat" {
  allocation_id = var.nat_eip_allocation_id
  subnet_id     = aws_subnet.public[0].id


  #lifecycle {
  #  prevent_destroy = true
  # }

  tags = {
    Name        = "${var.project_name}-nat-${var.environment}"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.igw]


}