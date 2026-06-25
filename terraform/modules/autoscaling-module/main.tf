resource "aws_lb_target_group" "autoscaling_target_group" {
  name     = "target group obligatorio-isc"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id_input
}

/*launch configuration, obsoleto
resource "aws_launch_configuration" "launch_template" {
  name_prefix     = "obligatorio-asg-"
  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  user_data       = file("user-data.sh")
  security_groups = [var.sg_id_input]

  lifecycle {
    create_before_destroy = true
  }
}
*/

resource "aws_launch_template" "launch_template_autoscaling" {
  name = "Launch template obligatorio-isc"

  iam_instance_profile {
    name = "LabInstanceProfile"
  }

  image_id = "ami-0236922087fa98b6e"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  key_name = "vockey"

  vpc_security_group_ids = [var.sg_id_input]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "instancia-ec2-autoscaling"
    }
  }

  user_data = base64encode(var.user_data)
}
