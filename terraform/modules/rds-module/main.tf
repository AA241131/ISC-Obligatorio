resource "aws_db_instance" "APPBD" {
  allocated_storage    = 50
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "12345678910"
  port                 = 3306
  parameter_group_name = "default.mysql8.0"
  publicly_accessible    = false
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.sg_id_input]
  db_subnet_group_name = [var.subnet_id_input]
}

