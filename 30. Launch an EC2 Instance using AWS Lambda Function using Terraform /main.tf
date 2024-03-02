provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

#Create a Lambda Function
resource "aws_lambda_function" "lambda" {
  filename         = "whiz_lambda_function.zip"
  function_name    = "myEC2LambdaFunction"
  role             = "arn:aws:iam::233956366344:role/myrole-173319.56201732"
  handler          = "lambda_function.lambda_handler"
  timeout          = 6
  runtime          = "python3.8"
  source_code_hash = filebase64("whiz_lambda_function.zip")
}

output "lambda" {
  value = aws_lambda_function.lambda.arn
}
