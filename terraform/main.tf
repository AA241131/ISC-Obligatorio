module "vpc-module" {
    source = "./modules/vpc-module"
    vpc_cidr_block = var.vpc_cidr_block
}

module "sec-module" {
    source = "./modules/sec-module"
    vpc_id_input = module.vpc-module.vpc_id
    vpc_cidr_block = module.vpc-module.vpc_cidr_block
}

module "ec2-module" {
    source = "./modules/ec2-module"
    ami = var.ami_input
    instance_type_input = var.instance_type_input
    key_name = var.key_name_input
    name_instance = var.instance_name_input
    subnet_id_input = module.vpc-module.subnet_id
    sg_id_input = [module.sec-module.sg_ssh_id]
}

module "rds-module" {
    source = "./modules/rds-module"
    subnet_id_input = module.vpc-module.subnet_id
    subnet2_id_input = module.vpc-module.subnet2_id
    sg_id_input = [module.sec-module.sg_mysql_id]
}

module "s3-module" {
    source = "./modules/s3-module"
}