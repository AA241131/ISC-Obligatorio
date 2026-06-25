resource "aws_s3_bucket" "s3_bucket" {
    region = "us-east-1"
  tags = {
    Name        = "Bucket para Terraform"
    Environment = "Dev"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.s3_bucket.bucket
}