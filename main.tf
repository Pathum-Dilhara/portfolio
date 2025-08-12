terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "website" {
  bucket = "my-terraform-cicd-site"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = "*"
      Action = ["s3:GetObject"]
      Resource = "${aws_s3_bucket.website.arn}/*"
    }]
  })
}

resource "aws_iam_user" "github_user" {
  name = "github-actions-deployer"
}

resource "aws_iam_policy" "s3_deploy_policy" {
  name        = "S3DeployPolicy"
  description = "Policy for GitHub Actions to deploy to S3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:PutObjectAcl", "s3:DeleteObject"]
        Resource = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.github_user.name
  policy_arn = aws_iam_policy.s3_deploy_policy.arn
}

resource "aws_iam_access_key" "github_key" {
  user = aws_iam_user.github_user.name
}

output "AWS_S3_BUCKET" {
  value = aws_s3_bucket.website.bucket
  sensitive = true
}

output "AWS_ACCESS_KEY_ID" {
  value = aws_iam_access_key.github_key.id
  sensitive = true
}

output "AWS_SECRET_ACCESS_KEY" {
  value     = aws_iam_access_key.github_key.secret
  sensitive = true
}