provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
  }
  required_version = "~> 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.54.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.18.0"
    }
  }
}

module "ecs-service" {
  source = "git@github.com:companieshouse/terraform-modules//aws/ecs/ecs-service?ref=1.0.215"

  # Environmental configuration
  environment             = var.environment
  aws_region              = var.aws_region
  aws_profile             = var.aws_profile
  vpc_id                  = data.aws_vpc.vpc.id
  ecs_cluster_id          = data.aws_ecs_cluster.ecs-cluster.id
  task_execution_role_arn = data.aws_iam_role.ecs-cluster-iam-role.arn

  # Load balancer configuration
  lb_listener_arn                 = data.aws_lb_listener.dev-specs-lb-listener.arn
  lb_listener_rule_priority       = local.lb_listener_rule_priority
  lb_listener_paths               = local.lb_listener_paths
  healthcheck_path                = "/"

  # Docker container details
  docker_registry   = var.docker_registry
  docker_repo       = local.docker_repo
  container_version = var.dapperdox_developer_version
  container_port    = local.container_port

  # Service configuration
  service_name = local.service_name
  name_prefix  = local.name_prefix

  # Service performance and scaling configs
  desired_task_count         = var.desired_task_count
  required_cpus              = var.required_cpus
  required_memory            = var.required_memory
  service_autoscale_enabled  = var.service_autoscale_enabled
  service_scaledown_schedule = var.service_scaledown_schedule
  service_scaleup_schedule   = var.service_scaleup_schedule

  # Service environment variable and secret configs
  task_environment = local.task_environment
  task_secrets     = local.task_secrets
}
