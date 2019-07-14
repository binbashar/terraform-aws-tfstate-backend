# Terraform Module: Terraform Backend
## Overview
Terraform module to provision an S3 bucket to store terraform.tfstate file and a
DynamoDB table to lock the state file to prevent concurrent modifications and state corruption.

## Releases
- **Versions:** `<= 0.x.y` (Terraform 0.11.x compatible)
    - eg: https://registry.terraform.io/modules/binbashar/ec2-jenkins-vault/aws/0.0.1

- **Versions:** `>= 1.x.y` (Terraform 0.12.x compatible -> **WIP**)
    - eg: https://registry.terraform.io/modules/binbashar/ec2-jenkins-vault/aws/1.0.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acl | The canned ACL to apply to the S3 bucket | string | `"private"` | no |
| additional\_tag\_map | Additional tags for appending to each tag map | map | `<map>` | no |
| attributes | Additional attributes (e.g. `state`) | list | `<list>` | no |
| block\_public\_acls | Whether Amazon S3 should block public ACLs for this bucket. | string | `"false"` | no |
| block\_public\_policy | Whether Amazon S3 should block public bucket policies for this bucket. | string | `"false"` | no |
| context | Default context to use for passing state between label invocations | map | `<map>` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes` | string | `"-"` | no |
| enable\_server\_side\_encryption | Enable DynamoDB server-side encryption | string | `"true"` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | string | `""` | no |
| force\_destroy | A boolean that indicates the S3 bucket can be destroyed even if it contains objects. These objects are not recoverable | string | `"false"` | no |
| ignore\_public\_acls | Whether Amazon S3 should ignore public ACLs for this bucket. | string | `"false"` | no |
| label\_order | The naming order of the id output and Name tag | list | `<list>` | no |
| mfa\_delete | A boolean that indicates that versions of S3 objects can only be deleted with MFA. ( Terraform cannot apply changes of this value; https://github.com/terraform-providers/terraform-provider-aws/issues/629 ) | string | `"false"` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | string | `"terraform"` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | string | `""` | no |
| read\_capacity | DynamoDB read capacity units | string | `"5"` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`. By default only hyphens, letters and digits are allowed, all other chars are removed | string | `"/[^a-zA-Z0-9-]/"` | no |
| region | AWS Region the S3 bucket should reside in | string | n/a | yes |
| restrict\_public\_buckets | Whether Amazon S3 should restrict public bucket policies for this bucket. | string | `"false"` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | string | `""` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | map | `<map>` | no |
| write\_capacity | DynamoDB write capacity units | string | `"5"` | no |

## Outputs

| Name | Description |
|------|-------------|
| dynamodb\_table\_arn | DynamoDB table ARN |
| dynamodb\_table\_id | DynamoDB table ID |
| dynamodb\_table\_name | DynamoDB table name |
| s3\_bucket\_arn | S3 bucket ARN |
| s3\_bucket\_domain\_name | S3 bucket domain name |
| s3\_bucket\_id | S3 bucket ID |

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