output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnets_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.gw.id
}