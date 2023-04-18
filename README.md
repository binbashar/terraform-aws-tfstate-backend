<a href="https://github.com/binbashar">
    <img src="https://raw.githubusercontent.com/binbashar/le-ref-architecture-doc/master/docs/assets/images/logos/binbash-leverage-banner.png" width="1032" align="left" alt="Binbash"/>
</a>
<br clear="left"/>

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.primary"></a> [aws.primary](#provider\_aws.primary) | ~> 4.0 |
| <a name="provider_aws.secondary"></a> [aws.secondary](#provider\_aws.secondary) | ~> 4.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.with_server_side_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table.without_server_side_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.bucket_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.bucket_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.bucket_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_s3_bucket.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.replication_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.bucket_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.default-ssl-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.replication_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [time_sleep.wait_30_secs](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_iam_policy_document.default-ssl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.default-ssl-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | The canned ACL to apply to the S3 bucket | `string` | `"private"` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to each tag map | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `state`) | `list(string)` | <pre>[<br>  "state"<br>]</pre> | no |
| <a name="input_backend_config_filename"></a> [backend\_config\_filename](#input\_backend\_config\_filename) | Name of the backend configuration file to generate. | `string` | `"backend.tf"` | no |
| <a name="input_backend_config_filepath"></a> [backend\_config\_filepath](#input\_backend\_config\_filepath) | Directory where the backend configuration file should be generated. | `string` | `""` | no |
| <a name="input_backend_config_profile"></a> [backend\_config\_profile](#input\_backend\_config\_profile) | AWS profile to use when interfacing the backend infrastructure. | `string` | `""` | no |
| <a name="input_backend_config_role_arn"></a> [backend\_config\_role\_arn](#input\_backend\_config\_role\_arn) | ARN of the AWS role to assume when interfacing the backend infrastructure, if any. | `string` | `""` | no |
| <a name="input_backend_config_state_file"></a> [backend\_config\_state\_file](#input\_backend\_config\_state\_file) | Name of the state file in the S3 bucket to use. | `string` | `"terraform.tfstate"` | no |
| <a name="input_backend_config_template_file"></a> [backend\_config\_template\_file](#input\_backend\_config\_template\_file) | Path to the template file to use when generating the backend configuration. | `string` | `""` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `false` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `false` | no |
| <a name="input_bucket_replication_enabled"></a> [bucket\_replication\_enabled](#input\_bucket\_replication\_enabled) | Enable/Disable replica for S3 bucket (for cross region replication purpose) | `bool` | `false` | no |
| <a name="input_context"></a> [context](#input\_context) | Default context to use for passing state between label invocations | `map(string)` | `{}` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| <a name="input_enable_server_side_encryption"></a> [enable\_server\_side\_encryption](#input\_enable\_server\_side\_encryption) | Enable DynamoDB server-side encryption | `bool` | `true` | no |
| <a name="input_enforce_ssl_requests"></a> [enforce\_ssl\_requests](#input\_enforce\_ssl\_requests) | Enable/Disable replica for S3 bucket (for cross region replication purpose) | `bool` | `false` | no |
| <a name="input_enforce_vpc_requests"></a> [enforce\_vpc\_requests](#input\_enforce\_vpc\_requests) | Enable/Disable VPC endpoint for S3 bucket | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | `""` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates the S3 bucket can be destroyed even if it contains objects. These objects are not recoverable | `bool` | `false` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `false` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag | `list(string)` | `[]` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | Bucket access logging configuration. | <pre>object({<br>    bucket_name = string<br>    prefix      = string<br>  })</pre> | `null` | no |
| <a name="input_mfa_delete"></a> [mfa\_delete](#input\_mfa\_delete) | A boolean that indicates that versions of S3 objects can only be deleted with MFA. ( Terraform cannot apply changes of this value; https://github.com/terraform-providers/terraform-provider-aws/issues/629 ) | `bool` | `false` | no |
| <a name="input_mfa_serial"></a> [mfa\_serial](#input\_mfa\_serial) | The serial number of the MFA device to use when deleting versions of S3 objects. Necessary if `mfa_delete` is true. | `string` | `""` | no |
| <a name="input_mfa_secret"></a> [mfa\_secret](#input\_mfa\_secret) | The number displayed on the MFA device. Necessary if `mfa_delete` is true. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `"terraform"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `""` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | DynamoDB read capacity units | `number` | `5` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`. By default only hyphens, letters and digits are allowed, all other chars are removed | `string` | `"/[^a-zA-Z0-9-]/"` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `false` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_vpc_ids_list"></a> [vpc\_ids\_list](#input\_vpc\_ids\_list) | VPC id to access the S3 bucket vía vpc endpoint. The VPCe must be in the same AWS Region as the bucket. | `list(string)` | `[]` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | DynamoDB write capacity units | `number` | `5` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | DynamoDB table ARN |
| <a name="output_dynamodb_table_id"></a> [dynamodb\_table\_id](#output\_dynamodb\_table\_id) | DynamoDB table ID |
| <a name="output_dynamodb_table_name"></a> [dynamodb\_table\_name](#output\_dynamodb\_table\_name) | DynamoDB table name |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | S3 bucket ARN |
| <a name="output_s3_bucket_domain_name"></a> [s3\_bucket\_domain\_name](#output\_s3\_bucket\_domain\_name) | S3 bucket domain name |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | S3 bucket ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Usage

```terraform
#
# Terraform aws tfstate backend
#
provider "aws" {
  region  = "us-east-1
}

provider "aws" {
  region  = "us-west-1"
  alias   = "secondary"
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
    aws.primary   = aws
    aws.secondary = aws.secondary
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

  # Notice that even though replication is not enabled, we still need to pass a secondary provider
  providers = {
    aws.primary   = aws
    aws.secondary = aws.secondary
  }
}
```

### Generating the backend configuration automatically

If you choose to include this module in your own Terraform configuration to
provision the backend supporting infrastructure, you can generate the backend
configuration file automatically with this module.

To do so, use this module as usual, but provide at least the following input:

- `backend_config_filepath = "."`

By default, this will make it so a `backend.tf` file with the backend
configuration is generated in the current working directory. Once you have
provisioned the infrastructure with `terraform init && terraform apply`, you
can copy over Terraform's state file to the backend bucket with the following
command:

```bash
terraform init -force-copy
```

Afterwards, your Terraform state will have been copied over to the S3 bucket
and Terraform is now ready to use it as a backend.

Refer to the list of `backend_config_*` inputs for more information on how to
tailor this behavior to your use case.

---

## Important consideration
When using the `enforce_vpc_requests = true` please consider the following
[AWS VPC gateway endpoint limitations](https://docs.aws.amazon.com/vpc/latest/userguide/vpce-gateway.html#vpc-endpoints-limitations)

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enforce\_vpc\_requests | Enable/Disable VPC endpoint for S3 bucket | `bool` | `false` | no |
| vpc\_ids\_list | VPC id to access the S3 bucket vía vpc endpoint. The VPCe must be in the same AWS Region as the bucket. | `list(string)` | `[]` | no |


#### To use gateway endpoints, you need to be aware of the current limitations

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
