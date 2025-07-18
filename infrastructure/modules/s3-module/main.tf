locals {
  bucket_name = var.bucket_name
  tags = merge(var.tags, {
    Name = local.bucket_name
  })
}
resource "aws_s3_bucket" "s3_bucket" {
  bucket = local.bucket_name
  tags   = local.tags
  region = var.region
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}
resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = var.allow_access_from_anywhere ? false : true
  block_public_policy     = var.allow_access_from_anywhere ? false : true
  ignore_public_acls      = var.allow_access_from_anywhere ? false : true
  restrict_public_buckets = var.allow_access_from_anywhere ? false : true
}
