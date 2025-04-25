variable "private_subnet_ids" {
  type        = list(string)
  description = "private subnet ids"
}

variable "db_name" {
  type        = string
  description = "mysql database name"
}

variable "db_username" {
  type        = string
  description = "mysql username"
}

variable "db_security_group_id" {
  type        = string
  description = "database security groupd id"
}

variable "db_availability_zone" {
  type        = string
  description = "database availability zone"
}

variable "kms_rds_key_id" {
  description = "rds kms"
  type        = string
}

variable "kms_secret_manager_key_id" {
  description = "secret manager kms"
  type        = string
}
