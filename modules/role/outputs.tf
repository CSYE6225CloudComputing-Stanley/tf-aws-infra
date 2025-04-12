output "ec2_iam" {
  description = "IAM role and instance profile for EC2"
  value = {
    role_arn              = aws_iam_role.ec2_role.arn
    role_name             = aws_iam_role.ec2_role.name
    instance_profile_name = aws_iam_instance_profile.ec2_profile.name
  }
}