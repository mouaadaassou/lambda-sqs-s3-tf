module "sqs-fifo" {
  source                    = "./sqs"
  main-fifo-queue-name      = "cloud-guru-sqs"
  redrive_allow_policy_json = jsonencode({
    sourceQueueArns   = [module.sqs-fifo.cloud-guru-sqs-dlq-arn]
    redrivePermission = "byQueue"
  })

  redrive_policy_json = jsonencode({
    deadLetterTargetArn = module.sqs-fifo.cloud-guru-sqs-dlq-arn
    maxReceiveCount     = 4
  })
}

module "lambda-processor" {
  source                   = "./lambda"
  lambda-function-name     = "released-books-processor"
  lambda-runtime           = "python3.8"
  main-queue-arn           = module.sqs-fifo.cloud-guru-sqs-arn
  main-s3-bucket-arn       = module.s3-bucket.s3-bucket-arn
  main-bucket-name         = module.s3-bucket.main-s3-bucket-name
  s3-kms-arn               = module.s3-bucket.kms-arn
  archive-file-output-file = "main.py.zip"
  lambda-package-type      = "Zip"
  archive-file-type        = "zip"
}

module "s3-bucket" {
  source = "./s3"
}


