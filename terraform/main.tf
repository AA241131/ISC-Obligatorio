# root module
# Llamar a los módulos de VPC y EC2, pasando las variables necesarias

provider "aws" {
region = var.region
}

module "vpc-module" {
  source = "./modules/vpc"
  #variables para el modulo
  vpc_cidr   = "10.0.0.0/16"
  nombre_vpc = "vpc-obligatorio-isc"
}

module "ec2-module" {
    source = "./modules/ec2-module"
    instance_ami = "ami-08f44e8eca9095668"
    instance_type = "t3.micro"
    instance_iam_profile = "LabInstanceProfile"
    key_name = "vockey"
    instance_name = "webserver1"
    instance_subnet = module.vpc-module.subnet-publica-id
    instance_security_groups = module.vpc-module.sg-instancias-id
}

output "dns-output" {
    value = module.ec2-module.dns
}