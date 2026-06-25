resource "aws_instance" "module-instance-deploy" {
    instance_type = var.instance_type_input
    key_name = var.key_name
    ami = var.ami
    iam_instance_profile = "LabInstanceProfile"
    subnet_id = var.subnet_id_input
    vpc_security_group_ids = var.sg_id_input
    associate_public_ip_address = true
    user_data = <<-EOF
                #!/bin/bash
                docker run -d 
                --name ecommerce 
                -p 80:80 
                -e DB_HOST="${db_host}" 
                -e DB_NAME="ecommerce" 
                -e DB_USER="admin" 
                -e DB_PASSWORD="supersecret" 
                "$ECR_URI":ver1
                EOF
    tags = {
        Name = var.name_instance
    }
}

