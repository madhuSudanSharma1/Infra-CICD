provider "aws" {
  region = "us-east-1"
}
locals {
  tags = {
    Creator     = "Madhu Sharma"
    Environment = terraform.workspace
  }
}
resource "aws_iam_role" "ec2_s3_role" {
  name = "madhu-ec2-s3-role"
  tags = merge(local.tags, { Name = "madhu-ec2-s3-role" })
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2_s3_policy" {
  role   = aws_iam_role.ec2_s3_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "*"
        ]
      }
    ]
  })
}
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "madhu-ec2-s3-instance-profile-1"
  role = aws_iam_role.ec2_s3_role.name
  tags = merge(local.tags, { Name = "madhu-ec2-s3-instance-profile-1" })
}

resource "aws_instance" "ec2-instance" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  tags                        = merge(local.tags, { Name = "madhu-ec2-s3-instance-profile-1" })
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.vpc_security_group_id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
}
