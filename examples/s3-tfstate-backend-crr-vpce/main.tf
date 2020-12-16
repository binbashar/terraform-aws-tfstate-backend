module "terraform_state_backend" {
  source                        = "../../"
  namespace                     = var.namespace
  environment                   = var.environment
  stage                         = var.stage
  name                          = var.name
  attributes                    = var.attributes
  bucket_replication_enabled    = var.bucket_replication_enabled
  acl                           = var.acl
  block_public_acls             = var.block_public_acls
  block_public_policy           = var.block_public_policy
  enable_server_side_encryption = var.enable_server_side_encryption
  restrict_public_buckets       = var.restrict_public_buckets
  enforce_ssl_requests          = var.enforce_ssl_requests
  enforce_vpc_requests          = var.enforce_vpc_requests
  tags                          = var.tags

  providers = {
    aws.main_region      = aws.main_region
    aws.secondary_region = aws.secondary_region
  }
}

#
# Configuring VPC Endpoint for S3 to be accessible from our private subnet
# without needing a NAT gateway.
#
resource "aws_vpc_endpoint" "s3" {
  provider          = aws.main_region
  vpc_id            = var.vpc_id
  vpc_endpoint_type = "Gateway"

  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = var.vpc_route_table_ids_list
}

