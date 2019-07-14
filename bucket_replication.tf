# We need a different AWS provider on the specified region
provider "aws" {
  alias   = "replication_region"
  region  = "${var.replication_region}"
  profile = "${var.replication_profile}"
}

# To create a bucket on a different region
resource "aws_s3_bucket" "replication_bucket" {
  bucket   = "${var.bucket_name}-replica"
  provider = "aws.replication_region"

  versioning {
    enabled = true
  }

  tags {
    terraform   = "true"
    description = "${var.bucket_description}"
  }
}

# Allow S3 to assume a role to perform actions on the replication bucket
resource "aws_iam_role" "bucket_replication" {
  name = "tf-iam-role-tfbackend-bucket-replication"

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

# These are the permissions needed to enable replication between our two buckets
resource "aws_iam_policy" "bucket_replication" {
  name = "tf-iam-policy-tfbackend-bucket-replication"

  policy = <<POLICY
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
        "${aws_s3_bucket.terraform-state-storage-s3.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.terraform-state-storage-s3.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.replication_bucket.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication_bucket_permissions" {
  name       = "tf-iam-role-attachment-bucket-replication"
  roles      = ["${aws_iam_role.bucket_replication.name}"]
  policy_arn = "${aws_iam_policy.bucket_replication.arn}"
}
