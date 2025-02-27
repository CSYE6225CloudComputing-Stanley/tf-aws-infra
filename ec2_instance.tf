resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = lookup({ for s in aws_subnet.public_subnets : s.cidr_block => s.id }, var.webapp_instance_public_subnet)
  vpc_security_group_ids      = [aws_security_group.application_security_group.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  disable_api_termination = false

  tags = { Name = "web application server" }
}