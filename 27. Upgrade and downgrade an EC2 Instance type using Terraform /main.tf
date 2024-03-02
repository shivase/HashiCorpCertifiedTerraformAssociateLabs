provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

################## Launching EC2 Instance ##################
resource "aws_instance" "web-server" {
  ami = "ami-01cc34ab2709337aa"
  #instance_type = "t2.micro"
  instance_type = "t2.medium"
  tags = {
    Name = "MyEC2Server"
  }
}

output "instance" {
  value = aws_instance.web-server.arn
}
