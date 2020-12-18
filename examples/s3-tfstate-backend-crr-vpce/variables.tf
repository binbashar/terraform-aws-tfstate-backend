#==============================#
# Tf-state S3 Backend          #
#==============================#
variable "namespace" {
  type        = string
  default     = "bb"
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  default     = "qa"
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "stage" {
  type        = string
  default     = "test"
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  default     = "terraform-crr-vpce"
  description = "Solution name, e.g. 'app' or 'jenkins'"
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


variable "acl" {
  type        = string
  description = "The canned ACL to apply to the S3 bucket"
  default     = "private"
}

variable "enable_server_side_encryption" {
  type        = bool
  description = "Enable DynamoDB server-side encryption"
  default     = true
}

variable "block_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  default     = true
}

variable "block_public_policy" {
  type        = bool
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  default     = true
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  default     = true
}

variable "regex_replace_chars" {
  type        = string
  default     = "/[^a-zA-Z0-9-]/"
  description = "Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`. By default only hyphens, letters and digits are allowed, all other chars are removed"
}

variable "bucket_replication_enabled" {
  type        = bool
  description = "Enable/Disable replica for S3 bucket (for cross region replication purpose)"
  default     = true
}

variable "enforce_ssl_requests" {
  type        = bool
  description = "Enable/Disable replica for S3 bucket (for cross region replication purpose)"
  default     = false
}

variable "enforce_vpc_requests" {
  type        = bool
  description = "Enable/Disable VPC endpoint for S3 bucket"
  default     = true
}

variable "vpc_id_vpce" {
  type        = string
  description = "VPC id"
  default     = "vpc-02ed8f213c7b6d869"
}
variable "vpc_ids_list" {
  type        = list(string)
  description = "VPC id"
  default     = ["vpc-02ed8f213c7b6d869"]
}

variable "vpc_route_table_ids_list" {
  type        = list(string)
  description = "VPC route table ids"
  default     = ["rtb-0dfa681c27e8b33f5", "rtb-095aed0b9abf62536"]
}


