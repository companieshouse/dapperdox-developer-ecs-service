locals {
  service_name             = "dapperdox-developer"
  dapperdox_developer_port = "10000"
}

resource "aws_ecs_service" "dapperdox-developer-ecs-service" {
  name            = "${var.environment}-${local.service_name}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.dapperdox-developer-task-definition.arn
  desired_count   = 1
  load_balancer {
    target_group_arn = aws_lb_target_group.dapperdox-developer-target_group.arn
    container_port   = local.dapperdox_developer_port
    container_name   = "dapperdox-developer"
  }
}

locals {
  definition = merge(
    {
      service_name               : local.service_name
      environment                : var.environment
      name_prefix                : var.name_prefix
      aws_region                 : var.aws_region
      external_top_level_domain  : var.external_top_level_domain
      account_subdomain_prefix   : var.account_subdomain_prefix
      docker_registry            : var.docker_registry

      # dapperdox developer specific configs
      dapperdox_developer_port        : local.dapperdox_developer_port
      dapperdox_developer_version     : var.dapperdox_developer_version
      log_level                       : var.log_level
      include_api_filing_public_specs : var.include_api_filing_public_specs
      include_pending_public_specs    : var.include_pending_public_specs
      include_private_specs           : var.include_private_specs
    },
      var.secrets_arn_map
  )
}

resource "aws_ecs_task_definition" "dapperdox-developer-task-definition" {
  family                = "${var.environment}-${local.service_name}"
  execution_role_arn    = var.task_execution_role_arn
  container_definitions = templatefile(
    "${path.module}/${local.service_name}-task-definition.tmpl", local.definition
  )
}

resource "aws_lb_target_group" "dapperdox-developer-target_group" {
  name     = "${var.environment}-${local.service_name}"
  port     = local.dapperdox_developer_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_lb_listener_rule" "dapperdox-developer" {
  listener_arn = var.dev-specs-lb-listener-arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dapperdox-developer-target_group.arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
