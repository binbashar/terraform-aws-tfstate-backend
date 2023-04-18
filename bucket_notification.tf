data "aws_iam_policy_document" "topic" {
  count    = var.notifications_sns ? 1 : 0
  provider = aws.primary

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = ["arn:aws:sns:*:*:${aws_s3_bucket.default.bucket}-topic"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.bucket.arn]
    }
  }
}

resource "aws_sns_topic" "topic" {
  count    = var.notifications_sns ? 1 : 0
  provider = aws.primary

  name              = "${aws_s3_bucket.bucket.bucket}-topic}"
  policy            = data.aws_iam_policy_document.topic[0].json
  kms_master_key_id = aws_kms_key.key[0].arn
}

data "aws_iam_policy_document" "queue" {
  count = var.notifications_sqs ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:*:*:${aws_s3_bucket.default.bucket}-queue"]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.default.arn]
    }
  }
}

resource "aws_sqs_queue" "queue" {
  count = var.notifications_sqs ? 1 : 0

  name   = "${aws_s3_bucket.default.bucket}-queue"
  policy = data.aws_iam_policy_document.queue[0].json
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  count = (var.notifications_sns || var.notifications_sqs) ? 1 : 0

  bucket = aws_s3_bucket.default.id

  dynamic "topic" {
    for_each = aws_sns_topic.topic
    content {
      topic_arn = topic.value.arn
      events    = var.notifications_events
    }
  }

  dynamic "queue" {
    for_each = aws_sqs_queue.queue
    content {
      queue_arn = queue.value.arn
      events    = var.notifications_events
    }
  }
}