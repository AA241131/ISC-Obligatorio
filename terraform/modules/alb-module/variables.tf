variable "vpc_id" {
  description = "VPC ID where the ALB is deployed"
  type        = string
}

variable "subnet_publica1_id" {
  description = "First public subnet ID"
  type        = string
}

variable "subnet_publica2_id" {
  description = "Second public subnet ID"
  type        = string
}

variable "sg_load_balancer_id" {
  description = "Security group ID for the load balancer"
  type        = string
}