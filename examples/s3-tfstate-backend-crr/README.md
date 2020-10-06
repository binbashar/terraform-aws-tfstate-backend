# Terraform Module: Terraform Backend
## Overview
Terraform module to provision an S3 bucket to store terraform.tfstate file and a
DynamoDB table to lock the state file to prevent concurrent modifications and state corruption.

## Releases
- **Versions:** `<= 0.x.y` (Terraform 0.11.x compatible)
    - eg: https://registry.terraform.io/modules/binbashar/ec2-jenkins-vault/aws/0.0.1

- **Versions:** `>= 1.x.y` (Terraform 0.12.x compatible -> **WIP**)
    - eg: https://registry.terraform.io/modules/binbashar/ec2-jenkins-vault/aws/1.0.0

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.28 |
| aws | ~> 2.70 |

## Providers

| Name | Version |
|------|---------|
| aws.main\_region | ~> 2.70 |
| aws.secondary\_region | ~> 2.70 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acl | The canned ACL to apply to the S3 bucket | `string` | `"private"` | no |
| additional\_tag\_map | Additional tags for appending to each tag map | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `state`) | `list(string)` | <pre>[<br>  "state"<br>]</pre> | no |
| block\_public\_acls | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `false` | no |
| block\_public\_policy | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `false` | no |
| bucket\_replication\_enabled | Enable/Disable replica for S3 bucket (for cross region replication purpose) | `bool` | `false` | no |
| context | Default context to use for passing state between label invocations | `map(string)` | `{}` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| enable\_server\_side\_encryption | Enable DynamoDB server-side encryption | `bool` | `true` | no |
| enforce\_ssl\_requests | Enable/Disable replica for S3 bucket (for cross region replication purpose) | `bool` | `false` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | `""` | no |
| force\_destroy | A boolean that indicates the S3 bucket can be destroyed even if it contains objects. These objects are not recoverable | `bool` | `false` | no |
| ignore\_public\_acls | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `false` | no |
| label\_order | The naming order of the id output and Name tag | `list(string)` | `[]` | no |
| mfa\_delete | A boolean that indicates that versions of S3 objects can only be deleted with MFA. ( Terraform cannot apply changes of this value; https://github.com/terraform-providers/terraform-provider-aws/issues/629 ) | `bool` | `false` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `"terraform"` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `""` | no |
| read\_capacity | DynamoDB read capacity units | `number` | `5` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`. By default only hyphens, letters and digits are allowed, all other chars are removed | `string` | `"/[^a-zA-Z0-9-]/"` | no |
| region | AWS Region the S3 bucket should reside in | `string` | n/a | yes |
| restrict\_public\_buckets | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `false` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `""` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| write\_capacity | DynamoDB write capacity units | `number` | `5` | no |

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

Check this example code as reference usage.
