
data "aws_iam_policy_document" "ecsTaskExecutionRole" {
    statement {
        actions = ["sts:AssumeRole"]

        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecsTaskExecutionRole.json
}