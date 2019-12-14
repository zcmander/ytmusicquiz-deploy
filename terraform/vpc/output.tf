

output "vpc_id" {
    value = aws_vpc.default.id
}

output "subnet1_id" {
    value = aws_subnet.az1.id
}

output "subnet2_id" {
    value = aws_subnet.az2.id
}