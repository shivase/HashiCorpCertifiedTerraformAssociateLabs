provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

############ Creating FIFO Queue ############
resource "aws_sqs_queue" "queue" {
  name                        = "MyWhizQueue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}

############ Creating Standard Queue ############
resource "aws_sqs_queue" "queue2" {
  name = "MyWhizQueue"
}

output "sqs-queue-arn" {
  value = aws_sqs_queue.queue.arn
}
output "sqs-queue2-arn" {
  value = aws_sqs_queue.queue2.arn
}
