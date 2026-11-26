# --- Auto Scaling Group: mantiene los servidores web y los reemplaza si fallan ---
resource "aws_autoscaling_group" "web" {
  name                      = "ha-web-asg"
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  vpc_zone_identifier       = aws_subnet.private[*].id
  target_group_arns         = [aws_lb_target_group.web.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}

# --- Escalado automatico: mantiene la CPU media alrededor del 50 % ---
resource "aws_autoscaling_policy" "cpu" {
  name                   = "ha-cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }
}