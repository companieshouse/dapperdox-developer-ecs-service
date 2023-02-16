provider "aws" {
  region  = var.aws_region
  version = "~> 4.54.0"
}

terraform {
  backend "s3" {
  }
}

# Configure the remote state data source to acquire configuration
# created through the code in ch-service-terraform/aws-mm-networks.
data "terraform_remote_state" "networks" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "${var.state_prefix}/${var.deploy_to}/${var.deploy_to}.tfstate"
    region = var.aws_region
  }
}
locals {
  vpc_id            = data.terraform_remote_state.networks.outputs.vpc_id
}

locals {
  # stack name is hardcoded here in main.tf for this stack. It should not be overridden per env
  stack_name       = "developer-site"
  stack_fullname   = "${local.stack_name}-stack"
  name_prefix      = "${local.stack_name}-${var.environment}"
}

data "aws_ecs_cluster" "ecs-cluster" {
  cluster_name = "${local.name_prefix}-cluster"
}
data "aws_iam_role" "ecs-cluster-iam-role" {
  name = "${local.name_prefix}-ecs-task-execution-role"
}

# retrieve all secrets for this stack using the stack path
data "aws_ssm_parameters_by_path" "secrets" {
  path = "/${local.name_prefix}"
}
# create a list of secrets names to retrieve them in a nicer format
locals {
  secrets_names = toset(data.aws_ssm_parameters_by_path.secrets.names)
}
# lookup each secret by name
data "aws_ssm_parameter" "secret" {
  for_each = local.secrets_names
  name = each.key
}
# create a map of secret name => secret arn to pass into ecs service module
# using the trimprefix function to remove the prefixed path from the secret name
locals{
  secrets_arns = {
      for sec in data.aws_ssm_parameter.secret:
        trimprefix(sec.name, "/${local.name_prefix}/") => sec.arn
    }
}

data "aws_lb" "dev-specs-lb" {
  name = "dev-specs-${var.environment}-lb"
}
data "aws_lb_listener" "dev-specs-lb-listener" {
  load_balancer_arn = data.aws_lb.dev-specs-lb.arn
  port = 443
}

module "ecs-services" {
  source = "./module-ecs-services"

  name_prefix               = local.name_prefix
  environment               = var.environment
  dev-specs-lb-arn          = data.aws_lb.dev-specs-lb.arn
  dev-specs-lb-listener-arn = data.aws_lb_listener.dev-specs-lb-listener.arn
  vpc_id                    = local.vpc_id
  aws_region                = var.aws_region
  ssl_certificate_id        = var.ssl_certificate_id
  external_top_level_domain = var.external_top_level_domain
  internal_top_level_domain = var.internal_top_level_domain
  account_subdomain_prefix  = var.account_subdomain_prefix
  ecs_cluster_id            = data.aws_ecs_cluster.ecs-cluster.id
  task_execution_role_arn   = data.aws_iam_role.ecs-cluster-iam-role.arn
  docker_registry           = var.docker_registry
  secrets_arn_map           = local.secrets_arns

  # dapperdox.developer.ch.gov.uk variables
  dapperdox_developer_version     = var.dapperdox_developer_version
  log_level                       = var.log_level
  include_api_filing_public_specs = var.include_api_filing_public_specs
  include_pending_public_specs    = var.include_pending_public_specs
  include_private_specs           = var.include_private_specs
}
