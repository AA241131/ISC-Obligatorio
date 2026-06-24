module "vpc-module" {
    source = "./modules/vpc-module"
    vpc_cidr_block = var.vpc_cidr_block
}

module "ec2-module" {
    source = "./modules/ec2-module"
    ami = var.ami_input
    instance_type_input = var.instance_type_input
    key_name = var.key_name_input
    name_instance = var.instance_name_input
    subnet_id_input = module.vpc-module.subnet_id
    sg_id_input = module.vpc-module.sg_id
}

