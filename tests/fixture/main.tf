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
  source        = "../../"
  namespace     = "binbash"
  stage         = "test"
  name          = "terraform"
  attributes    = ["state"]
  region        = "us-east-1"
}

provider "aws" {
  region = "us-east-1"
  profile = "bb-dev-oaar"
}

output "s3_bucket_id" {
  value       = module.terraform_state_backend.s3_bucket_id
  description = "S3 bucket ID"
}

output "dynamodb_table_name" {
  value       = module.terraform_state_backend.dynamodb_table_name
  description = "DynamoDB table name"
}


