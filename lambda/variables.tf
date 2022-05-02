variable "lambda-function-name" {
  description = "The name of the Lambda function"
  type        = string
  default     = ""
}

variable "main-queue-arn" {
  description = "The ARN of the SQS queue"
  type        = string
  default     = ""
}

variable "main-s3-bucket-arn" {
  description = "The ARN of the s3 bucket"
  type        = string
  default     = ""
}

variable "main-bucket-name" {
  description = "The name of the s3 bucket"
  type = string
  default = ""
}

variable "s3-kms-arn" {
  description = "The KMS arn"
  type = string
  default = ""
}

variable "archive-file-output-file" {
  description = "the output file name of the lambda function code"
  type = string
  default = ""
}

variable "archive-file-type" {
  description = "the type of the archive file"
  type = string
  default = ""
}

variable "lambda-runtime" {
  description = "The runtime used to run the lambda function"
  type = string
  default = ""
}

variable "lambda-package-type" {
  description = "The lambda deployment package type used"
  type = string
  default = "Zip"
}
