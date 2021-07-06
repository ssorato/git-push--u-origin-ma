data "aws_region" "current" {}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.resourcePrefix}-cluster"
  capacity_providers = ["FARGATE","FARGATE_SPOT"]

  tags = merge(
    {
      Name        = "${var.resourcePrefix}-cluster"
    },
    var.common_tag
  )
}

resource "aws_cloudwatch_log_group" "ecs-log-group" {
  name = "${var.resourcePrefix}-logs"
  tags = var.common_tag
}

resource "aws_ecs_service" "ecs-service-whoami" {
  name                  = "${var.resourcePrefix}-ecs-service-whoami"
  cluster               = aws_ecs_cluster.ecs-cluster.id
  task_definition       = aws_ecs_task_definition.ecs-task-whoami.arn
  launch_type           = "FARGATE"
  scheduling_strategy   = "REPLICA"
  desired_count         = 1
  force_new_deployment  = true

  network_configuration {
    subnets           = module.vpc.private_subnets
    assign_public_ip  = true
    security_groups   = [
      aws_security_group.ecs-service_sg.id,
      aws_security_group.alb-sg.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "whoami"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.listener]

  tags = var.common_tag
}

resource "aws_ecs_task_definition" "ecs-task-whoami" {
  family = "${var.resourcePrefix}-whoami"
  container_definitions = templatefile("ecs-tasks/whoami.json.tpl", {
    loggroup         = aws_cloudwatch_log_group.ecs-log-group.name
    region           = data.aws_region.current.name
  })
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_role.arn
  task_role_arn            = aws_iam_role.ecs_role.arn
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  tags = var.common_tag
}

resource "aws_ecs_service" "ecs-service-simpleapi" {
  name                  = "${var.resourcePrefix}-ecs-service-simpleapi"
  cluster               = aws_ecs_cluster.ecs-cluster.id
  task_definition       = aws_ecs_task_definition.ecs-task-simpleapi.arn
  launch_type           = "FARGATE"
  scheduling_strategy   = "REPLICA"
  desired_count         = 1
  force_new_deployment  = true

  network_configuration {
    subnets           = module.vpc.private_subnets
    assign_public_ip  = true
    security_groups   = [
      aws_security_group.ecs-service_sg.id,
      aws_security_group.alb-sg.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg2.arn
    container_name   = "simpleapi"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.listener]

  tags = var.common_tag
}

resource "aws_ecs_task_definition" "ecs-task-simpleapi" {
  family = "${var.resourcePrefix}-simpleapi"
  container_definitions = templatefile("ecs-tasks/simple-api.json.tpl", {
    loggroup         = aws_cloudwatch_log_group.ecs-log-group.name
    region           = data.aws_region.current.name
  })
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_role.arn
  task_role_arn            = aws_iam_role.ecs_role.arn
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  tags = var.common_tag
}

resource "aws_security_group" "ecs-service_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "${var.resourcePrefix}-ecs-service-sg"
    },
    var.common_tag
  )
}

