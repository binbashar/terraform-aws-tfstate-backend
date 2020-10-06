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
  tags                          = var.tags

  providers = {
    aws.main_region      = aws.main_region
    aws.secondary_region = aws.secondary_region
  }
}
