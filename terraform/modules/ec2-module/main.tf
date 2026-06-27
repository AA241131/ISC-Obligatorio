# Modulo para creacion de instancia EC2

resource "aws_instance" "module-instance-deploy" {
    instance_type = var.instance_type_input
    key_name = var.key_name
    ami = var.ami
    iam_instance_profile = "LabInstanceProfile"
    subnet_id = var.subnet_id_input
    vpc_security_group_ids = var.sg_id_input
    associate_public_ip_address = true
    user_data = base64encode(var.user_data)
    tags = {
        Name = var.name_instance
    }
}

