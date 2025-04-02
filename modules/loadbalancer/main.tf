# load balancer resource
resource "aws_lb" "app_alb" {
  name               = "webapp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_security_group_id]
  subnets            = var.public_subnets_id

  enable_deletion_protection = false

  tags = {
    Name = "my-app-alb"
  }
}


# load balancer target group
resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/healthz"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "app-tg"
  }
}

# load balancer listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

data "aws_route53_zone" "selected" {
  name         = "demo.hahahaha.it.com"
  private_zone = false
}

resource "aws_route53_record" "webapp_dns" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "demo.hahahaha.it.com"
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }
}