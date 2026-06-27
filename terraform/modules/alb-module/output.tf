output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.target_group.arn_suffix
}

output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}

output "lb_arn_suffix" {
  value = aws_lb.lb.arn_suffix
}