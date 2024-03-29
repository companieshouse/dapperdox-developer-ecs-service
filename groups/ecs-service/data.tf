data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_ecs_cluster" "ecs-cluster" {
  cluster_name = "${local.name_prefix}-cluster"
}
data "aws_iam_role" "ecs-cluster-iam-role" {
  name = "${local.name_prefix}-ecs-task-execution-role"
}

data "aws_lb" "dev-specs-lb" {
  name = "dev-specs-${var.environment}-lb"
}
data "aws_lb_listener" "dev-specs-lb-listener" {
  load_balancer_arn = data.aws_lb.dev-specs-lb.arn
  port              = 443
}

# retrieve all secrets for this stack using the stack path
data "aws_ssm_parameters_by_path" "secrets" {
  path = "/${local.name_prefix}"
}
# create a list of secrets names to retrieve them in a nicer format and lookup each secret by name
data "aws_ssm_parameter" "secret" {
  for_each = toset(data.aws_ssm_parameters_by_path.secrets.names)
  name     = each.key
}
