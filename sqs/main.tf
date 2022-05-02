/**
 * Some TF default values for SQS:
 *    1. max_message_size => between 1KB and 256KB => default 256KB
 *    2. message_retention_seconds  => between 1 minute and 14 days => default 4 days
 **/

provider "aws" {
  region = "eu-central-1"
}

resource "aws_sqs_queue" "cloud-guru-dlq" {
  fifo_queue = true
  name       = "${var.main-fifo-queue-name}-dlq.fifo"

  receive_wait_time_seconds = 5
  sqs_managed_sse_enabled   = true
  # 14 days
  message_retention_seconds = 1209600
}

resource "aws_sqs_queue" "cloud-guru-sqs" {
  fifo_queue    = true
  name          = "${var.main-fifo-queue-name}.fifo"
  delay_seconds = 0

  # 5 days
  message_retention_seconds   = 432000
  content_based_deduplication = false
  deduplication_scope         = "messageGroup"

  sqs_managed_sse_enabled = true
  redrive_policy          = var.redrive_policy_json
  redrive_allow_policy    = var.redrive_allow_policy_json
}

resource "aws_sqs_queue_policy" "cloud-guru-sqs-policy" {
  policy    = data.aws_iam_policy_document.cloud-guru-sqs-lambda-policy.json
  queue_url = aws_sqs_queue.cloud-guru-sqs.url
}

data "aws_iam_policy_document" "cloud-guru-sqs-lambda-policy" {
  version = "2012-10-17"
  statement {
    sid     = "allowLambdaToSendMessages"
    effect  = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl"
    ]

    resources = [aws_sqs_queue.cloud-guru-sqs.arn]
  }
}
