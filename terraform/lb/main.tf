
resource "aws_lb" "main" {
    name               = "ytmusicquiz-lb"
    internal           = false
    load_balancer_type = "application"

    security_groups    = [
        var.sg_id
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