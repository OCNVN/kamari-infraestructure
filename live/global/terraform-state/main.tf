terraform {
  backend "s3" {
    profile = "kamari"
    bucket = "kamari-terraform-state"
    key = "global/terraform-state/terraform.tfstate"
    region = "us-east-1"

    dynamodb_endpoint = "kamari-terraform-state-locks"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# s3 bucket to store terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "kamari-terraform-state"

  # Prevent accidental deletion of the bucket
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "terraform-state"
    Project     = "kamari"
    Environment = "live"
  }
}

# Enable versioning on the s3 bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server side encryption for the s3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Disable public access to the s3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# DynamoDB table to store terraform state locks
resource "aws_dynamodb_table" "locks" {
  name = "kamari-terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "terraform_state_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket used for storing Terraform state."
}

output "terraform_state_locks_table_name" {
  value       = aws_dynamodb_table.locks.name
  description = "The name of the DynamoDB table used for state locking."
}