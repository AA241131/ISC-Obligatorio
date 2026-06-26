output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "composite_alarm_name" {
  value = aws_cloudwatch_composite_alarm.major_issues.alarm_name
}
