resource "aws_vpc" "VPC_OBG" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "VPC_OBG"
  }
}

resource "aws_subnet" "VPC_subnet" {
  vpc_id     = aws_vpc.VPC_OBG.id
  cidr_block = cidrsubnet(aws_vpc.VPC_OBG.cidr_block, 8, 0)
  availability_zone = "us-east-1a"
  tags = {
    Name = "VPC_subnet"
  }
}

resource "aws_subnet" "VPC_subnet2" {
  vpc_id     = aws_vpc.VPC_OBG.id
  cidr_block = cidrsubnet(aws_vpc.VPC_OBG.cidr_block, 8, 1)
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
  subnet_id      = aws_subnet.VPC_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


output "vpc_id" {
  value = aws_vpc.VPC_OBG.id
}

output "subnet_id" {
  value = aws_subnet.VPC_subnet.id
}

output "subnet2_id" {
  value = aws_subnet.VPC_subnet2.id
}

output "vpc_cidr_block" {
  value = aws_vpc.VPC_OBG.cidr_block
}

