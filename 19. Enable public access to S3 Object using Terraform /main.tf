provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

############ Creating a Random String ############
resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}
############ Creating an S3 Bucket ############
resource "aws_s3_bucket" "bucket" {
  bucket        = "whizbucket-${random_string.random.result}"
  force_destroy = true
}
resource "aws_s3_bucket_public_access_block" "access_pub" {
  bucket              = aws_s3_bucket.bucket.id
  block_public_policy = false
}

# Upload an object
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "Whizlabs.png"
  source = "image/Whizlabs.png"
  etag   = md5("image/Whizlabs.png")
}

#Creating Bucket Policy
resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
        ],
      "Resource": [
        "${aws_s3_bucket.bucket.arn}",
        "${aws_s3_bucket.bucket.arn}/${aws_s3_object.object.key}"
      ]
    }
  ]
}
EOF
}

output "s3-bucket-name" {
  value = aws_s3_bucket.bucket.id
}
