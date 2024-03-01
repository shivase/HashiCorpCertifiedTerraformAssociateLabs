provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
resource "aws_sns_topic" "sns_topic" {
  name = "whiz-topic"
}
resource "aws_sns_topic_subscription" "sns_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = var.sns_subscription_email
}

output "topic_arn1" {
  value       = aws_sns_topic.sns_topic.arn
  description = "Topic created successfully"
}
output "subscription_arn1" {
  value       = aws_sns_topic_subscription.sns_subscription.arn
  description = "Subscription created successfully. Confirm the subscription on your mail"
}
