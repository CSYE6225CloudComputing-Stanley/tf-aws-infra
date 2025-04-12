output "rds_password_secret_name" {
  value       = aws_secretsmanager_secret.secret_manager.name
  description = "The name of the secret storing RDS password"
}