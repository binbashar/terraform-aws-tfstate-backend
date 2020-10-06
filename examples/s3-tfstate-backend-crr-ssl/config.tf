#=============================#
# AWS Provider Settings       #
#=============================#
provider "aws" {
  alias                   = "main_region"
  version                 = "~> 3.0"
  region                  = var.region
  profile                 = var.profile
  shared_credentials_file = "~/.aws/bb/config"
}

provider "aws" {
  alias                   = "secondary_region"
  version                 = "~> 3.0"
  region                  = var.region_secondary
  profile                 = var.profile
  shared_credentials_file = "~/.aws/bb/config"
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
  default     = "bb-dev-deploymaster"
}

# Uncomment for local testing
//variable "profile" {
//  type        = string
//  description = "AWS Profile"
//  default     = "bb-apps-devstg-devops"
//}

#=============================#
# Backend Config (partial)    #
#=============================#
terraform {
  required_version = ">= 0.12.28"
}
