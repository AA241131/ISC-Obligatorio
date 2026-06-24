
variable "vpc-cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "nombre-vpc" {
  type = string
  description = "Variable para el nombre de la VPC"
}

variable "subnet-publica-cidr" {
  description = "CIDR block para la subred pública"
  type        = string
}

variable "subnet-privada-cidr" {
  description = "CIDR block para la subred privada"
  type        = string
}