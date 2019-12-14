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
          var.subnet_id
      ]
      security_groups = [
          var.lb_access_sg_id,
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