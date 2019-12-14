

output "vpc_id" {
    value = aws_default_vpc.default.id
}

output "sg_id" {
    value = aws_default_security_group.default.id
}

output "subnet1_id" {
    value = aws_default_subnet.default_az1.id
}

output "subnet2_id" {
    value = aws_default_subnet.default_az2.id
}