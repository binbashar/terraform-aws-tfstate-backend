<div align="center">
    <img src="https://raw.githubusercontent.com/binbashar/terraform-aws-tfstate-backend/master/figures/binbash.png"
     alt="drawing" width="250"/>
</div>
<div align="right">
  <img src="https://raw.githubusercontent.com/binbashar/terraform-aws-tfstate-backend/master/figures/binbash-leverage-terraform.png"
   alt="leverage" width="130"/>
</div>

# Terraform Module: Terraform Backend
## Overview
Terraform module to provision an S3 bucket to store terraform.tfstate file and a
DynamoDB table to lock the state file to prevent concurrent modifications and state corruption.

<div align="left">
  <img src="https://raw.githubusercontent.com/binbashar/terraform-aws-tfstate-backend/master/figures/binbash-aws-s3-backend.png" alt="leverage" width="330"/>
</div>

### AWS Org implementation example

We have a tfstate S3 Bucket per account
<div align="left">
  <img src="https://raw.githubusercontent.com/binbashar/terraform-aws-tfstate-backend/master/figures/binbash-aws-s3-backend-complete.png" alt="leverage" width="730"/>
</div>

## Releases
- **Versions:** `<= 0.x.y` (Terraform 0.11.x compatible)
    - eg: https://registry.terraform.io/modules/binbashar/tfstate-backend/aws/0.0.1

