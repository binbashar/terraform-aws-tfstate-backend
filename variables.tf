variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "stage" {
  type        = string
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  default     = "terraform"
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = ["state"]
  description = "Additional attributes (e.g. `state`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "additional_tag_map" {
  type        = map(string)
  default     = {}
  description = "Additional tags for appending to each tag map"
}

variable "context" {
  type        = map(string)
  default     = {}
  description = "Default context to use for passing state between label invocations"
}

variable "label_order" {
  type        = list(string)
  default     = []
  description = "The naming order of the id output and Name tag"
}

variable "acl" {
  type        = string
  description = "The canned ACL to apply to the S3 bucket"
  default     = "private"
}

variable "read_capacity" {
  type        = number
  default     = 5
  description = "DynamoDB read capacity units"
}

variable "write_capacity" {
  type        = number
  default     = 5
  description = "DynamoDB write capacity units"
}

variable "force_destroy" {
  type        = bool
  description = "A boolean that indicates the S3 bucket can be destroyed even if it contains objects. These objects are not recoverable"
  default     = false
}

variable "mfa_delete" {
  type        = bool
  description = "A boolean that indicates that versions of S3 objects can only be deleted with MFA. ( Terraform cannot apply changes of this value; https://github.com/terraform-providers/terraform-provider-aws/issues/629 )"
  default     = false
}

variable "mfa_serial" {
  type        = string
  description = "The serial number of the MFA device to use. Necessary when mfa_delete is true."
  default     = ""
}

variable "mfa_secret" {
  type        = string
  description = "The numbers displayed on the MFA device when applying. Necessary when mfa_delete is true."
  default     = ""
}

variable "enable_server_side_encryption" {
  type        = bool
  description = "Enable DynamoDB server-side encryption"
  default     = true
}

variable "block_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  default     = false
}

variable "ignore_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  default     = false
}

variable "block_public_policy" {
  type        = bool
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  default     = false
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  default     = false
}

variable "regex_replace_chars" {
  type        = string
  default     = "/[^a-zA-Z0-9-]/"
  description = "Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`. By default only hyphens, letters and digits are allowed, all other chars are removed"
}

variable "bucket_replication_enabled" {
  type        = bool
  description = "Enable/Disable replica for S3 bucket (for cross region replication purpose)"
  default     = false
}

variable "bucket_replication_name" {
  type        = string
  default     = "replica"
  description = "Set custom name for S3 Bucket Replication"
}

variable "bucket_replication_name_suffix" {
  type        = string
  default     = "bucket-replication"
  description = "Set custom suffix for S3 Bucket Replication IAM Role/Policy"
}

variable "enforce_ssl_requests" {
  type        = bool
  description = "Enable/Disable replica for S3 bucket (for cross region replication purpose)"
  default     = false
}

variable "enforce_vpc_requests" {
  type        = bool
  description = "Enable/Disable VPC endpoint for S3 bucket"
  default     = false
}

variable "vpc_ids_list" {
  type        = list(string)
  description = "VPC id to access the S3 bucket vía vpc endpoint. The VPCe must be in the same AWS Region as the bucket."
  default     = []
}

variable "logging" {
  type = object({
    bucket_name = string
    prefix      = string
  })
  default     = null
  description = "Bucket access logging configuration."
}

#
# Example:
#  {
#    enabled          = true
#    threshold        = "2"
#    alarm_action_arn = [
#      "arn:aws:sns:us-east-1:000000000000:your-sns-topic"
#    ]
#  }
variable "dynamodb_monitoring" {
  type        = any
  description = "DynamoDB monitoring settings."
  default     = {}
}

variable "backend_config_template_file" {
  type        = string
  description = "Path to the template file to use when generating the backend configuration."
  default     = ""
}

variable "backend_config_filepath" {
  type        = string
  description = "Directory where the backend configuration file should be generated."
  default     = ""
}

variable "backend_config_filename" {
  type        = string
  description = "Name of the backend configuration file to generate."
  default     = "backend.tf"
}

variable "backend_config_profile" {
  type        = string
  description = "AWS profile to use when interfacing the backend infrastructure."
  default     = ""
}

variable "backend_config_role_arn" {
  type        = string
  description = "ARN of the AWS role to assume when interfacing the backend infrastructure, if any."
  default     = ""
}

variable "backend_config_state_file" {
  type        = string
  description = "Name of the state file in the S3 bucket to use."
  default     = "terraform.tfstate"
}
