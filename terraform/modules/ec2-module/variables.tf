variable "ami" {
  description = "Ami ID"
  type = string
}

variable "instance_type_input" {
  description = "Tipo de Instancia"
  type = string
}

variable "key_name" {
    type = string
}

variable "name_instance" {
    type = string
}

variable "subnet_id_input" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "sg_id_input" {
  description = "Security Group ID for the EC2 instance"
  type = list(string)
}

output "dns" {
  value = aws_instance.module-instance-deploy.public_dns
}