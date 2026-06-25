resource "aws_vpc" "VPC_OBG" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "VPC_OBG"
  }
}

resource "aws_subnet" "VPC_subnet_publica" {
  vpc_id     = aws_vpc.VPC_OBG.id
  cidr_block = cidrsubnet(aws_vpc.VPC_OBG.cidr_block, 8, 0)
  availability_zone = "us-east-1a"
  tags = {
    Name = "VPC_subnet"
  }
}

resource "aws_subnet" "VPC_subnet_privada1" {
  vpc_id     = aws_vpc.VPC_OBG.id
  cidr_block = cidrsubnet(aws_vpc.VPC_OBG.cidr_block, 8, 1)
  availability_zone = "us-east-1a"
  tags = {
    Name = "VPC_subnet2"
  }
}

resource "aws_subnet" "VPC_subnet_privada2" {
  vpc_id     = aws_vpc.VPC_OBG.id
  cidr_block = cidrsubnet(aws_vpc.VPC_OBG.cidr_block, 8, 2)
  availability_zone = "us-east-1b"
  tags = {
    Name = "VPC_subnet2"
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

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.VPC_subnet_publica.id
  route_table_id = aws_route_table.public_rt.id
}




