resource "aws_instance" "ec2_instance" {
    instance_type = var.instance-type
    key_name = var.key-name
    ami = var.instance-ami
    iam_instance_profile = var.instance-iam-profile
    subnet_id = var.instance-subnet
    vpc_security_group_ids = [var.instance-security-groups]
    associate_public_ip_address = true
    user_data = file("${path.root}/user_data.sh")
    tags = {
        Name = var.instance-name
    }
}