# root module
# Llamar a los módulos de VPC y EC2, pasando las variables necesarias

provider "aws" {
region = var.region
}

module "vpc-module" {
  source = "./modules/vpc-module"
  #variables para el modulo
  vpc-cidr = "10.0.0.0/16"
  nombre-vpc = "vpc-obligatorio-isc"
  subnet-publica-cidr = "10.0.1.0/24"
  subnet-privada-cidr = "10.0.2.0/24"
}

module "ec2-module" {
    source = "./modules/ec2-module"
    instance-ami = "ami-08f44e8eca9095668"
    instance-type = "t3.micro"
    instance-iam-profile = "LabInstanceProfile"
    key-name = "vockey"
    instance-name = "webserver1"
    instance-subnet = module.vpc-module.subnet-publica-id
    instance-security-groups = module.vpc-module.sg-instancias-id
}

