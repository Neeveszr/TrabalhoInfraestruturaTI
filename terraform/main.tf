terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.4.0"
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = var.localstack_s3_endpoint
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  bucket_name = length(trim(var.bucket_name)) > 0 ? var.bucket_name : "infra-prova-${random_id.suffix.hex}"
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = local.bucket_name
  acl    = "private"
  force_destroy = true

  tags = {
    Name = "infra-prova-bucket"
    Env  = "lab"
  }
}

resource "aws_iam_user" "lab_user" {
  name = "infra_prova_user"
}

resource "aws_iam_user_policy" "lab_user_policy" {
  name = "lab_user_policy"
  user = aws_iam_user.lab_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.app_bucket.arn,
          "${aws_s3_bucket.app_bucket.arn}/*"
        ]
      }
    ]
  })
}

output "bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}

output "iam_user" {
  value = aws_iam_user.lab_user.name
}
