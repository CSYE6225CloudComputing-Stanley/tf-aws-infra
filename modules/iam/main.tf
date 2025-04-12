resource "aws_iam_group_policy_attachment" "rds_full_access" {
  group      = var.iam_group_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_group_policy_attachment" "s3_full_access" {
  group      = var.iam_group_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_group_policy_attachment" "route53_full_access" {
  group      = var.iam_group_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_policy" "kms_full_access" {
  name = "KMSFullAccessCustom"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "kms:*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "kms_" {
  group      = var.iam_group_name
  policy_arn = aws_iam_policy.kms_full_access.arn
}

resource "aws_iam_policy" "secrets_full_access" {
  name = "SecretsManagerFullAccess"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "attach_secrets_policy" {
  group      = var.iam_group_name
  policy_arn = aws_iam_policy.secrets_full_access.arn
}