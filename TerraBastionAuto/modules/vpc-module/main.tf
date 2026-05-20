resource "aws_vpc" "VPC_OBG" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "VPC_OBG"
  }
}

resource "aws_subnet" "VPC_subnet" {
  vpc_id     = aws_vpc.VPC_OBG.id
  cidr_block = cidrsubnet(aws_vpc.VPC_OBG.cidr_block, 8, 0)

  tags = {
    Name = "VPC_subnet"
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

resource "aws_security_group" "Allow_SSH" {
  name        = "Allow_SSH"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.VPC_OBG.id

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

output "vpc_id" {
  value = aws_vpc.VPC_OBG.id
}

output "subnet_id" {
  value = aws_subnet.VPC_subnet.id
}

output "sg_id" {
  value = aws_security_group.Allow_SSH.id
}
