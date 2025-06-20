locals {
  notification_topics = var.enable_notifications ? var.notification_topics : {}
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "bucket" {
  #checkov:skip=CKV_AWS_18: Bucket access logging is not required.
  #checkov:skip=CKV_AWS_144: Bucket cross-region replication is not required.
  bucket_prefix = var.bucket_name

  tags = merge(
    var.tags,
    {
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  )
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.account_id
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = 120
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_sns_topic" "bucket_notifications" {
  count = var.enable_notifications ? 1 : 0

  name   = "${var.bucket_name}-notifications"
  policy = data.aws_iam_policy_document.topic.json

  tags = merge(
    var.tags,
    {
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  )
}

resource "aws_sns_topic_subscription" "bucket_notification_subscription" {
  for_each = var.enable_notifications ? var.notification_subscriptions : {}

  topic_arn = aws_sns_topic.bucket_notifications[0].arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  for_each = var.enable_notifications ? local.notification_topics : {}

  bucket = aws_s3_bucket.bucket.id

  topic {
    topic_arn     = aws_sns_topic.bucket_notifications[0].arn
    events        = each.value.events
    filter_prefix = each.value.filter_prefix
    filter_suffix = each.value.filter_suffix
    id            = each.value.id == "" ? each.key : each.value.id
  }
}
