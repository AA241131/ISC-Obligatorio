output "sg_http_id" {
  value = aws_security_group.Allow_HTTP.id
}

output "sg_mysql_id" {
  value = aws_security_group.Allow_MySQL.id
}

output "sg_ssh_id" {
  value = aws_security_group.Allow_SSH.id
}

output "sg_load_balancer_id" {
  value = aws_security_group.sg-load-balancer.id
}

output "sg_instancias_id" {
  value = aws_security_group.sg-instancias.id
}
