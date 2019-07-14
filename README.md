<div align="center">
    <img src="https://raw.githubusercontent.com/binbashar/terraform-aws-tfstate-backend/0.11/master/figures/binbash.png" alt="drawing" width="350"/>
</div>
<div align="right">
  <img src="https://raw.githubusercontent.com/binbashar/terraform-aws-tfstate-backend/0.11/master/figures/binbash-leverage-terraform.png" alt="leverage" width="230"/>
</div>

# Terraform Module: Terraform Backend
## Overview
Terraform module to provision an S3 bucket to store terraform.tfstate file and a
DynamoDB table to lock the state file to prevent concurrent modifications and state corruption.

<div align="left">
  <img src="https://raw.githubusercontent.com/binbashar/terraform-aws-tfstate-backend/0.11/master/figures/binbash-aws-s3-backend.png" alt="leverage" width="330"/>
</div>

### AWS Org implementation example

We have a tfstate S3 Bucket per account 
<div align="left">
  <img src="https://raw.githubusercontent.com/binbashar/terraform-aws-tfstate-backend/0.11/master/figures/binbash-aws-s3-backend-complete.png" alt="leverage" width="730"/>
</div>

## Releases
- **Versions:** `<= 0.x.y` (Terraform 0.11.x compatible)
    - eg: https://registry.terraform.io/modules/binbashar/ec2-jenkins-vault/aws/0.0.1

- **Versions:** `>= 1.x.y` (Terraform 0.12.x compatible -> **WIP**)
    - eg: https://registry.terraform.io/modules/binbashar/ec2-jenkins-vault/aws/1.0.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket\_description | S3 Bucket Description for Tagging | string | `"S3 Bucket for Terraform Remote State Storage"` | no |
| bucket\_name | S3 Bucket Name | string | `""` | no |
| replication\_profile | Profile name that will be used for creating resources on the replication region | string | `""` | no |
| replication\_region | Region name where the replication bucket will be created | string | `"us-east-1"` | no |
| table\_description | DynamoDB Table Description for Tagging | string | `"DynamoDB for Terraform Remote State Locking"` | no |
| table\_name | DynamoDB Table Name | string | `""` | no |
| table\_read\_capacity | DynamoDB Table Read Capacity | string | `"5"` | no |
| table\_write\_capacity | DynamoDB Table Write Capacity | string | `"5"` | no |

## Usage

```terraform
module "terraform_backend" {
    source = "git::git@github.com:binbashar/terraform-aws-tfstate-backend.git?ref=v0.0.2"
    bucket_name = "your-terraform-state-storage-s3"
    bucket_description  = "S3 Bucket for ${var.profile} Terraform Remote State Storage"
    table_name = "your-terraform-state-lock-dynamo"
    table_description   = "DynamoDB for ${var.profile} Terraform Remote State Locking"
    replication_region  = "us-east-2"
    replication_profile = "${var.profile}"
}
```