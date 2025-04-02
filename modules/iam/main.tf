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