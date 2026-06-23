variable subnet_id_input {
  description = "The ID of the subnet where the RDS instance will be created"
  type        = string
}

variable sg_id_input {
  description = "The ID of the security group to associate with the RDS instance"
  type        = string
}