provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

################## Creating an EKS Cluster ##################
resource "aws_eks_cluster" "cluster" {
  name     = "whiz"
  role_arn = "arn:aws:iam::615579253835:role/task98_role_173319.42989809"

  vpc_config {
    subnet_ids = ["subnet-0d163f7dd7278bdfc", "subnet-0a8cab24ff66adc7e"]
  }
}

output "cluster" {
  value = aws_eks_cluster.cluster.endpoint
}
