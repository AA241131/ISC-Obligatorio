resource "aws_vpc" "VPC_OBG" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "VPC_OBG"
  }
}

resource "aws_subnet" "VPC_subnet_publica1" {
  vpc_id     = aws_vpc.VPC_OBG.id
  cidr_block = cidrsubnet(aws_vpc.VPC_OBG.cidr_block, 8, 0)
  availability_zone = "us-east-1a"
  tags = {
    Name = "VPC_subnet_publica1"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "VPC_subnet_publica2" {
  vpc_id     = aws_vpc.VPC_OBG.id
  cidr_block = cidrsubnet(aws_vpc.VPC_OBG.cidr_block, 8, 1)
  availability_zone = "us-east-1b"
  tags = {
    Name = "VPC_subnet_publica2"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "VPC_subnet_privada1" {
  vpc_id     = aws_vpc.VPC_OBG.id
  cidr_block = cidrsubnet(aws_vpc.VPC_OBG.cidr_block, 8, 2)
  availability_zone = "us-east-1a"
  tags = {
    Name = "VPC_subnet_privada1"
  }
}

resource "aws_subnet" "VPC_subnet_privada2" {
  vpc_id     = aws_vpc.VPC_OBG.id
  cidr_block = cidrsubnet(aws_vpc.VPC_OBG.cidr_block, 8, 3)
  availability_zone = "us-east-1b"
  tags = {
    Name = "VPC_subnet_privada2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC_OBG.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.VPC_OBG.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_subnet_assoc1" {
  subnet_id      = aws_subnet.VPC_subnet_publica1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_assoc2" {
  subnet_id      = aws_subnet.VPC_subnet_publica2.id
  route_table_id = aws_route_table.public_rt.id
}

#crear el load balancer
resource "aws_lb" "lb" {
  name               = "obligatorio-isc-alb"  
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_load_balancer_id]
  subnets            = [aws_subnet.VPC_subnet_publica1.id, aws_subnet.VPC_subnet_publica2.id]
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
  vpc_id   = aws_vpc.VPC_OBG.id
  
  health_check {
    path = "/"
    port = "traffic-port" #Utiliza el puerto de tráfico del target group
  }

}



