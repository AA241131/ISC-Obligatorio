variable "region" {
  type = string
}

variable "profile" {
  type = string
}

variable "instance_type_input" {
  type = string
}

variable "ami_input" {
  type = string
}

variable "key_name_input" {
  type = string
}

variable "instance_name_input" {
  type = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
