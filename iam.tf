resource "aws_iam_role" "ecs_role" {
  name = "${var.resourcePrefix}_ecs_tasks_role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
  tags = merge(
    {
      Name = "${var.resourcePrefix}_ecs_tasks_role"
    },
    var.common_tag
  )
}

resource "aws_iam_role_policy_attachment" "ecs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_policy_secrets" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.ecs_role.name
}