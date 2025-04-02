variable "lb_security_group_id" {
  type        = string
  description = "load balancer security group id"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"

}

variable "public_subnets_id" {
  type        = list(string)
  description = "public subnets id"
}