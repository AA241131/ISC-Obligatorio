provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project     = "Obligatorio"
    }
  }
}

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
    name_instance = "bastion-ec2"
    subnet_id_input = module.vpc-module.subnet_publica1_id
    sg_id_input = [module.sec-module.sg_instancias_id, module.sec-module.sg_ssh_id]
    depends_on = [
    aws_ecr_repository.repo
    ]

    user_data = templatefile("${path.root}/user_data_bastion.tpl", {
    db_host = module.rds-module.rds_address
    db_user = "admin"
    db_password = data.aws_secretsmanager_random_password.password.random_password
    db_name = "ecommerce"
    ecr_url = "${aws_ecr_repository.repo.repository_url}:ver1"
    efs_id = aws_efs_file_system.uploads.id
    })
    
}

module "rds-module" {
    source = "./modules/rds-module"
    subnet_id_input = module.vpc-module.subnet_privada1_id
    subnet2_id_input = module.vpc-module.subnet_privada2_id
    sg_id_input = [module.sec-module.sg_mysql_id]
    password = data.aws_secretsmanager_random_password.password.random_password
}

module "s3-module" {
    source = "./modules/s3-module"
}

module "alb-module" {
  source = "./modules/alb-module"
  vpc_id = module.vpc-module.vpc_id
  subnet_publica1_id = module.vpc-module.subnet_publica1_id
  subnet_publica2_id = module.vpc-module.subnet_publica2_id
  sg_load_balancer_id = module.sec-module.sg_load_balancer_id
}

module "cloudwatch-module" {
  source = "./modules/cloudwatch-module"
  alarm_email = var.admin_email
  load_balancer_arn_suffix = module.alb-module.lb_arn_suffix
  target_group_arn_suffix = module.alb-module.target_group_arn_suffix
}

module "autoscaling-module" {
    source = "./modules/autoscaling-module"
    vpc_id_input = module.vpc-module.vpc_id
    sg_id_input = module.sec-module.sg_instancias_id
    ami = var.ami_input
    instance_type = var.instance_type_input
    user_data = templatefile("${path.root}/user_data.launch_template.tpl", {
    db_host   = module.rds-module.rds_address
    db_password = data.aws_secretsmanager_random_password.password.random_password
    ecr_url = "${aws_ecr_repository.repo.repository_url}:ver1"
    efs_id = aws_efs_file_system.uploads.id
  })

    subnet_list = [module.vpc-module.subnet_publica1_id, module.vpc-module.subnet_publica2_id]
    target_group_arn = module.alb-module.target_group_arn
}

resource "aws_ecr_repository" "repo" {
  name = "ecommerce"
  force_delete = true
  tags = {
    Name = "ecommerce-ecr"
  }
}

data "aws_secretsmanager_random_password" "password" {
  password_length = 10
  exclude_numbers = true
  exclude_punctuation = true
  include_space = false
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "rds-ecommerce-secret"
  tags = {
    Name = "rds-ecommerce-secret"
  }
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = data.aws_secretsmanager_random_password.password.random_password
  })
}

resource "aws_efs_file_system" "uploads" {
  creation_token = "ecommerce-uploads"
  tags = {
    Name = "ecommerce-uploads-efs"
  }
}

#montar el efs en las subredes publicas
resource "aws_efs_mount_target" "publica1" {
  file_system_id  = aws_efs_file_system.uploads.id
  subnet_id       = module.vpc-module.subnet_publica1_id
  security_groups = [module.sec-module.sg_efs_id]
}

resource "aws_efs_mount_target" "publica2" {
  file_system_id  = aws_efs_file_system.uploads.id
  subnet_id       = module.vpc-module.subnet_publica2_id
  security_groups = [module.sec-module.sg_efs_id]
}