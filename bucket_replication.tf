resource "aws_s3_bucket" "replication_bucket" {
  count = var.bucket_replication_enabled ? 1 : 0

  provider = aws.secondary_region
  bucket   = format("%s-%s-%s-replica", var.namespace, var.stage, var.name)

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.stage
  }
}

resource "aws_iam_role" "bucket_replication" {
  count = var.bucket_replication_enabled ? 1 : 0

  provider           = aws.main_region
  name               = format("%s-%s-%s-bucket-replication-module", var.namespace, var.stage, var.name)
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "bucket_replication" {
  count = var.bucket_replication_enabled ? 1 : 0

  provider = aws.main_region
  name     = format("%s-%s-%s-bucket-replication-module", var.namespace, var.stage, var.name)
  policy   = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.default.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.default.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.replication_bucket[0].arn}/*"
    }
  ]
}
POLICY

  depends_on = [aws_s3_bucket.replication_bucket]
}

resource "aws_iam_policy_attachment" "bucket_replication" {
  count = var.bucket_replication_enabled ? 1 : 0

  provider   = aws.main_region
  name       = format("%s-%s-%s-role-policy-attachment", var.namespace, var.stage, var.name)
  roles      = [aws_iam_role.bucket_replication[0].name]
  policy_arn = aws_iam_policy.bucket_replication[0].arn
}

resource "aws_s3_bucket_policy" "bucket_replication" {
  count = var.bucket_replication_enabled && var.enforce_ssl_requests ? 1 : 0

  provider = aws.secondary_region
  bucket   = aws_s3_bucket.replication_bucket[0].id
  policy   = <<POLICY
{
  "Id": "TerraformStateBucketPolicies",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnforceSSlRequestsOnly",
      "Action": "s3:*",
      "Effect": "Deny",
      "Resource": "${aws_s3_bucket.replication_bucket[0].arn}/*",
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

  depends_on = [aws_s3_bucket.replication_bucket]

}
