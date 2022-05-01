/**
 * Some TF default values for SQS:
 *    1. max_message_size => between 1KB and 256KB => default 256KB
 *    2. message_retention_seconds  => between 1 minute and 14 days => default 4 days
 *    3.
 **/
provider "aws" {
  region = "eu-central-1"
}

locals {
  redrive_allow_policy = jsonencode({
    sourceQueueArn    = [aws_sqs_queue.cloud-guru-dlq.arn]
    redrivePermission = "byQueue"
  })
}

resource "aws_sqs_queue" "cloud-guru-dlq" {
  fifo_queue = true
  name       = "${var.main-fifo-queue-name}-dlq.fifo"

  # 14 days
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 5
  sqs_managed_sse_enabled = true
}

resource "aws_sqs_queue" "cloud-guru-sqs" {
  fifo_queue    = true
  name          = "${var.main-fifo-queue-name}.fifo"
  delay_seconds = 900

  # 5 days
  message_retention_seconds   = 432000
  content_based_deduplication = false
  deduplication_scope         = "messageGroup"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.cloud-guru-dlq.arn
    maxReceiveCount     = 4
  })

  sqs_managed_sse_enabled = true

  redrive_allow_policy = var.redrive_allow_policy
}
