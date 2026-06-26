resource "aws_sns_topic" "alerts" {
  name = "${var.alarm_prefix}-alerts"

  tags = {
    Name = "${var.alarm_prefix}-alerts"
  }
}

resource "aws_sns_topic_subscription" "admin_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_major" {
  alarm_name          = "${var.alarm_prefix}-alb-5xx"
  alarm_description   = "Major ALB 5xx error rate detected"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods   = 2
  datapoints_to_alarm  = 2
  threshold           = 10
  period              = 300
  statistic           = "Sum"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  treat_missing_data   = "notBreaching"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "target_5xx_major" {
  alarm_name          = "${var.alarm_prefix}-target-5xx"
  alarm_description   = "Major target 5xx error rate detected"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods   = 2
  datapoints_to_alarm  = 2
  threshold           = 10
  period              = 300
  statistic           = "Sum"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  treat_missing_data   = "notBreaching"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts_major" {
  alarm_name          = "${var.alarm_prefix}-unhealthy-hosts"
  alarm_description   = "One or more workers are unhealthy"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods   = 2
  datapoints_to_alarm  = 2
  threshold           = 1
  period              = 60
  statistic           = "Maximum"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "UnHealthyHostCount"
  treat_missing_data   = "notBreaching"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }
}

resource "aws_cloudwatch_composite_alarm" "major_issues" {
  alarm_name        = "${var.alarm_prefix}-composite"
  alarm_description = "Major load balancer or worker outage conditions"
  alarm_rule        = "ALARM(${aws_cloudwatch_metric_alarm.alb_5xx_major.alarm_name}) OR ALARM(${aws_cloudwatch_metric_alarm.target_5xx_major.alarm_name}) OR ALARM(${aws_cloudwatch_metric_alarm.unhealthy_hosts_major.alarm_name})"

  alarm_actions = [aws_sns_topic.alerts.arn]
}
