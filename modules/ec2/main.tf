resource "aws_launch_template" "csye6225_asg" {
  name          = "csye6225_asg"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.ec2_profile_name
  }

  user_data = base64encode(templatefile("${path.module}/../../scripts/user_data.sh", {
    DB_NAME     = var.DB_NAME,
    DB_USERNAME = var.DB_USERNAME,
    REGION      = var.region,
    SECRET_NAME = var.secret_manager_name,
    DB_HOST     = var.DB_HOST,
    BUCKET_NAME = var.BUCKET_NAME
  }))

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 25
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = var.kms_ec2_id
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = var.webapp_instance_public_subnet_id
    security_groups             = [var.security_group_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web application server"
    }
  }
}

resource "aws_autoscaling_group" "webapp_asg" {
  name                = "csye6225_asg"
  min_size            = 3
  max_size            = 5
  desired_capacity    = 3
  vpc_zone_identifier = [var.webapp_instance_public_subnet_id]
  target_group_arns   = [var.aws_lb_target_group_arn]

  launch_template {
    id      = aws_launch_template.csye6225_asg.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web application server"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale-up"
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
  policy_type            = "StepScaling"

  adjustment_type = "ChangeInCapacity"

  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = "0"
  }

  estimated_instance_warmup = 60
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 15
  alarm_description   = "Alarm when CPU > 5%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_up_policy.arn]
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale-down"
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
  policy_type            = "StepScaling"

  adjustment_type = "ChangeInCapacity"

  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_upper_bound = "0"
  }

  estimated_instance_warmup = 60
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "Alarm when CPU < 3%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_down_policy.arn]
}