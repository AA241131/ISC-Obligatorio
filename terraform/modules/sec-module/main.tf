resource "aws_security_group" "Allow_SSH" {
  name        = "Allow_SSH"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id_input

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_SSH"
  }
}

resource "aws_security_group" "Allow_HTTP" {
  name        = "Allow_HTTP"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id_input

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_HTTP"
  }
}

resource "aws_security_group" "Allow_MySQL" {
  name        = "Allow_MySQL"
  description = "Allow MySQL inbound traffic"
  vpc_id      = var.vpc_id_input

  ingress {
    description      = "MySQL from Subnets"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks = [cidrsubnet(var.vpc_cidr_block, 8, 0), cidrsubnet(var.vpc_cidr_block, 8, 1)]
  }

  egress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_MySQL"
  }
}

#crear el security group para las instancias EC2
resource "aws_security_group" "sg-instancias" {
  name = "SG-Instancias-EC2"
  vpc_id = var.vpc_id_input
  tags = {
    Name      = "obligatorio-isc-sg-ec2"
  }
}

#crear el security group para las el load balancer
resource "aws_security_group" "sg-load-balancer" {
  name = "SG-Load-Balancer"
  vpc_id = var.vpc_id_input
  tags = {
    Name      = "obligatorio-isc-sg-ec2"
  }
}

#regla en ingreso desde lb en instancias 
resource "aws_vpc_security_group_ingress_rule" "ingreso-lb-instancias" {
  security_group_id = aws_security_group.sg-instancias.id

  referenced_security_group_id = aws_security_group.sg-load-balancer.id
  ip_protocol = "-1"
}

#regla en ingreso desde db en instancias 
resource "aws_vpc_security_group_ingress_rule" "ingreso-db-instancias" {
  security_group_id = aws_security_group.sg-instancias.id

  referenced_security_group_id = aws_security_group.Allow_MySQL.id
  ip_protocol = "-1"
}

#regla de ingreso desde internet al load balancer por puerto 80
resource "aws_vpc_security_group_ingress_rule" "ingreso-lb" {
  security_group_id = aws_security_group.sg-load-balancer.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

#reglas de egreso para el load balancer 
resource "aws_vpc_security_group_egress_rule" "egreso-lb" {
  security_group_id = aws_security_group.sg-load-balancer.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

#reglas de egreso para las instancias
resource "aws_vpc_security_group_egress_rule" "egreso-instancias" {
  security_group_id = aws_security_group.sg-instancias.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

# grupos de seguridad para el efs
resource "aws_security_group" "sg_efs" {
  name = "SG-EFS"
  vpc_id = var.vpc_id_input
  tags = {
    Name      = "obligatorio-isc-sg-efs"
  }
}

#regla en ingreso desde instancias en efs 
resource "aws_vpc_security_group_ingress_rule" "ingreso-efs" {
  security_group_id = aws_security_group.sg_efs.id

  referenced_security_group_id = aws_security_group.sg-instancias.id
  ip_protocol = "-1"
  /*
  from_port   = 2049
  ip_protocol = "tcp"
  to_port     = 2049
  */

}

#reglas de egreso para las efs
resource "aws_vpc_security_group_egress_rule" "egreso-efs" {
  security_group_id = aws_security_group.sg_efs.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}