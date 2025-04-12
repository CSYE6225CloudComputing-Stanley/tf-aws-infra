resource "aws_kms_key" "ec2" {
  description             = "KMS for EC2"
  enable_key_rotation     = true
  rotation_period_in_days = 90
  policy = templatefile("${path.module}/kms-ec2-policy.json", {
    account_id    = data.aws_caller_identity.current.account_id,
    ec2_role_name = var.ec2_role_name
  })

  tags = {
    Name    = "ec2 kms"
    Purpose = "ec2"
  }
}

resource "aws_kms_key" "rds" {
  description             = "KMS for RDS"
  enable_key_rotation     = true
  rotation_period_in_days = 90
  policy = templatefile("${path.module}/kms-rds-policy.json", {
    account_id    = data.aws_caller_identity.current.account_id,
    ec2_role_name = var.ec2_role_name
  })
  tags = {
    Name    = "rds kms"
    Purpose = "rds"
  }
}

resource "aws_kms_key" "s3" {
  description             = "KMS for S3"
  enable_key_rotation     = true
  rotation_period_in_days = 90
  policy = templatefile("${path.module}/kms-s3-policy.json", {
    account_id    = data.aws_caller_identity.current.account_id,
    ec2_role_name = var.ec2_role_name
  })
  tags = {
    Name    = "s3 kms"
    Purpose = "s3"
  }
}

resource "aws_kms_key" "secret_manager" {
  description             = "KMS Database Password for RDS instance "
  enable_key_rotation     = true
  rotation_period_in_days = 90
  policy = templatefile("${path.module}/kms-sm-policy.json", {
    account_id    = data.aws_caller_identity.current.account_id,
    ec2_role_name = var.ec2_role_name
  })
  tags = {
    Name    = "secret manager kms"
    Purpose = "rds password"
  }
}


data "aws_caller_identity" "current" {}