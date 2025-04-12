output "kms_arns" {
  description = "KMS ARNs for EC2, RDS, S3, and Secrets Manager"
  value = {
    ec2             = aws_kms_key.ec2.arn
    rds             = aws_kms_key.rds.arn
    s3              = aws_kms_key.s3.arn
    secrets_manager = aws_kms_key.secret_manager.arn
  }
}
