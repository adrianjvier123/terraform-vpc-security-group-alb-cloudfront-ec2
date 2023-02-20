resource "aws_lb_target_group" "alb_tg_app_web" {
  name     = "alb-tg-app-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled = true
    healthy_threshold = 3
    matcher = 200
    path = "/"
    timeout = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "attach_app_web1" {
  target_group_arn = aws_lb_target_group.alb_tg_app_web.arn
  target_id        = var.ec2_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach_app_web2" {
  target_group_arn = aws_lb_target_group.alb_tg_app_web.arn
  target_id        = var.ec2_2_id
  port             = 80
}

resource "aws_lb" "alb_app_web1" {
  name               = "alb-app-web1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_alb_tls_id]
  subnets            = ["${var.private_app_subnet_az2_id}", "${var.public_subnet_az1_id}"]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}
resource "aws_lb_listener" "front_end"{ 
  load_balancer_arn = aws_lb.alb_app_web1.arn
  port              = "80"
  protocol          = "HTTP"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_app_web.arn
  }
}