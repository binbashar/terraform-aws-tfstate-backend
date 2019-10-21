#=============================#
# AWS Provider Settings       #
#=============================#
provider "aws" {
  region  = var.region
  profile = var.profile
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS Profile"
  default     = "bb-dev-deploymaster"
}

#=============================#
# Backend Config (partial)    #
#=============================#
terraform {
  required_version = ">= 0.12.12"
}

#==============================#
# Tf-state S3 Backend          #
#==============================#
variable "namespace" {
  type        = "string"
  default     = "bb"
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = "string"
  default     = "qa"
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "stage" {
  type        = "string"
  default     = "test"
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = "string"
  default     = "terraform"
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "attributes" {
  type        = "list"
  default     = ["state"]
  description = "Additional attributes (e.g. `state`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}


variable "acl" {
  type        = "string"
  description = "The canned ACL to apply to the S3 bucket"
  default     = "private"
}

variable "enable_server_side_encryption" {
  description = "Enable DynamoDB server-side encryption"
  default     = "true"
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  default     = true
}

variable "regex_replace_chars" {
  type        = "string"
  default     = "/[^a-zA-Z0-9-]/"
  description = "Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`. By default only hyphens, letters and digits are allowed, all other chars are removed"
}

variable "bucket_replication_enabled" {
  description = "Enable/Disable replica for S3 bucket (for cross region replication purpose)"
  default     = true
}

variable "bucket_replication_region" {
  description = "Region for replica bucket, same region or cross region could be used."
  default     = "us-east-2"
}

variable "bucket_replication_profile" {
  description = "AWS profile for replica bucket"
  default     = "bb-dev-deploymaster"
}