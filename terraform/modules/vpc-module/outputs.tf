output "sg-instancias-id" {
  description = "ID de la instancia EC2 creada por el módulo"
  value = aws_security_group.sg-instancias.id
}

output "subnet-publica-id" {
  description = "ID de la subred pública creada por el módulo"
  value = aws_subnet.subnet-publica.id
}