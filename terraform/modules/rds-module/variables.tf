variable subnet_id_input {
  description = "The ID of the first subnet where the RDS instance will be created"
  type        = string
}

variable subnet2_id_input {
  description = "The ID of the second subnet for RDS multi-AZ"
  type        = string
}

variable "sg_id_input" {
  description = "The ID of the security group to associate with the RDS instance"
  type = list(string)
}

variable "password" {
  description = "password para la base de datos"
  type        = string
  sensitive   = true
}