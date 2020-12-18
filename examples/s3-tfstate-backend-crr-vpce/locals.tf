locals {
  tags = {
    Name        = "infra-tfstate-backend-test"
    Terraform   = "true"
    Environment = var.environment
  }

  # Network Local Vars
  # https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
  # Important
  # Docker runs in the 172.17.0.0/16 CIDR range in Amazon EKS clusters. We recommend that your cluster's VPC subnets do
  # not overlap this range. Otherwise, you will receive the following error:
  # Error: : error upgrading connection: error dialing backend: dial tcp 172.17.nn.nn:10250: getsockopt: no route to host
  vpc_name       = "${var.namespace}-${var.environment}-vpc"
  vpc_cidr_block = "172.24.0.0/20"
  azs = [
    "${var.region}a",
    "${var.region}b"
  ]

  private_subnets = [
    "172.24.0.0/23",
    "172.24.2.0/23",
  ]

  public_subnets = [
    "172.24.6.0/23",
    "172.24.8.0/23",
  ]
}
