
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "sg_load_balancer_id" {
  description = "Security group ID para el load balancer"
  type        = string
}

variable "ec2_instance_id" {
  description = "ID de la instancia EC2"
  type        = string
}