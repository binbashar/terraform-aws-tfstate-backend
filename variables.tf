variable "bucket_name" {
  description = "S3 Bucket Name"
  default     = ""
}

variable "bucket_description" {
  description = "S3 Bucket Description for Tagging"
  default     = "S3 Bucket for Terraform Remote State Storage"
}

variable "table_name" {
  description = "DynamoDB Table Name"
  default     = ""
}

variable "table_description" {
  description = "DynamoDB Table Description for Tagging"
  default     = "DynamoDB for Terraform Remote State Locking"
}

variable "replication_region" {
  description = "Region name where the replication bucket will be created"
  default     = "us-east-1"
}

variable "replication_profile" {
  description = "Profile name that will be used for creating resources on the replication region"
  default     = ""
}

variable "table_read_capacity" {
  description = "DynamoDB Table Read Capacity"
  default     = 5
}

variable "table_write_capacity" {
  description = "DynamoDB Table Write Capacity"
  default     = 5
}
