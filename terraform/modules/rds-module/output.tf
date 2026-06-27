output "rds_address" {
  value = aws_db_instance.APPBD.address
}

output "db_secret_arn" {
  value = aws_db_instance.APPBD.master_user_secret[0].secret_arn
}
