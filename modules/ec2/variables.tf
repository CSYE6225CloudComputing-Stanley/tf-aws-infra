variable "instance_type" {
  type        = string
  description = "ec2 instance type"
}

variable "ami_id" {
  type        = string
  description = "ami id"
}


variable "webapp_instance_public_subnet_id" {
  type        = string
  description = "Specify which public subnet id to use"
}

variable "key_name" {
  type        = string
  description = "ssh key name"
}

variable "security_group_id" {
  type        = string
  description = "aws security group id"
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
  description = "s3 bucket name"
  type        = string
}

variable "aws_lb_target_group_arn" {
  description = "load balancer target group arn"
  type        = string
}