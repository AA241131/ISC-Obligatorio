output "sg-instancias-id" {
  description = "ID de la instancia EC2 creada por el módulo"
  value = aws_security_group.sg-instancias.id
}

output "subnet-publica-id" {
  description = "ID de la subred pública creada por el módulo"
  value = aws_subnet.subnet-publica.id
}

output "subnet-privada-id" {
  description = "ID de la subred privada creada por el módulo"
  value = aws_subnet.subnet-privada.id
}

output "sg_http_id" {
  value = aws_security_group.Allow_HTTP.id
}

output "sg_mysql_id" {
  value = aws_security_group.Allow_MySQL.id
}