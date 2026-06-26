variable "alarm_email" {
  description = "Admin email address for CloudWatch alarm notifications"
  type        = string
}

variable "load_balancer_arn_suffix" {
  description = "ALB ARN suffix used by ApplicationELB metrics"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "Target group ARN suffix used by ApplicationELB metrics"
  type        = string
}

variable "alarm_prefix" {
  description = "Prefix for CloudWatch alarm names"
  type        = string
  default     = "ecommerce-major-issues"
}