output "s3-bucket-arn" {
  value = aws_s3_bucket.command-processor-s3-bucket.arn
}

output "main-s3-bucket-name" {
  value = aws_s3_bucket.command-processor-s3-bucket.bucket
}

output "kms-arn" {
  value = aws_kms_key.kms-s3-config.arn
}
