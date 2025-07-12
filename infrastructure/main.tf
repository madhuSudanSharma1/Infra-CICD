provider "aws" {
  region = "us-east-1"
}
locals {
  tags = {
    Creator     = "Madhu Sharma"
    Environment = terraform.workspace
  }
}

resource "aws_instance" "ec2-instance" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  tags                        = merge(local.tags, { Name = "madhu-ec2-instance-1" })
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.vpc_security_group_id]
}
