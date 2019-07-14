terraform {
  required_version = ">= 0.11.6"
}

resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  replication_configuration {
    role = "${aws_iam_role.bucket_replication.arn}"

    rules {
      id     = "standard_bucket_replication"
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.replication_bucket.arn}"
        storage_class = "STANDARD"
      }
    }
  }

  tags {
    terraform   = "true"
    description = "${var.bucket_description}"
  }
}

# DynamoDB table used for locking changes to remote state
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name     = "${var.table_name}"
  hash_key = "LockID"

  # Keep read/write capacity within the free tier
  read_capacity  = "${var.table_read_capacity}"
  write_capacity = "${var.table_write_capacity}"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    terraform   = "true"
    description = "${var.table_description}"
  }
}
