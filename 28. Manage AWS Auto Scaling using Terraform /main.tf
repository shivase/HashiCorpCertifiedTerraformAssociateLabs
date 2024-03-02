provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_launch_template" "whiztemp" {
  name_prefix   = "whizLT"
  image_id      = "ami-02e136e904f3da870"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "whizgroup" {
  name               = "whiz-ASG1"
  availability_zones = ["us-east-1a", "us-east-1b"]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  launch_template {
    id      = aws_launch_template.whiztemp.id
    version = "$Latest"
  }
}

output "launchtemplate" {
  value = aws_launch_template.whiztemp.arn
}
output "autoscaling_group" {
  value = aws_autoscaling_group.whizgroup.arn
}
