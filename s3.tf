resource "aws_s3_bucket" "terraformstatebucket" {
  bucket = "terraformstatebucket"  # Ensure this is globally unique

  tags = {
    Name        = "terraformstatebucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraformstatebucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


terraform {
  backend "s3"{
  bucket = "terraformstatebucket"
  key = "terrraform.tfstate"
  region = "us-east-2"
  }
}