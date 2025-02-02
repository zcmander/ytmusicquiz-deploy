output "lb_target_group_id" {
    value = aws_lb_target_group.backend.id
}

output "lb_sg_id" {
  value = aws_security_group.lb_sg.id
}

output "lb_dns_name" {
  value = aws_lb.main.dns_name
}
