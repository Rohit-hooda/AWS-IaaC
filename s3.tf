resource "aws_s3_bucket" "private" {
  bucket = "my-s3-bucket-${random_uuid.uuid.result}"
  acl    = var.s3_acl

  lifecycle_rule {
    id      = var.s3_lifecycle_rule_id
    enabled = var.s3_lifecyle_enabled
    prefix  = ""
    transition {
      days          = var.s3_lifecycle_rule_duration
      storage_class = var.s3_lifecycle_rule_storage_class
    }
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  force_destroy = true
}
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "random_uuid" "uuid" {}

resource "aws_iam_policy" "web_app_s3_policy" {
  name        = "WebAppS3"
  description = "Allows EC2 instances to access S3 buckets"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:CreateBucket",
          "s3:GetBucketLocation",
          "s3:ListAllMyBuckets",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:PutLifecycleConfiguration"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.private.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.private.bucket}/*"
        ]
      }
    ]
  })
}
output "bucket_name" {
  value = aws_s3_bucket.private.bucket
}

resource "aws_iam_role" "ec2_csye6225_role" {
  name = "EC2-CSYE6225"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "webapp_s3_policy_attachment" {
  policy_arn = aws_iam_policy.web_app_s3_policy.arn
  role       = aws_iam_role.ec2_csye6225_role.name
}