- **Versions:** `>= 1.x.y` (Terraform 0.12.x compatible)
    - eg: https://registry.terraform.io/modules/binbashar/tfstate-backend/aws/1.0.0

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.2 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws.main\_region | ~> 3.0 |
| aws.secondary\_region | ~> 3.0 |

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
| enforce\_vpc\_requests | Enable/Disable VPC endpoint for S3 bucket | `bool` | `false` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | `""` | no |
| force\_destroy | A boolean that indicates the S3 bucket can be destroyed even if it contains objects. These objects are not recoverable | `bool` | `false` | no |
| ignore\_public\_acls | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `false` | no |
| label\_order | The naming order of the id output and Name tag | `list(string)` | `[]` | no |
| mfa\_delete | A boolean that indicates that versions of S3 objects can only be deleted with MFA. ( Terraform cannot apply changes of this value; https://github.com/terraform-providers/terraform-provider-aws/issues/629 ) | `bool` | `false` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `"terraform"` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `""` | no |
| read\_capacity | DynamoDB read capacity units | `number` | `5` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`. By default only hyphens, letters and digits are allowed, all other chars are removed | `string` | `"/[^a-zA-Z0-9-]/"` | no |
| restrict\_public\_buckets | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `false` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `""` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| vpc\_ids\_list | VPC id to access the S3 bucket vía vpc endpoint. The VPCe must be in the same AWS Region as the bucket. | `list(string)` | `[]` | no |
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

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Usage

```terraform
#
# Terraform aws tfstate backend
#
provider "aws" {
  region  = "us-east-1
  alias   = "main_region"
}

provider "aws" {
  region  = "us-west-1"
  alias   = "secondary_region"
}

# The following creates a Terraform State Backend with Bucket Replication enabled
module "terraform_state_backend_with_replication" {
  source        = "../../"
  namespace     = "binbash"
  stage         = "test"
  name          = "terraform"
  attributes    = ["state"]
  region        = "us-east-1"

  bucket_replication_enabled = true

  providers = {
    aws.main_region = aws.main_region
    aws.secondary_region = aws.secondary_region
  }
}

# The module below creates a Terraform State Backend without bucket replication
module "terraform_state_backend" {
  source        = "../../"
  namespace     = "binbash"
  stage         = "test"
  name          = "terraform-test"
  attributes    = ["state"]
  region        = "us-east-1"

  # By default replication is disabled but it shows below for the sake of the example
  bucket_replication_enabled = false

  # Notice that even though replication is not enabled, we still need to pass a secondary_region provider
  providers = {
    aws.main_region = aws.main_region
    aws.secondary_region = aws.main_region
  }
}
```

---

## Important consideration
When using the `enforce_vpc_requests = true` please consider the following 
[AWS VPC gateway endpoint limitations](https://docs.aws.amazon.com/vpc/latest/userguide/vpce-gateway.html#vpc-endpoints-limitations)

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enforce\_vpc\_requests | Enable/Disable VPC endpoint for S3 bucket | `bool` | `false` | no |
| vpc\_ids\_list | VPC id to access the S3 bucket vía vpc endpoint. The VPCe must be in the same AWS Region as the bucket. | `list(string)` | `[]` | no |


#### To use gateway endpoints, you need to be aware of the current limitations:

- You cannot use an AWS prefix list ID in an outbound rule in a network ACL to allow or deny outbound traffic
 to the service specified in an endpoint. If your network ACL rules restrict traffic, you must specify the CIDR
 block (IP address range) for the service instead. You can, however, use an AWS prefix list ID in an outbound
 security group rule. For more information, see Security groups.
- Endpoints are supported within the same Region only. You cannot create an endpoint between a VPC and a
  service in a different Region.
- Endpoints support IPv4 traffic only.
- You cannot transfer an endpoint from one VPC to another, or from one service to another.
- You have a quota on the number of endpoints you can create per VPC. For more information, see VPC endpoints.
- Endpoint connections cannot be extended out of a VPC. Resources on the other side of a VPN connection,
 VPC peering connection, transit gateway, AWS Direct Connect connection, or ClassicLink connection in your VPC
 cannot use the endpoint to communicate with resources in the endpoint service.
- You must enable DNS resolution in your VPC, or if you're using your own DNS server, ensure that
 DNS requests to the required service (such as Amazon S3) are resolved correctly to the IP addresses
 maintained by AWS.

## Binbash Leverage | DevOps Automation Code Library Integration

In order to get the full automated potential of the
[Binbash Leverage DevOps Automation Code Library](https://leverage.binbash.com.ar/how-it-works/code-library/code-library/)  
you should initialize all the necessary helper **Makefiles**.

#### How?
You must execute the `make init-makefiles` command  at the root context

```shell
╭─delivery at delivery-I7567 in ~/terraform/terraform-aws-backup-by-tags on master✔ 20-09-17
╰─⠠⠵ make
Available Commands:
 - init-makefiles     initialize makefiles

```

### Why?
You'll get all the necessary commands to automatically operate this module via a dockerized approach,
example shown below

```shell
╭─delivery at delivery-I7567 in ~/terraform/terraform-aws-backup-by-tags on master✔ 20-09-17
╰─⠠⠵ make
Available Commands:
 - circleci-validate-config  ## Validate A CircleCI Config (https
 - format-check        ## The terraform fmt is used to rewrite tf conf files to a canonical format and style.
 - format              ## The terraform fmt is used to rewrite tf conf files to a canonical format and style.
 - tf-dir-chmod        ## run chown in ./.terraform to gran that the docker mounted dir has the right permissions
 - version             ## Show terraform version
 - init-makefiles      ## initialize makefiles
```

```shell
╭─delivery at delivery-I7567 in ~/terraform/terraform-aws-backup-by-tags on master✔ 20-09-17
╰─⠠⠵ make format-check
docker run --rm -v /home/delivery/Binbash/repos/Leverage/terraform/terraform-aws-backup-by-tags:"/go/src/project/":rw -v :/config -v /common.config:/common-config/common.config -v ~/.ssh:/root/.ssh -v ~/.gitconfig:/etc/gitconfig -v ~/.aws/bb:/root/.aws/bb -e AWS_SHARED_CREDENTIALS_FILE=/root/.aws/bb/credentials -e AWS_CONFIG_FILE=/root/.aws/bb/config --entrypoint=/bin/terraform -w "/go/src/project/" -it binbash/terraform-awscli-slim:0.12.28 fmt -check
```

# Release Management
### CircleCi PR auto-release job

<div align="left">
  <img src="https://raw.githubusercontent.com/binbashar/terraform-aws-tfstate-backend/master/figures/circleci.png"
   alt="leverage-circleci" width="130"/>
</div>

- [**pipeline-job**](https://circleci.com/gh/binbashar/terraform-aws-tfstate-backend) (**NOTE:** Will only run after merged PR)
- [**releases**](https://github.com/binbashar/terraform-aws-tfstate-backend/releases)
- [**changelog**](https://github.com/binbashar/terraform-aws-tfstate-backend/blob/master/CHANGELOG.md)
