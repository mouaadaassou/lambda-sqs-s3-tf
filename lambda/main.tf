provider "aws" {
  region = "eu-central-1"
}

# Event source from SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  function_name    = aws_lambda_function.command-processor.arn
  event_source_arn = var.main-queue-arn
  enabled          = true
  batch_size       = 10
}

resource "aws_lambda_function" "command-processor" {
  function_name    = var.lambda-function-name
  role             = aws_iam_role.command-processor-role.arn
  runtime          = var.lambda-runtime
  package_type     = var.lambda-package-type
  filename         = data.archive_file.command-processor.output_path
  handler          = "main.lambda_handler"
  source_code_hash = filebase64sha256("main.py.zip")

  environment {
    variables = {
      bucket_name = var.main-bucket-name
    }
  }
}

resource "aws_iam_role_policy" "command-processor-role-policy" {
  policy = data.aws_iam_policy_document.allow-command-processor-lambda-receive-messages.json
  role   = aws_iam_role.command-processor-role.id
}

resource "aws_iam_role" "command-processor-role" {
  name               = "command-processor-role"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
}

resource "aws_cloudwatch_log_group" "command-processor-log-group" {
  name              = "/aws/lambda/${aws_lambda_function.command-processor.function_name}"
  retention_in_days = 14
}


data "aws_iam_policy_document" "assume-role-policy" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "allow-command-processor-lambda-receive-messages" {
  version = "2012-10-17"
  statement {
    sid     = "allowCommandProcessorLambdaReceiveMessagesAndPutToS3"
    effect  = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:DeleteMessage"
    ]

    resources = [var.main-queue-arn]
  }

  statement {
    sid       = "allowCommandProcessorCreateLogStream"
    effect    = "Allow"
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid       = "allowLambdaToUploadObjectsToS3Bucket"
    effect    = "Allow"
    actions   = [
      "s3:PutObject",
      "s3:ListBucket",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation"
    ]
    resources = [
      var.main-s3-bucket-arn,
      "${var.main-s3-bucket-arn}/*"
    ]
  }

  statement {
    sid = "allowLambdaToCallKms"
    effect = "Allow"
    actions = ["kms:GenerateDataKey"]
    resources = [var.s3-kms-arn]
  }
}

data "archive_file" "command-processor" {
  source_file = "${path.module}/code/main.py"
  output_path = "main.py.zip"
  type        = "zip"
}
