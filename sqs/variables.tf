variable "redrive_allow_policy" {
  description = "The JSON policy to set up the Dead Letter Queue redrive permission, see AWS doc"
  type        = string
  default     = ""
}

variable "main-fifo-queue-name" {
  description = "The name of the FIFO queue"
  default = "cloud-guru-sqs"
  type = string
}
