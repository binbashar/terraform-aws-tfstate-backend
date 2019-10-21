locals {
  tags = {
    Name        = "infra-tfstate-backend-test"
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}
