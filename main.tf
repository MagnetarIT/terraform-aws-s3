module "naming" {
  source      = "git::https://github.com/MagnetarIT/terraform-naming-standard.git?ref=tags/0.2.0"
  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  attributes  = var.attributes
  tags        = var.tags
}

resource "aws_s3_bucket" "default" {
  bucket        = module.naming.id
  acl           = var.acl
  region        = var.region
  force_destroy = var.force_destroy
  policy        = var.policy

  versioning {
    enabled = var.versioning_enabled
  }

  lifecycle_rule {
    id                                     = module.naming.id
    enabled                                = var.lifecycle_rule_enabled
    prefix                                 = var.prefix
    tags                                   = var.lifecycle_tags
    abort_incomplete_multipart_upload_days = var.abort_incomplete_multipart_upload_days

    noncurrent_version_expiration {
      days = var.noncurrent_version_expiration_days
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.enable_glacier_transition ? [1] : []

      content {
        days          = var.noncurrent_version_transition_days
        storage_class = "GLACIER"
      }
    }

    transition {
      days          = var.standard_transition_days
      storage_class = "STANDARD_IA"
    }

    dynamic "transition" {
      for_each = var.enable_glacier_transition ? [1] : []

      content {
        days          = var.glacier_transition_days
        storage_class = "GLACIER"
      }
    }

    expiration {
      days = var.expiration_days
    }

  }

  # https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-encryption.html
  # https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#enable-default-server-side-encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
        kms_master_key_id = var.kms_master_key_arn
      }
    }
  }

  tags = module.naming.tags
}


data "aws_iam_policy_document" "bucket_policy" {
  count = var.allow_encrypted_uploads_only ? 1 : 0

  statement {
    sid       = "DenyIncorrectEncryptionHeader"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.default.id}/*"]

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    condition {
      test     = "StringNotEquals"
      values   = [var.sse_algorithm]
      variable = "s3:x-amz-server-side-encryption"
    }
  }

  statement {
    sid       = "DenyUnEncryptedObjectUploads"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.default.id}/*"]

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    condition {
      test     = "Null"
      values   = ["true"]
      variable = "s3:x-amz-server-side-encryption"
    }
  }
}

resource "aws_s3_bucket_policy" "default" {
  count  = var.allow_encrypted_uploads_only ? 1 : 0
  bucket = aws_s3_bucket.default.id
  policy = join("", data.aws_iam_policy_document.bucket_policy.*.json)
}

data "aws_iam_policy_document" "default" {
  count = var.user_enabled ? 1 : 0

  statement {
    actions   = var.s3_actions
    resources = ["${join("", aws_s3_bucket.default.*.arn)}/*", join("", aws_s3_bucket.default.*.arn)]
    effect    = "Allow"
  }
}

resource "aws_iam_user_policy" "default" {
  count  = var.user_enabled ? 1 : 0
  name   = join("", aws_iam_user.default.*.name)
  user   = join("", aws_iam_user.default.*.name)
  policy = join("", data.aws_iam_policy_document.default.*.json)
}

resource "aws_iam_user" "default" {
  count         = var.user_enabled ? 1 : 0
  name          = module.naming.id
  path          = var.user_path
  force_destroy = var.user_force_destroy
}

resource "aws_iam_access_key" "default" {
  count = var.user_enabled ? 1 : 0
  user  = aws_iam_user.default[0].name
}

