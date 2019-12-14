variable "vpc_id" {
    type = string
}

variable "subnet_id" {
    type = string
}

variable "task_execution_role_arn" {
    type = string
}

variable "db_access_sg_id" {
    type = string
}

variable "rds_address" {
    type = string
}

variable "rds_port" {
    type = string
}

variable "rds_username" {
    type = string
}

variable "rds_password" {
    type = string
}

variable "lb_target_group_id" {
    type = string
}