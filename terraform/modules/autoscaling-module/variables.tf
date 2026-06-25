variable "vpc_id_input" {
  description = "VPC ID para el Auto Scaling group"
  type        = string
}

variable "sg_id_input" {
  description = "Security group ID para la instancia del Auto Scaling group"
  type        = string
}

variable "user_data" {
  description = "User data para las EC2 instances"
  type        = string
}

variable "subnet_list" {
  description = "Lista de subnets para el Auto Scaling group"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN del target group para el Auto Scaling group"
  type        = string
}