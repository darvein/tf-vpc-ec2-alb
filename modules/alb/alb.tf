resource "aws_lb" "alb" {
  name               = format("%s-lb", var.project_name)
  internal           = false
  load_balancer_type = "application"

  subnets         = tolist(data.aws_subnet_ids.public.ids)
  security_groups = [aws_security_group.web.id]

  tags = merge(
    local.general_tags,
    { Name = format("%s-alb", var.project_name) }
  )
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn

  protocol = "HTTP"
  port     = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name   = format("%s-alb-tg", var.project_name)
  vpc_id = aws_vpc.vpc.id

  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    interval            = 30
    port                = 80
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
    path                = "/status.html"
  }
}

resource "aws_lb_target_group_attachment" "attach_ec2" {
  count            = length(aws_instance.web.*)
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = tolist(aws_instance.web.*.id)[count.index]
  port             = 80
}
