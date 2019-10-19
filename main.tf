resource "aws_s3_bucket" "default" {
  bucket        = format("%s-%s-%s", var.namespace, var.stage, var.name)
  acl           = var.acl
  region        = var.region
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
      role = "${aws_iam_role.bucket_replication[0].arn}"

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
  bucket                  = aws_s3_bucket.default.id
  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_dynamodb_table" "with_server_side_encryption" {
  count          = var.enable_server_side_encryption == "true" ? 1 : 0
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
  count          = var.enable_server_side_encryption == "true" ? 0 : 1
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

