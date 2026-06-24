output "ec2-instance-id" {
  description = "ID de la instancia EC2 creada por el módulo"
  value = aws_instance.ec2_instance.id
}

