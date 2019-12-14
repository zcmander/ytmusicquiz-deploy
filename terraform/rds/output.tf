output "db_access_sg_id" {
    value = aws_security_group.db_access_sg.id
}

output "rds_address" {
    value = aws_db_instance.default.address
}

output "rds_port" {
    value = aws_db_instance.default.port
}

output "rds_username" {
    value = aws_db_instance.default.username
}

output "rds_password" {
    value = aws_db_instance.default.password
    sensitive = true
}