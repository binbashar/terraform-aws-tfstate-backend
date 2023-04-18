resource "aws_s3_bucket" "default" {
  provider = aws.primary

  bucket        = format("%s-%s-%s", var.namespace, var.stage, var.name)
  force_destroy = var.force_destroy

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

  dynamic "logging" {
    for_each = var.logging == null ? [] : [1]
    content {
      target_bucket = var.logging["bucket_name"]
      target_prefix = var.logging["prefix"]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.stage
  }

  depends_on = [aws_s3_bucket.replication_bucket]
}

resource "aws_s3_bucket_acl" "default" {
  provider = aws.primary
  bucket   = aws_s3_bucket.default.id
  acl      = var.acl
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  count    = var.create_kms_key ? 1 : 0
  provider = aws.primary

  bucket = aws_s3_bucket.default.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.id
      sse_algorithm     = var.create_kms_key ? "aws:kms" : "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "default" {
  provider = aws.primary
  bucket   = aws_s3_bucket.default.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = var.mfa_delete ? "Enabled" : "Disabled"
  }

  mfa = var.mfa_delete ? "${var.mfa_serial} ${var.mfa_secret}" : null
}

resource "aws_s3_bucket_lifecycle_configuration" "default" {
  provider   = aws.primary
  depends_on = [aws_s3_bucket_versioning.default]

  bucket = aws_s3_bucket.default.id

  rule {
    id = "Noncurrent expiration"

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

resource "aws_s3_bucket_public_access_block" "default" {
  provider                = aws.primary
  bucket                  = aws_s3_bucket.default.id
  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
  depends_on              = [aws_s3_bucket.default]
}

resource "time_sleep" "wait_30_secs" {
  create_duration = "30s"
  depends_on      = [aws_s3_bucket_public_access_block.default]
}

resource "aws_dynamodb_table" "with_server_side_encryption" {
  count = var.enable_server_side_encryption == "true" ? 1 : 0

  provider       = aws.primary
  name           = format("%s-%s-%s", var.namespace, var.stage, var.name)
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  billing_mode   = var.billing_mode
  hash_key       = "LockID" # https://www.terraform.io/docs/backends/types/s3.html#dynamodb_table

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
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

  # checkov:skip=CKV_AWS_119:This resource is intended to be used with server side encryption disabled

  provider       = aws.primary
  name           = format("%s-%s-%s", var.namespace, var.stage, var.name)
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  billing_mode   = var.billing_mode
  hash_key       = "LockID"
  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
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

locals {
  dynamodb_monitoring_enabled       = try(var.dynamodb_monitoring["enabled"], false)
  dynamodb_monitoring_threshold     = try(var.dynamodb_monitoring["threshold"], "1")
  dynamodb_monitoring_alarm_actions = try(var.dynamodb_monitoring["alarm_action_arn"], [])
  dynamodb_monitoring_table_name    = var.enable_server_side_encryption == "true" ? aws_dynamodb_table.with_server_side_encryption[0].id : aws_dynamodb_table.without_server_side_encryption[0].id
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_capacity" {
  count               = local.dynamodb_monitoring_enabled ? 1 : 0
  provider            = aws.primary
  alarm_name          = format("%s-%s-%s-%s", var.namespace, var.stage, var.name, "dynamodb-capacity-utilization")
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "ConsumedWriteCapacityUnits"
  namespace           = "AWS/DynamoDB"
  period              = "300"
  statistic           = "Average"
  threshold           = local.dynamodb_monitoring_threshold
  dimensions = {
    TableName = local.dynamodb_monitoring_table_name
  }
  alarm_description         = "This metric monitors DynamoDB capacity utilization"
  insufficient_data_actions = []
  alarm_actions             = local.dynamodb_monitoring_alarm_actions
}
