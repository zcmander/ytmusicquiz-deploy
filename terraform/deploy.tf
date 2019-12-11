# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

# Use default VPC
resource "aws_default_vpc" "default" {
}

resource "aws_default_subnet" "default_az1" {
    availability_zone = "eu-west-1a"
    map_public_ip_on_launch = true
}

resource "aws_default_subnet" "default_az2" {
    availability_zone = "eu-west-1b"
    map_public_ip_on_launch = true
}

resource "aws_eip" "lb" {
    vpc      = true
}

resource "aws_route_table" "r" {
  vpc_id = aws_default_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-09263f1d531028a57"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_default_subnet.default_az1.id
  route_table_id = aws_route_table.r.id
}

resource "aws_ecr_repository" "ytmusicquiz" {
  name                 = "ytmusicquiz"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "ytmusicquiz-static" {
  name                 = "ytmusicquiz-static"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "ytmusicquiz-proxy" {
  name                 = "ytmusicquiz-proxy"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "ytmusicquiz-dashboard" {
  name                 = "ytmusicquiz-dashboard"
  image_tag_mutability = "MUTABLE"
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_http" {
    security_group_id = aws_default_security_group.default.id
    type            = "ingress"
    protocol        = "tcp"
    cidr_blocks = [
        "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
}

resource "aws_lb" "main" {
    name               = "ytmusicquiz-lb"
    internal           = false
    load_balancer_type = "application"

    security_groups    = [
        aws_default_security_group.default.id
    ]

    subnets            = [
        aws_default_subnet.default_az1.id,
        aws_default_subnet.default_az2.id,
    ]

    enable_deletion_protection = false
}

resource "aws_lb_target_group" "backend" {
  name     = "ytmusicgtoup-albtg"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_default_vpc.default.id
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

resource "aws_ecs_cluster" "ytmusicquiz-cluster" {
  name = "ytmusicquiz-ecs-cluster"
}

resource "aws_ecs_task_definition" "ytmusicquiz-task" {
  family                = "ytmusicquiz-task"
  container_definitions = templatefile("task-definition.json", {
      rds_host = aws_db_instance.default.address
      rds_port = aws_db_instance.default.port
      rds_username = aws_db_instance.default.username
      rds_password = aws_db_instance.default.password
  })

  execution_role_arn = "arn:aws:iam::074957091972:role/ecsTaskExecutionRole"

  cpu = 256
  memory = 512
  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"
}

resource "aws_ecs_service" "ytmusicquiz" {
  name                = "ytmusicquiz-service"
  cluster             = aws_ecs_cluster.ytmusicquiz-cluster.id
  task_definition     = aws_ecs_task_definition.ytmusicquiz-task.arn
  desired_count       = 1
  launch_type         = "FARGATE"

  network_configuration {
      subnets = [
          aws_default_subnet.default_az1.id
      ]
      security_groups = [
          aws_default_security_group.default.id,
          aws_security_group.db_access_sg.id,
      ]
      assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.id
    container_name   = "ytmusicquiz-proxy"
    container_port   = "80"
  }
}

resource "aws_security_group" "db_access_sg" {
  vpc_id      = aws_default_vpc.default.id
  name        = "db-access-sg"
  description = "Allow access to RDS"
}

resource "aws_security_group" "rds_sg" {
  name = "rds-sg"
  description = "DB Security Group"
  vpc_id = aws_default_vpc.default.id

  // allows traffic from the SG itself
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
  }

  //allow traffic for TCP 5432
  ingress {
      from_port = 5432
      to_port   = 5432
      protocol  = "tcp"
      security_groups = [
          aws_security_group.db_access_sg.id
      ]
  }

  // outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "default" {
    allocated_storage    = 5
    engine               = "postgres"
    engine_version       = "11.5"
    instance_class       = "db.t2.micro"
    name                 = "ytmusicquiz"
    username             = "ytmusicquizadmin"
    password             = "adminpass"

    vpc_security_group_ids = [aws_security_group.rds_sg.id]

    skip_final_snapshot    = true
}