provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_ses_email_identity" "ses_identity" {
  email = var.subscription_email
}

output "Identity_arn" {
  value       = aws_ses_email_identity.ses_identity.arn
  description = "Identity created successfully"
}
