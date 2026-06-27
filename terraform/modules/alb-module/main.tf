resource "aws_lb" "lb" {
  name               = "obligatorio-isc-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_load_balancer_id]
  subnets            = [var.subnet_publica1_id, var.subnet_publica2_id]

  tags = {
    Name = "obligatorio-isc-alb"
  }
}

resource "aws_lb_listener" "ALB_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "obligatorio-isc-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    Name = "obligatorio-isc-target-group"
  }

  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 180
  }

  health_check {
    path = "/"
    port = "traffic-port"
  }
}