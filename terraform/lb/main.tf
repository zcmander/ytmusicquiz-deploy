
resource "aws_lb" "main" {
    name               = "ytmusicquiz-lb"
    internal           = false
    load_balancer_type = "application"

    security_groups    = [
        aws_security_group.lb_sg.id,
        var.access_sg_id
    ]

    subnets            = var.subnets
    enable_deletion_protection = false
}

resource "aws_lb_target_group" "backend" {
  name     = "ytmusicgtoup-albtg"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.backend.id
    type             = "forward"
  }
}

resource "aws_security_group" "lb_sg" {
  vpc_id = var.vpc_id

  name = "lb_sg"
  description = "Load balancers"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
    description = ""
  }

  ingress {
    protocol        = "tcp"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}