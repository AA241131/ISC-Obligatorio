variable "instance-ami" {
  description = "Ami ID"
  type = string
}

variable "instance-type" {
  description = "Tipo de Instancia"
  type = string
}

variable "instance-iam-profile" {
  description = "IAM Profile"
  type = string
}

variable "key-name" {
  description = "Key Pair Name"
  type = string
}

variable "instance-name" {
  description = "Name of the EC2 instance"
  type = string
}

variable "instance-subnet" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "instance-security-groups" {
  description = "Security Group ID for the EC2 instance"
  type        = string
}
