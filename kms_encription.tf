data "aws_caller_identity" "primary" {
  count    = var.create_kms_key ? 1 : 0
  provider = aws.primary
}

data "aws_caller_identity" "secondary" {
  count    = (var.create_kms_key && var.bucket_replication_enabled) ? 1 : 0
  provider = aws.primary
}

data "aws_iam_policy_document" "primary" {
  count = var.create_kms_key ? 1 : 0

  statement { #Allow access for Root User
    sid       = "Allow access for Root User"
    effect    = "Allow"
    resources = [aws_kms_key.primary[0].arn]
    actions   = ["kms:*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.primary[0].account_id}:root"]
    }
  }

  statement { #Allow access for Key Administrator
    sid       = "Allow access for Key Administrator"
    effect    = "Allow"
    resources = [aws_kms_key.primary[0].arn]

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.primary[0].arn]
    }
  }

  dynamic "statement" {
    for_each = aws_sns_topic.topic
    content {
      sid       = "Allow access for Key User (SNS Service Principal)"
      effect    = "Allow"
      resources = [aws_kms_key.primary[0].arn]

      actions = [
        "kms:GenerateDataKey*",
        "kms:Decrypt",
      ]

      principals {
        type        = "Service"
        identifiers = ["sns.amazonaws.com"]
      }
    }
  }
}

data "aws_iam_policy_document" "secondary" {
  count = (var.create_kms_key && var.bucket_replication_enabled) ? 1 : 0

  statement { #Allow access for Root User
    sid       = "Allow access for Root User"
    effect    = "Allow"
    resources = [aws_kms_replica_key.secondary[0].arn]
    actions   = ["kms:*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.secondary[0].account_id}:root"]
    }
  }

  statement { #Allow access for Key Administrator
    sid       = "Allow access for Key Administrator"
    effect    = "Allow"
    resources = [aws_kms_replica_key.secondary[0].arn]

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.secondary[0].arn]
    }
  }

  dynamic "statement" {
    for_each = var.bucket_replication_enabled == true ? [1] : []
    content {
      sid       = "Allow access for replication role"
      effect    = "Allow"
      resources = ["*"]

      actions = [
        "kms:GenerateDataKey",
        "kms:Encrypt"
      ]

      principals {
        type        = "AWS"
        identifiers = [aws_iam_role.bucket_replication[0].arn]
      }
    }
  }


}

resource "aws_kms_key" "primary" {
  count    = var.create_kms_key ? 1 : 0
  provider = aws.primary

  description             = "${aws_s3_bucket.default.bucket}-key"
  deletion_window_in_days = var.kms_key_deletion_windows
  enable_key_rotation     = var.kms_key_rotation
  multi_region            = var.bucket_replication_enabled ? "true" : "false"
}

resource "aws_kms_replica_key" "secondary" {
  count    = (var.create_kms_key && var.bucket_replication_enabled) ? 1 : 0
  provider = aws.secondary

  description             = "Multi-Region replica key"
  deletion_window_in_days = var.kms_key_deletion_windows
  primary_key_arn         = aws_kms_key.primary[0].arn
}

resource "aws_kms_key_policy" "primary" {
  count    = var.create_kms_key ? 1 : 0
  provider = aws.primary

  key_id = aws_kms_key.primary[0].id
  policy = data.aws_iam_policy_document.primary[0].json
}

resource "aws_kms_key_policy" "secondary" {
  count    = (var.create_kms_key && var.bucket_replication_enabled) ? 1 : 0
  provider = aws.secondary

  key_id = aws_kms_replica_key.secondary[0].id
  policy = data.aws_iam_policy_document.secondary[0].json
}