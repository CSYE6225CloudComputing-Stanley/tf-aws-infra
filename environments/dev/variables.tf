variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "profile" {
  type        = string
  description = "AWS profile name"
}

variable "vpc_name" {
  type        = string
  description = "AWS vpc name"
  default     = "my_vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "instance_type" {
  type        = string
  description = "ec2 instance type"
}

variable "ami_id" {
  type        = string
  description = "ami id"
}

variable "key_name" {
  type        = string
  description = "ssh key name"
}

variable "mysql_username" {
  type        = string
  description = "mysql username"
}

variable "mysql_password" {
  type        = string
  description = "mysql password"
}

variable "mysql_db_name" {
  type        = string
  description = "mysql database name"
}

variable "db_availability_zone" {
  type        = string
  description = "database availability zone"
}

variable "iam_group_name" {
  type        = string
  description = "iam group name"
}

variable "DB_NAME" {
  description = "Database name"
  type        = string
}

variable "DB_USERNAME" {
  description = "Database username"
  type        = string
}

variable "DB_PASSWORD" {
  description = "Database password"
  type        = string
}

variable "DB_HOST" {
  description = "Database host"
  type        = string
}

variable "BUCKET_NAME" {
  description = "Database host"
  type        = string
}

