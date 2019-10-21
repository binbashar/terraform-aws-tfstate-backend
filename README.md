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
    - eg: https://registry.terraform.io/modules/binbashar/tfstate-backend/aws/0.0.1

- **Versions:** `>= 1.x.y` (Terraform 0.12.x compatible)
    - eg: https://registry.terraform.io/modules/binbashar/tfstate-backend/aws/1.0.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acl | The canned ACL to apply to the S3 bucket | string | `"private"` | no |
| additional\_tag\_map | Additional tags for appending to each tag map | map | `<map>` | no |
| attributes | Additional attributes (e.g. `state`) | list | `<list>` | no |
| block\_public\_acls | Whether Amazon S3 should block public ACLs for this bucket. | string | `"false"` | no |
| block\_public\_policy | Whether Amazon S3 should block public bucket policies for this bucket. | string | `"false"` | no |
| bucket\_replication\_enabled | Enable/Disable replica for S3 bucket (for cross region replication purpose) | string | `"false"` | no |
| bucket\_replication\_profile | AWS profile for replica bucket | string | `""` | no |
| bucket\_replication\_region | Region for replica bucket, same region or cross region could be used. | string | `""` | no |
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
#
# Terraform aws tfstate backend
#
module "terraform_state_backend" {
  source        = "../../"
  namespace     = "binbash"
  stage         = "test"
  name          = "terraform"
  attributes    = ["state"]
  region        = "us-east-1"
}

provider "aws" {
  region = "us-east-1"
  profile = "bb-dev-oaar"
}

output "s3_bucket_id" {
  value       = module.terraform_state_backend.s3_bucket_id
  description = "S3 bucket ID"
}

output "dynamodb_table_name" {
  value       = module.terraform_state_backend.dynamodb_table_name
  description = "DynamoDB table name"
}
```

# Release Management

## Docker based makefile commands
- https://cloud.docker.com/u/binbash/repository/docker/binbash/git-release
- https://github.com/binbashar/terraform-aws-tfstate-backend/blob/master/Makefile

Root directory `Makefile` has the automated steps (to be integrated with **CircleCI jobs** []() )

### CircleCi PR auto-release job
<div align="left">
  <img src="https://raw.githubusercontent.com/binbashar/terraform-aws-tfstate-backend/master/figures/circleci.png" alt="leverage-circleci" width="230"/>
</div>

- https://circleci.com/gh/binbashar/terraform-aws-tfstate-backend
- **NOTE:** Will only run after merged PR.

### Manual execution from workstation
```
$ make
Available Commands:
 - release-major-with-changelog make changelog-major && git add && git commit && make release-major
 - release-minor-with-changelog make changelog-minor && git add && git commit && make release-minor
 - release-patch-with-changelog make changelog-patch && git add && git commit && make release-patch
 ```