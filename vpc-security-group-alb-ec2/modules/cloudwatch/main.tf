resource "aws_cloudwatch_metric_alarm" "nlb_healthyhosts" {
  alarm_name          = "alarmhost"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "Number of healthy nodes in Target Group"
  actions_enabled     = "true"
  alarm_actions       = [var.SNS_CPU_Utilization_arn]
  # ok_actions          = [aws_sns_topic.sns.arn]
  dimensions = {
    TargetGroup  = var.aws_lb_target_group_app_arn_suffix
    LoadBalancer = var.alb_app_web1_arn_suffix
    AvailabilityZone = "us-east-1b"
  }
}

# resource "aws_cloudwatch_metric_alarm" "average" {
#   alarm_name                = "terraform-test-foobar5"
#   comparison_operator       = "GreaterThanOrEqualToThreshold"
#   evaluation_periods        = "2"
#   metric_name               = "CPUUtilization"
#   namespace                 = "AWS/EC2"
#   period                    = "120"
#   statistic                 = "Average"
#   threshold                 = "80"
#   alarm_description         = "This metric monitors ec2 cpu utilization"
#   insufficient_data_actions = []
# }