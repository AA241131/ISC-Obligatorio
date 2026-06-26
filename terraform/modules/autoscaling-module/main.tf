
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
  name = "Launch-template-obligatorio-isc"

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

resource "aws_autoscaling_group" "autoscaling_group" {
  min_size             = 1
  max_size             = 10
  desired_capacity     = 2 #cantidad de instancias iniciales
  launch_template {
    id      = aws_launch_template.launch_template_autoscaling.id
    version = "$Latest"
  }
  target_group_arns = [var.target_group_arn]
  vpc_zone_identifier  = var.subnet_list
}

#politica para mantener el promedio de CPU en 50%
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}