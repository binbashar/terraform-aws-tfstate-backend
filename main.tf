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
  provider = aws.primary
  bucket   = aws_s3_bucket.default.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
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
  provider = aws.primary
  bucket   = aws_s3_bucket.default.id

  rule {
    id = "keep-only-some-noncurrent-versions"

    noncurrent_version_expiration {
      newer_noncurrent_versions = var.noncurrent_versions_to_keep
    }
  }

  depends_on = [aws_s3_bucket_versioning.default]
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

  provider       = aws.primary
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
