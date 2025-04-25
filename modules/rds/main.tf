resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_parameter_group" "rds_pg" {
  name   = "csye6225-rds-pg"
  family = "mysql8.0"

  description = "Custom parameter group for RDS csye6225"

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
  }

  parameter {
    name  = "max_connections"
    value = "200"
  }

  tags = {
    Name = "csye6225-rds-pg"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier           = "csye6225"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = random_password.db_password.result
  parameter_group_name = aws_db_parameter_group.rds_pg.name
  storage_encrypted    = true
  kms_key_id           = var.kms_rds_key_id

  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.db_security_group_id]

  availability_zone = var.db_availability_zone

  multi_az = false
  db_name  = var.db_name

  skip_final_snapshot = true

  tags = {
    Name = "csye6225-rds"
  }
}

// rds password
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "secret_manager" {
  name       = "rds-db-password-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  kms_key_id = var.kms_secret_manager_key_id
  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id = aws_secretsmanager_secret.secret_manager.id
  secret_string = jsonencode({
    password = random_password.db_password.result
  })
}