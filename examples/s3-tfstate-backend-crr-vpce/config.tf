#=============================#
# AWS Provider Settings       #
#=============================#
provider "aws" {
  alias   = "main_region"
  region  = var.region
  profile = var.profile
}

provider "aws" {
  alias   = "secondary_region"
  region  = var.region_secondary
  profile = var.profile
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "region_secondary" {
  type        = string
  description = "AWS secondary Region the S3 replication bucket should reside in"
  default     = "us-east-2"
}

variable "profile" {
  type        = string
  description = "AWS Profile"
  default     = "bb-shared-deploymaster"
}

#=============================#
# Backend Config (partial)    #
#=============================#
terraform {
  required_version = ">= 1.1.9"

  required_providers {
    aws = "~> 4.0"
  }
}
