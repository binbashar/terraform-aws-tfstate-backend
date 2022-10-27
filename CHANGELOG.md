# Change Log

All notable changes to this project will be documented in this file.

<a name="unreleased"></a>
## [Unreleased]



<a name="v1.0.23"></a>
## [v1.0.23] - 2022-10-27

- Change variable for custom bucket_replication_name_suffix
- Change default value for bucket_replication_role_name
- Add variables to set custom name for S3 Replication Bucket (and Role)


<a name="v1.0.22"></a>
## [v1.0.22] - 2022-10-17

- Update README.md


<a name="v1.0.21"></a>
## [v1.0.21] - 2022-09-23

- Implement optional DynamoDB Capacity monitoring ([#21](https://github.com/binbashar/terraform-tfstate-backend/issues/21))


<a name="v1.0.20"></a>
## [v1.0.20] - 2022-09-14

- Upgrade provider version


<a name="v1.0.19"></a>
## [v1.0.19] - 2022-08-19

- Add public access block to the replication bucket ([#19](https://github.com/binbashar/terraform-tfstate-backend/issues/19))


<a name="v1.0.18"></a>
## [v1.0.18] - 2022-05-03

- Enhancement | Remove empy provider configuration block warning ([#16](https://github.com/binbashar/terraform-tfstate-backend/issues/16))


<a name="v1.0.17"></a>
## [v1.0.17] - 2021-10-08

- Create FUNDING.yml


<a name="v1.0.16"></a>
## [v1.0.16] - 2021-08-25

- Update Makefile to support terraform 0.14.11 & Terratest 14
- Add awscli setting for test-e2e-terratests
- Update Ubuntu image & awscli installation
- Upgrade CircleCI config
- Add logging support
- Set time_sleep block to 30 secs
- Fix aws_s3_bucket_public_access_block name
- Force aws_s3_bucket_public_access_block to be applied first
- Add time_sleep for the aws_iam_policy_attachment
- Fix depends_on and time_sleep order
- Add  time sleep for aws_s3_bucket_public_access_block resource
- Add timeout for aws_s3_bucket_public_access_block
- Add depends_on to aws_s3_bucket_policy resources
- Add depends_on between aws_s3_bucket_public_access_block and aws_s3_bucket_policy resources
- Add depends_on between aws_s3_bucket_public_access_block and aws_s3_bucket_policy resources
- Add depends_on between aws_s3_bucket_public_access_block and aws_s3_bucket_policy resources
- Add depends_on in IAM and bucket policies
- Add denpeds_on for aws_s3_bucket_public_access_block
- * Add depends_on the replication bucket * Update README using a newer terraform-doc


<a name="v1.0.15"></a>
## [v1.0.15] - 2020-12-18

- BBL-263 | requirement tf-0.13.2 tests implemented with tf-0.14.2
- BBL-263 | minor readme.md important consideration section sintaxt improvement
- BBL-263 | small readme.md update
- BBL-263 | make pre-commit applied - terraform format + terraform docs + documentation vpce considerations added
- BBL-263 | adding s3 service limited vpc traffic policy
- BBL-263 | applying make pre-commit to format and update README.md
- BBL-263 | adding crr-vpce test
- BBL-263 | updating examples config.tf to use terraform 0.14.2
- BBL-263 | updating vpc filtering bucket policy ids
- BBL-263 | adding optional vpc filtering via bucket policy to enforce vpce access
- BBL-263 | upgrading to terraform 0.14.2


<a name="v1.0.14"></a>
## [v1.0.14] - 2020-11-16

- BBL-440 | ci pre-commit + slack notif + makefile-lib versioned


<a name="v1.0.13"></a>
## [v1.0.13] - 2020-10-07

- fixing figures urls


<a name="v1.0.12"></a>
## [v1.0.12] - 2020-10-06

- Add support to enforce SSL requests ([#11](https://github.com/binbashar/terraform-tfstate-backend/issues/11))


<a name="v1.0.11"></a>
## [v1.0.11] - 2020-10-02

- BBL-381 | updating makefile include sintaxt + circleci sumologic integration


<a name="v1.0.10"></a>
## [v1.0.10] - 2020-09-24

- BBL-381 | upgrading circleci VM executor


<a name="v1.0.9"></a>
## [v1.0.9] - 2020-09-18

- BBL-381 | minor readme.md update


<a name="v1.0.8"></a>
## [v1.0.8] - 2020-09-18

- BBL-381 | ready to test
- BBL-381 | std repo structure + standalone makefile approach + circle job updated


<a name="v1.0.7"></a>
## [v1.0.7] - 2020-08-20

- BBL-173 | fixing conflicts
- Merge branch 'master' into BBL-173-std-structre
- BBL-173 propagating std structure


<a name="v1.0.6"></a>
## [v1.0.6] - 2020-08-20

- Merge branch 'master' of github.com:binbashar/terraform-tfstate-backend
- BBL-192 | updating .gitignore + adding .editorconfig + LICENSE + Makefile docker img ver update


<a name="v1.0.5"></a>
## [v1.0.5] - 2020-07-20

- Fix an AWS provider issue when the module is used with bucket replica… ([#8](https://github.com/binbashar/terraform-tfstate-backend/issues/8))


<a name="v1.0.4"></a>
## [v1.0.4] - 2020-01-09

- BBL-167 updating terraform fmt check validation in CircleCI job
- BBL-167 minor enhancements to address tf0.12 warnings
- BBL-167 Improving Makefile and CircleCI files sintaxt


<a name="v1.0.3"></a>
## [v1.0.3] - 2019-10-21

- BBL-119 small readme clean-up - Not more WIP already in place :)


<a name="v1.0.2"></a>
## [v1.0.2] - 2019-10-21

- BBL-119 adding region to aws test-cmd
- BBL-119 remove wrong aws cmd param
- BBL-119 fix typo in aws validation cmd.
- BBL-119 completely disabling docker cache since current circleci plan does not support this feature
- BBL-119 Disabling docker cache feature - This job has been blocked because Docker Layer Caching is not available on your plan.
- BBL-119 tflint --deep command updated
- BBL-119 terratests added + .circleci config file
- BBL-119 terraform fmt and tflint passing
- BBL-119 updating README.md with new vars and release-mgmt info
- BBL-119 updating .gitignore
- Bucket replication ([#2](https://github.com/binbashar/terraform-tfstate-backend/issues/2))


<a name="v1.0.1"></a>
## [v1.0.1] - 2019-08-24

- Updating CHANGELOG.md via make changelog-patch for v1.0.1
- Fix var.stage in tags which was not being interpolated. ([#1](https://github.com/binbashar/terraform-tfstate-backend/issues/1))
- Set theme jekyll-theme-slate
- Adding CHANGELOG.md for v1.0.0 tf-0.12.x compatiblee


<a name="v1.0.0"></a>
## [v1.0.0] - 2019-07-14

- Adding CHANGELOG.md related configs for v1.0.0 tf0.12 compatible
- readme.mds updated with passed terratests
- tf 0.12 fully supported


<a name="v0.0.4"></a>
## [v0.0.4] - 2019-07-14

- Updating readme.md


<a name="v0.0.3"></a>
## [v0.0.3] - 2019-07-14

- Updating readme.md
- resizeing images
- Adding new images for readme + example update


<a name="v0.0.2"></a>
## [v0.0.2] - 2019-07-14

- updating figures url


<a name="v0.0.1"></a>
## v0.0.1 - 2019-07-14

- Adding CHANGELOG.md related files for v0.0.1
- Adding CHANGELOG.md related files for v0.0.1
- adding module std files and readme
- Initial tf 0.11.x commit
- Updated readme with AWS custom provider instructions
- initial commit
- Initial commit


[Unreleased]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.23...HEAD
[v1.0.23]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.22...v1.0.23
[v1.0.22]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.21...v1.0.22
[v1.0.21]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.20...v1.0.21
[v1.0.20]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.19...v1.0.20
[v1.0.19]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.18...v1.0.19
[v1.0.18]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.17...v1.0.18
[v1.0.17]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.16...v1.0.17
[v1.0.16]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.15...v1.0.16
[v1.0.15]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.14...v1.0.15
[v1.0.14]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.13...v1.0.14
[v1.0.13]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.12...v1.0.13
[v1.0.12]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.11...v1.0.12
[v1.0.11]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.10...v1.0.11
[v1.0.10]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.9...v1.0.10
[v1.0.9]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.8...v1.0.9
[v1.0.8]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.7...v1.0.8
[v1.0.7]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.6...v1.0.7
[v1.0.6]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.5...v1.0.6
[v1.0.5]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.4...v1.0.5
[v1.0.4]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.3...v1.0.4
[v1.0.3]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.2...v1.0.3
[v1.0.2]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.1...v1.0.2
[v1.0.1]: https://github.com/binbashar/terraform-tfstate-backend/compare/v1.0.0...v1.0.1
[v1.0.0]: https://github.com/binbashar/terraform-tfstate-backend/compare/v0.0.4...v1.0.0
[v0.0.4]: https://github.com/binbashar/terraform-tfstate-backend/compare/v0.0.3...v0.0.4
[v0.0.3]: https://github.com/binbashar/terraform-tfstate-backend/compare/v0.0.2...v0.0.3
[v0.0.2]: https://github.com/binbashar/terraform-tfstate-backend/compare/v0.0.1...v0.0.2
