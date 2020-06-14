### ALB 

resource "aws_lb" "alb" {
  name               = format("%s-lb", var.name)
  internal           = false
  load_balancer_type = "application"

  subnets         = tolist(var.public_subnet_ids)
  security_groups = [var.web_sg_id]

  tags = merge(
    var.general_tags,
    { Name = format("%s-alb", var.name) }
  )
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn

  protocol = "HTTP"
  port     = var.alb_listener_port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name   = format("%s-alb-tg", var.name)
  vpc_id = var.vpc_id

  port        = var.app_port
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    protocol = "HTTP"
    matcher  = "200-299"
    port     = var.app_port
    path     = var.app_health_check_path

    interval            = var.alb_check_interval
    timeout             = var.alb_check_timeout
    healthy_threshold   = var.alb_threshold_healty
    unhealthy_threshold = var.alb_threshold_unhealty
  }
}

resource "aws_lb_target_group_attachment" "attach_ec2" {
  count            = length(var.web_instances_ids)
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = tolist(var.web_instances_ids)[count.index]
  port             = var.app_port
}
