variable "access_key" {
  description = "Access key to AWS console"
}
variable "secret_key" {
  description = "Secret key to AWS console"
}
variable "region" {
  description = "AWS region"
}
variable "subscription_email" {
  type        = string
  description = "SES Email Address"
}
