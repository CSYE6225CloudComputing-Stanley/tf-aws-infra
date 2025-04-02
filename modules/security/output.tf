output "security_group_id" {
  value = aws_security_group.application_security_group.id
}

output "db_security_group_id" {
  value = aws_security_group.db_security_group.id
}

output "lb_security_group_id" {
  value = aws_security_group.lb_security_group.id
}