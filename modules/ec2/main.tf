resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.webapp_instance_public_subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  disable_api_termination = false

  user_data = <<-EOF
    #!/bin/bash

    echo "Setting up environment variables..."
    echo "DB_NAME=${var.DB_NAME}" | sudo tee -a /etc/environment
    echo "DB_USERNAME=${var.DB_USERNAME}" | sudo tee -a /etc/environment
    echo "DB_PASSWORD=${var.DB_PASSWORD}" | sudo tee -a /etc/environment
    echo "DB_HOST=${var.DB_HOST}" | sudo tee -a /etc/environment
    echo "BUCKET_NAME=${var.BUCKET_NAME}" | sudo tee -a /etc/environment

    echo "Reloading environment variables..."
    source /etc/environment

    echo "Restarting Spring Boot service..."
    sudo systemctl restart springboot.service

  EOF
  tags      = { Name = "web application server" }
}


# attach s3 rule to ec2
resource "aws_iam_role" "ec2_s3_role" {
  name = "EC2S3AccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

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

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-profile"
  role = aws_iam_role.ec2_s3_role.name
}