resource "aws_s3_bucket_policy" "default" {
  count = var.enforce_ssl_requests ? 1 : 0

  provider   = aws
  bucket     = aws_s3_bucket.default.id
  policy     = data.aws_iam_policy_document.default-ssl.json
  depends_on = [aws_s3_bucket_public_access_block.default, time_sleep.wait_30_secs]
}

data "aws_iam_policy_document" "default-ssl" {
  provider = aws

  #
  # 1stg Policy Statement
  statement {
    sid = "EnforceSSlRequestsOnly"

    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.default.arn}/*"
    ]

    #
    # Check for a condition that always requires ssl communications
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "default-ssl-vpc" {
  count = var.enforce_ssl_requests && var.enforce_vpc_requests && var.vpc_ids_list != [] ? 1 : 0

  provider   = aws
  bucket     = aws_s3_bucket.default.id
  policy     = data.aws_iam_policy_document.default-ssl-vpc.json
  depends_on = [aws_s3_bucket_public_access_block.default, time_sleep.wait_30_secs]
}

data "aws_iam_policy_document" "default-ssl-vpc" {
  provider = aws

  #
  # 1stg Policy Statement
  statement {
    sid = "EnforceSSlRequestsOnly"

    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.default.arn}/*"
    ]

    #
    # Check for a condition that always requires ssl communications
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
  #
  # Policy Statements per vpc id
  statement {
    sid = "EnforceVPCRequestsOnly"

    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.default.arn,
      "${aws_s3_bucket.default.arn}/*"
    ]
    #
    # Bucket policy that restricts access to a specific VPC by using the
    # aws:sourceVpc condition.
    #
    condition {
      test     = "StringNotEquals"
      variable = "aws:sourceVpc"
      values = [
        for vpc_id in var.vpc_ids_list :
        vpc_id
      ]
    }
  }
}
