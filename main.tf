resource "aws_s3_bucket" "default" {
  provider = aws.main_region

  bucket        = format("%s-%s-%s", var.namespace, var.stage, var.name)
  acl           = var.acl
  force_destroy = var.force_destroy

  versioning {
    enabled    = true
    mfa_delete = var.mfa_delete
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  dynamic "replication_configuration" {
    for_each = var.bucket_replication_enabled ? ["true"] : []
    content {
      role = aws_iam_role.bucket_replication[0].arn

      rules {
        id     = "standard_bucket_replication"
        prefix = ""
        status = "Enabled"

        destination {
          bucket        = aws_s3_bucket.replication_bucket[0].arn
          storage_class = "STANDARD"
        }
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.stage
  }

}

resource "aws_s3_bucket_public_access_block" "default" {
  provider                = aws.main_region
  bucket                  = aws_s3_bucket.default.id
  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_dynamodb_table" "with_server_side_encryption" {
  count = var.enable_server_side_encryption == "true" ? 1 : 0

  provider       = aws.main_region
  name           = format("%s-%s-%s", var.namespace, var.stage, var.name)
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "LockID" # https://www.terraform.io/docs/backends/types/s3.html#dynamodb_table

  server_side_encryption {
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Terraform   = "true"
    Environment = var.stage
  }
}

resource "aws_dynamodb_table" "without_server_side_encryption" {
  count = var.enable_server_side_encryption == "true" ? 0 : 1

  provider       = aws.main_region
  name           = format("%s-%s-%s", var.namespace, var.stage, var.name)
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "LockID"

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Terraform   = "true"
    Environment = var.stage
  }
}

resource "aws_s3_bucket_policy" "default" {
  count = var.enforce_ssl_requests ? 1 : 0

  provider = aws.main_region
  bucket   = aws_s3_bucket.default.id
  policy   = <<POLICY
{
  "Id": "TerraformStateBucketPolicies",
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
