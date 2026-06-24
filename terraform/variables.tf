variable "region" {
  type = string
  default = "us-east-1"
  description = "Variable para la region"
}

variable "profile" {
  type = string
  default = "default"
  description = "Variable para el perfil"
}

variable "instance_type_input" {
  type = string
  description = "Variable para el tipo de instancia"
}

variable "ami_input" {
  type = string
  description = "Variable para la imagen de la instancia"
}

variable "key_name_input" {
  type = string
  description = "Variable para el nombre del keypair"
  default = "vockey"
}

variable "instance_name" {
  type = string
  description = "Variable para el nombre de la instancia"  
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
