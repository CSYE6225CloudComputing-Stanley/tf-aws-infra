# puglic rt configuration
resource "aws_route_table" "public_rt" {
  #   vpc_id = aws_vpc.my_vpc.id
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  #   gateway_id             = aws_internet_gateway.gw.id
  gateway_id = var.internet_gateway_id
}

resource "aws_route_table_association" "public_route_association" {
  count = length(var.public_subnet_cidrs)
  #   subnet_id      = aws_subnet.public_subnets[count.index].id
  subnet_id      = var.public_subnets_id[count.index]
  route_table_id = aws_route_table.public_rt.id
}


# private rt configuration
resource "aws_route_table" "private_rt" {
  #   vpc_id = aws_vpc.my_vpc.id
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "private_route_association" {
  count = length(var.private_subnet_cidrs)
  #   subnet_id      = aws_subnet.private_subnets[count.index].id
  subnet_id      = var.private_subnets_id[count.index]
  route_table_id = aws_route_table.private_rt.id
}