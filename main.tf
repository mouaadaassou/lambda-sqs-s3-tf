provider "aws" {
  region = "eu-central-1"
}
resource "aws_s3_bucket" "acloud-guru-bucket" {
  bucket = "acloud-guru-bucket-scenario"
}

resource "aws_s3_bucket_policy" "acloud-guru-bucket-policy" {
  bucket = aws_s3_bucket.acloud-guru-bucket.id
  policy = data.aws_iam_policy_document.acloud-guru-bucket-enforce-ssl-policy.json
}

resource "aws_kms_key" "acloud-guru-kms" {
  description             = "KMS key to encrypt uploaded files to S3"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "acloud-guru-server-side-encryption-config" {
  bucket = aws_s3_bucket.acloud-guru-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.acloud-guru-kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

data "aws_iam_policy_document" "acloud-guru-bucket-enforce-ssl-policy" {
  version = "2012-10-17"
  statement {
    sid     = "enforcingSslOnS3Bucket"
    effect  = "Deny"
    actions = ["s3:*"]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [
      aws_s3_bucket.acloud-guru-bucket.arn,
      "${aws_s3_bucket.acloud-guru-bucket.arn}/*",
    ]
    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }

    condition {
      test     = "NumericLessThan"
      values   = [1.2]
      variable = "s3:TlsVersion"
    }

  }
}




