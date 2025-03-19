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

variable "security_group_id" {
  type        = string
  description = "aws security group id"
}