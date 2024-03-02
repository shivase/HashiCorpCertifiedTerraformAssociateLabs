provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

############ Creating Security Group for EC2 ############
resource "aws_security_group" "ec2-sg" {
  name        = "whiz"
  description = "Security Group to allow traffic to EC2"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

################## Launching EC2 Instance ##################
resource "aws_instance" "ec2" {
  ami           = "ami-01cc34ab2709337aa"
  instance_type = "t2.micro"
  security_groups = [
    aws_security_group.ec2-sg.name
  ]
  tags = {
    Name = "whizserver"
  }
}

############ Creating an SNS Topic ############
resource "aws_sns_topic" "topic" {
  name                                = "Whizlabnote"
  lambda_success_feedback_sample_rate = "100"
  lambda_success_feedback_role_arn    = "arn:aws:iam::374303187335:role/SNS_role_173319.64277514"
  lambda_failure_feedback_role_arn    = "arn:aws:iam::374303187335:role/SNS_role_173319.64277514"
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda.arn
}

# Create a Lambda Function
resource "aws_lambda_function" "lambda" {
  filename         = "lambda_function_48_54.zip"
  function_name    = "WhizlabsEBS"
  role             = "arn:aws:iam::374303187335:role/Lambda_role_173319.64277514s"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64("lambda_function_48_54.zip")
}

# Create a CloucWatch Event Rule
resource "aws_cloudwatch_event_rule" "event" {
  name                = "Whizsnap"
  schedule_expression = "rate(1 hour)"
  event_pattern       = <<EOF
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ],
  "detail": {
    "state": [
      "stopped"
    ],
    "instance-id": [
      "${aws_instance.ec2.id}"
      ]
  }
}
EOF
}

# Add SNS Destination to Lambda Function
resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.event.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.topic.arn
}

resource "aws_lambda_function_event_invoke_config" "sns" {
  function_name = aws_lambda_function.lambda.function_name
  destination_config {
    on_failure {
      destination = aws_sns_topic.topic.arn
    }
    on_success {
      destination = aws_sns_topic.topic.arn
    }
  }
}

# Add Cloudwatch Event Target to Lambda Function
resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.event.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event.arn
}

output "ec2" {
  value = aws_instance.ec2.id
}
output "topic" {
  value = aws_sns_topic.topic.id
}
output "lambda" {
  value = aws_lambda_function.lambda.id
}
output "rule" {
  value = aws_cloudwatch_event_rule.event.id
}
