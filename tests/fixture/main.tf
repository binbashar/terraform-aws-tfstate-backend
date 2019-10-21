#
# Define some input just to show how variables can be passed from the test.
#
#variable "countries" {
#    description = "Countries"
#    default     = "AR,BR,CH"
#}

#
# Instantiate the module.
#
#module "backend" {
#    source      = "../../"
#    
#    countries   = "${var.countries}"
#}

#
# Output the module's output for verification.
#
#output "countries" {
#    value = "${module.sample.countries}"
#}

module "terraform_state_backend" {
  source                        = "../../"
  namespace                     = var.namespace
  environment                   = var.environment
  stage                         = var.stage
  name                          = var.name
  attributes                    = var.attributes
  region                        = var.region
  bucket_replication_enabled    = var.bucket_replication_enabled
  bucket_replication_region     = var.bucket_replication_region
  bucket_replication_profile    = var.bucket_replication_profile
  acl                           = var.acl
  block_public_acls             = var.block_public_acls
  block_public_policy           = var.block_public_policy
  enable_server_side_encryption = var.enable_server_side_encryption
  restrict_public_buckets       = var.restrict_public_buckets
  tags                          = var.tags
}
