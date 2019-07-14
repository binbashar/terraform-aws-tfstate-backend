# Terraform Module: Terraform Backend

## Overview
A Terraform module for creating a Terraform backend for remote state storage and locking.

## Usage

```terraform
module "terraform_backend" {
    source = "../path/to/this/module"

    bucket_name = "your-terraform-state-storage-s3"
    bucket_description = "S3 Bucket for Terraform Remote State Storage"
    table_name = "your-terraform-state-lock-dynamo"
    table_description = "DynamoDB for Terraform Remote State Locking"
}
```