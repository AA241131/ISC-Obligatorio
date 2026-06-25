resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [var.subnet_id_input, var.subnet2_id_input]

  tags = {
    Name = "RDS subnet group"
  }
}

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
  multi_az              = false
  vpc_security_group_ids = var.sg_id_input
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
}

output "rds_endpoint" {
  value = aws_db_instance.APPBD.endpoint
}

