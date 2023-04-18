resource "aws_s3_bucket" "replication_bucket" {
  count = var.bucket_replication_enabled ? 1 : 0

  # checkov:skip=CKV2_AWS_62:False Positive. This bucket is the replication destination
  # checkov:skip=CKV_AWS_144:False Positive. This bucket is the replication destination

  provider = aws.secondary
  bucket   = format("%s-%s-%s-%s", var.namespace, var.stage, var.name, var.bucket_replication_name)

  dynamic "logging" {
    for_each = var.replica_logging == null ? [] : [1]
    content {
      target_bucket = var.replica_logging["bucket_name"]
      target_prefix = var.replica_logging["prefix"]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.stage
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "replication_bucket" {
  count    = var.bucket_replication_enabled ? 1 : 0
  provider = aws.secondary
  bucket   = aws_s3_bucket.replication_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.create_kms_key ? "aws:kms" : "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "replication_bucket" {
  count    = var.bucket_replication_enabled ? 1 : 0
  provider = aws.secondary
  bucket   = aws_s3_bucket.replication_bucket[0].id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "replication_bucket" {
  provider   = aws.secondary
  depends_on = [aws_s3_bucket_versioning.replication_bucket]

  bucket = aws_s3_bucket.replication_bucket[0].id

  rule {
    id = "noncurrent_expiration"

    noncurrent_version_expiration {
      noncurrent_days = var.bucket_lifecycle_expiration
    }

    noncurrent_version_transition {
      noncurrent_days = var.bucket_lifecycle_transition_standard_ia
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = var.bucket_lifecycle_transition_glacier
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }

  rule {
    id = "Abort incomplete multipart uploads"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    status = "Enabled"
  }
}


resource "aws_s3_bucket_public_access_block" "replication_bucket" {
  count = var.bucket_replication_enabled ? 1 : 0

  provider                = aws.secondary
  bucket                  = aws_s3_bucket.replication_bucket[0].id
  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
  depends_on              = [aws_s3_bucket.replication_bucket]
}

resource "aws_iam_role" "bucket_replication" {
  count = var.bucket_replication_enabled ? 1 : 0

  provider           = aws.primary
  name               = format("%s-%s-%s-%s", var.namespace, var.stage, var.name, var.bucket_replication_name_suffix)
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

data "aws_kms_key" "secondary" {
  provider = aws.secondary

  key_id = aws_s3_bucket.default.id
}

data "aws_iam_policy_document" "bucket_replication" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["${aws_s3_bucket.default.arn}"]

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["${aws_s3_bucket.default.arn}/*"]

    actions = [
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
    ]
  }

  dynamic "statement" {
    for_each = var.create_kms_key == true ? [1] : []
    content {
      sid       = ""
      effect    = "Allow"
      resources = ["${aws_s3_bucket.replication_bucket[0].arn}/*"]

      actions = [
        "s3:GetObjectVersionForReplication"
      ]
    }
  }

  dynamic "statement" {
    for_each = var.create_kms_key  == true ? [1] : []
    content {
      sid    = ""
      effect = "Allow"
      resources = [
        aws_kms_key.primary[0].arn,
        data.aws_kms_key.secondary[0].arn
      ]

      actions = [
        "kms:Decrypt",
        "kms:Encrypt"
      ]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["${aws_s3_bucket.replication_bucket[0].arn}/*"]

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
    ]
  }
}

resource "aws_iam_policy" "bucket_replication" {
  count = var.bucket_replication_enabled ? 1 : 0

  # checkov:skip=CKV_AWS_53:
  # checkov:skip=CKV_AWS_54:
  # checkov:skip=CKV_AWS_55:
  # checkov:skip=CKV_AWS_56:

  provider = aws.primary
  name     = format("%s-%s-%s-%s", var.namespace, var.stage, var.name, var.bucket_replication_name_suffix)
  policy   = data.aws_iam_policy_document.bucket_replication.json

  depends_on = [aws_s3_bucket.replication_bucket, aws_s3_bucket_public_access_block.default, time_sleep.wait_30_secs]
}

resource "aws_iam_policy_attachment" "bucket_replication" {
  count = var.bucket_replication_enabled ? 1 : 0

  provider   = aws.primary
  name       = format("%s-%s-%s-role-policy-attachment", var.namespace, var.stage, var.name)
  roles      = [aws_iam_role.bucket_replication[0].name]
  policy_arn = aws_iam_policy.bucket_replication[0].arn
  depends_on = [aws_s3_bucket.replication_bucket, time_sleep.wait_30_secs]
}

resource "aws_s3_bucket_policy" "bucket_replication" {
  count = var.bucket_replication_enabled && var.enforce_ssl_requests ? 1 : 0

  provider = aws.secondary
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

  depends_on = [aws_s3_bucket.replication_bucket, aws_s3_bucket_public_access_block.default, time_sleep.wait_30_secs]

}
