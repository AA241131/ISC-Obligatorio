variable "region" {
  description = "Region de AWS donde se desplegará la infraestructura"
  type = string
}

variable "profile" {
  description = "Perfil de AWS para autenticación"
  type = string
}

variable "instance_type_input" {
  description = "Tipo de instancia EC2"
  type = string
}

variable "ami_input" {
  description = "ID de la imagen AMI para la instancia EC2"
  type = string
}

variable "key_name_input" {
  description = "Nombre de la clave SSH para la instancia EC2"
  type = string
}

variable "instance_name_input" {
  description = "Nombre de la instancia EC2"
  type = string
}

variable "admin_email" {
  description = "email del administrador para notificaciones de CloudWatch"
  type        = string
}

variable "vpc_cidr_block" {
  description = "bloque CIDR para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}
