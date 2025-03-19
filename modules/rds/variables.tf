variable "private_subnet_ids" {
  type        = list(string)
  description = "private subnet ids"
}

variable "mysql_db_name" {
  type        = string
  description = "mysql database name"
}

variable "mysql_username" {
  type        = string
  description = "mysql username"
}

variable "mysql_password" {
  type        = string
  description = "mysql password"
}

variable "db_security_group_id" {
  type        = string
  description = "database security groupd id"
}

variable "db_availability_zone" {
  type        = string
  description = "database availability zone"
}

