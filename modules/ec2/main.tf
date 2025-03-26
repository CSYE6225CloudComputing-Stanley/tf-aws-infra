resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.webapp_instance_public_subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  disable_api_termination = false
  user_data = templatefile("${path.module}/../../scripts/user_data.sh", {
    DB_NAME     = var.DB_NAME,
    DB_USERNAME = var.DB_USERNAME,
    DB_PASSWORD = var.DB_PASSWORD,
    DB_HOST     = var.DB_HOST,
    BUCKET_NAME = var.BUCKET_NAME
  })

  tags = { Name = "web application server" }
}


resource "aws_iam_role" "ec2_role" {
  name = "ec2-combined-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# S3 Policy
resource "aws_iam_policy" "s3_access_policy" {
  name        = "EC2S3AccessPolicy"
  description = "Allow EC2 to access S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      Resource = [
        "arn:aws:s3:::${var.BUCKET_NAME}",
        "arn:aws:s3:::${var.BUCKET_NAME}/*"
      ]
    }]
  })
}

# CloudWatch Agent Policy
resource "aws_iam_policy" "cw_agent_policy" {
  name = "cw-agent-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:DescribeLogGroups",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "cloudwatch:PutMetricData"
      ],
      Resource = "*"
    }]
  })
}

# Attach both policies to the same role
resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_cw" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.cw_agent_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}