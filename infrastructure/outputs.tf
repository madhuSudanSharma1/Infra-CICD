output "ec2_role_arn" {
  value = aws_iam_role.ec2_s3_role.arn
  description = "The ARN of the IAM role attached to the EC2 instance"
}