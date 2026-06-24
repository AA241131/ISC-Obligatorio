variable "instance_ami" {
  description = "Ami ID"
  type = string
}

variable "instance_type" {
  description = "Tipo de Instancia"
  type = string
}

variable "instance_iam_profile" {
  description = "IAM Profile"
  type = string
}

variable "key_name" {
  description = "Key Pair Name"
  type = string
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type = string
}

variable "instance_subnet" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "instance_security_groups" {
  description = "Security Group ID for the EC2 instance"
  type        = string
}

output "dns" {
  value = aws_instance.module-instance-deploy.public_dns
}