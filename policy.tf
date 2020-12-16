resource "aws_s3_bucket_policy" "default" {
  count = var.enforce_ssl_requests ? 1 : 0

  provider = aws.main_region
  bucket   = aws_s3_bucket.default.id
  policy   = <<POLICY
{
  "Id": "TerraformStateBucketPolicySSL",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnforceSSlRequestsOnly",
      "Action": "s3:*",
      "Effect": "Deny",
      "Resource": "${aws_s3_bucket.default.arn}/*",
      "Condition": {
         "Bool": {
           "aws:SecureTransport": "false"
          }
      },
      "Principal": "*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "allow_vpc" {
  count = var.enforce_vpc_requests && var.vpc_id != "" ? 1 : 0

  provider = aws.main_region
  bucket   = aws_s3_bucket.default.id
  policy   = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "TerraformStateBucketPolicySllVpc",
  "Statement": [
    {
      "Sid": "EnforceVPCRequestsOnly",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.default.arn}",
        "${aws_s3_bucket.default.arn}/*"
      ],
      "Condition": {
        "StringNotEquals": {
          "aws:sourceVpc": "${var.vpc_id}"
        }
      }
    }
  ]
}
POLICY
}
