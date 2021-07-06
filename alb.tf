resource "aws_alb" "alb" {
  name               = "${var.resourcePrefix}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.alb-sg.id]

  tags = merge(
    {
      Name = "${var.resourcePrefix}-alb"
    },
    var.common_tag
  )
}

resource "aws_security_group" "alb-sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = merge(
    {
      Name = "${var.resourcePrefix}-alb-sg"
    },
    var.common_tag
  )
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.id
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg2.arn
  }

  condition {
    path_pattern {
      values = ["/server/*"]
    }
  }

}


resource "aws_lb_target_group" "tg" {
  name        = "${var.resourcePrefix}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = merge(
    {
      Name = "${var.resourcePrefix}-tg"
    },
    var.common_tag
  )
}

resource "aws_lb_target_group" "tg2" {
  name        = "${var.resourcePrefix}-tg2"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = merge(
    {
      Name = "${var.resourcePrefix}-tg2"
    },
    var.common_tag
  )
}