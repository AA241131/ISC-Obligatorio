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

resource "aws_security_group" "Allow_HTTP" {
  name        = "Allow_HTTP"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.VPC_OBG.id

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
  vpc_id      = aws_vpc.VPC_OBG.id

  ingress {
    description      = "MySQL from Subnets"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks = [cidrsubnet(aws_vpc.VPC_OBG.cidr_block, 8, 0), cidrsubnet(aws_vpc.VPC_OBG.cidr_block, 8, 1)]
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


output "sg_http_id" {
  value = aws_security_group.Allow_HTTP.id
}

output "sg_mysql_id" {
  value = aws_security_group.Allow_MySQL.id
}

output "sg_id" {
  value = aws_security_group.Allow_SSH.id
}