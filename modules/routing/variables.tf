variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "vpc_name" {
  type        = string
  description = "AWS vpc name"
  default     = "my_vpc"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDR blocks"
}

variable "public_subnets_id" {
  type        = list(string)
  description = "public subnets id"
}

variable "private_subnets_id" {
  type        = list(string)
  description = "private subnets id"
}

variable "internet_gateway_id" {
  type        = string
  description = "internet gateway id"
}