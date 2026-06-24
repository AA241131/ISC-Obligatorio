resource "aws_instance" "ec2_instance" {
    instance_type = var.instance_type
    key_name = var.key_name
    ami = var.instance_ami
    iam_instance_profile = var.instance_iam_profile
    subnet_id = var.instance_subnet
    vpc_security_group_ids = [var.instance_security_groups]
    associate_public_ip_address = true
    user_data = file("./user_data.sh")
    tags = {
        Name = var.instance_name
    }
}