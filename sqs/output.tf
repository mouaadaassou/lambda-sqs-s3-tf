output "cloud-guru-sqs-dlq-arn" {
  value = aws_sqs_queue.cloud-guru-dlq.arn
}

output "cloud-guru-sqs-arn" {
  value = aws_sqs_queue.cloud-guru-sqs.arn
}
