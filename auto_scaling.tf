resource "aws_autoscaling_group" "auto_scaling" {
  name                = "webApp_ASG"
  vpc_zone_identifier = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id, aws_subnet.public_subnet[2].id]
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  default_cooldown    = 60
  tag {
    key                 = "application"
    value               = "webapp"
    propagate_at_launch = true
  }
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  target_group_arns = [
    aws_lb_target_group.loadbalancer_targetgroup.arn
  ]

}

resource "aws_autoscaling_policy" "scaleIn_policy" {
  name                   = "scale-in"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.auto_scaling.name
}

resource "aws_cloudwatch_metric_alarm" "scaleIn_alarm" {
  alarm_name          = "scale-in"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 5
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.auto_scaling.name
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scaleIn_policy.arn]
}
resource "aws_autoscaling_policy" "scaleDown_policy" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.auto_scaling.name
}

resource "aws_cloudwatch_metric_alarm" "scaleDown_alarm" {
  alarm_name          = "scale-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 3
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.auto_scaling.name
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scaleDown_policy.arn]
}
