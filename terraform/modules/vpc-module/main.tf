# Modulo para crear VPC, Subnet, Internet Gateway, Route Table y Security Group

# Crear VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = var.nombre-vpc
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "main-igw"
  }
}

# crear la route table
resource "aws_route_table" "route-table-publica" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "obligatorio-isc-rt"
  }
}

# crear subnet publica
resource "aws_subnet" "subnet-publica" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet-publica-cidr

  tags = {
    Name = "obligatorio-isc-subnet-publica"
  }
}

# asociar la route table publica a la subnet publica
resource "aws_route_table_association" "public-subnet-assoc" {
  subnet_id      = aws_subnet.subnet-publica.id
  route_table_id = aws_route_table.route-table-publica.id
}

# crear subnet privada
resource "aws_subnet" "subnet-privada" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet-privada-cidr

  tags = {
    Name = "obligatorio-isc-subnet-privada"
  }
}

# SG para permitir tráfico SSH
resource "aws_security_group" "Allow_SSH" {
  name        = "Allow_SSH"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_SSH"
  }
}

resource "aws_security_group" "Allow_HTTP" {
  name        = "Allow_HTTP"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_HTTP"
  }
}

resource "aws_security_group" "Allow_MySQL" {
  name        = "Allow_MySQL"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "MySQL from Subnets"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks = [cidrsubnet(aws_vpc.vpc.id, 8, 0), cidrsubnet(aws_vpc.vpc.id, 8, 1)]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_MySQL"
  }
}

#crear el security group para las instancias EC2
resource "aws_security_group" "sg-instancias" {
  name = "SG-Instancias-EC2"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name      = "obligatorio-isc-sg-ec2"
  }
}

#crear el security group para load balancer
resource "aws_security_group" "sg-lb" {
  name = "SG-Load-Balancer"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name      = "obligatorio-isc-sg-lb"
  }
}

#crear el security group para el internet gateway
resource "aws_security_group" "sg-igw" {
  name = "SG-Internet-Gateway"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name      = "obligatorio-isc-sg-igw"
  }
}

#crear el security group para la base de datos RDS
resource "aws_security_group" "sg-rds" {
  name = "SG-RDS"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name      = "obligatorio-isc-sg-rds"
  }
}

#crear regla en ingreso de puerto 80 para sg igw
resource "aws_vpc_security_group_ingress_rule" "ingreso-igw" {
  security_group_id = aws_security_group.sg-igw.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

#regla de egreso de sg igw
resource "aws_vpc_security_group_egress_rule" "egreso-igw" {
  security_group_id = aws_security_group.sg-igw.id

  ip_protocol = "-1"          # todos los protocolos
  cidr_ipv4   = "0.0.0.0/0"   
}

#crear regla en ingreso lb
resource "aws_vpc_security_group_ingress_rule" "ingreso-lb" {
  security_group_id = aws_security_group.sg-lb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

#regla de egreso de lb
resource "aws_vpc_security_group_egress_rule" "egreso-lb" {
  security_group_id = aws_security_group.sg-lb.id

  ip_protocol = "-1"          # todos los protocolos
  cidr_ipv4   = "0.0.0.0/0"   
}

#crear el load balancer
resource "aws_lb" "lb" {
  name               = "obligatorio-isc-alb"  
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-lb.id]
  subnets            = aws_subnet.subnet-publica.id
}

# crear el listener para el load balancer
resource "aws_lb_listener" "ALB_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# crear el target group para el load balancer
resource "aws_lb_target_group" "target_group" {
  name     = "obligatorio-isc-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  
  health_check {
    path = "/"
    port = "traffic-port" #Utiliza el puerto de tráfico del target group
  }

}
 
resource "aws_lb_target_group_attachment" "asociacion1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.ec2_instance_id[0] # Asocia la primera instancia EC2 al target group
  port             = 80
}

/*
resource "aws_lb_target_group_attachment" "asociacion2" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.ec2_instance_id[1] # Asocia la segunda instancia EC2 al target group
  port             = 80
}
*/





