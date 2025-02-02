resource "aws_ecs_cluster" "ytmusicquiz-cluster" {
  name = "ytmusicquiz-ecs-cluster"
}

resource "aws_ecs_task_definition" "ytmusicquiz-task" {
  family                = "ytmusicquiz-task"
  container_definitions = templatefile("task-definition.json", {
      rds_host = var.rds_address
      rds_port = var.rds_port
      rds_username = var.rds_username
      rds_password = var.rds_password

      image_ytmusicquiz_static = var.image-ytmusicquiz-static
      image_ytmusicquiz_proxy = var.image-ytmusicquiz-proxy
      image_ytmusicquiz_dashboard = var.image-ytmusicquiz-dashboard
      image_ytmusicquiz = var.image-ytmusicquiz
  })

  execution_role_arn = var.task_execution_role_arn

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
          var.subnet_id
      ]
      security_groups = [
          aws_security_group.ecs_sg.id,
          var.db_access_sg_id
      ]
      assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.lb_target_group_id
    container_name   = "ytmusicquiz-proxy"
    container_port   = "80"
  }
}

resource "aws_security_group" "ecs_access_sg" {
  vpc_id      = var.vpc_id
  name        = "ecs-access-sg"
  description = "Allow access to ECS"
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = var.vpc_id
  name      = "ecs_sg"
  description = "Elastic Container Service tasks"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
    description = ""
  }

  ingress {
    protocol        = "tcp"
    from_port = 80
    to_port   = 80
    security_groups = [
          aws_security_group.ecs_access_sg.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}