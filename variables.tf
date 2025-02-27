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


variable "webapp_instance_public_subnet" {
  type        = string
  description = "Specify which public subnet to use"
}

variable "key_name" {
  type        = string
  description = "ssh key name"
}