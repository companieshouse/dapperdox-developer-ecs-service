# Environment
variable "environment" {
  type        = string
  description = "The environment name, defined in envrionments vars."
}
variable "aws_region" {
  type        = string
  description = "The AWS region for deployment."
}

# Networking
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC for the target group and security group."
}
variable "dev_specs_lb_listener_arn" {
  type        = string
  description = "The ARN of the lb listener created in the ecs-stack module."
}

# ECS Service
variable "name_prefix" {
  type        = string
  description = "The name prefix to be used for stack / environment name spacing."
}
variable "ecs_cluster_id" {
  type        = string
  description = "The ARN of the ECS cluster to deploy the service to."
}

# Docker Container
variable "docker_registry" {
  type        = string
  description = "The FQDN of the Docker registry."
}
variable "task_execution_role_arn" {
  type        = string
  description = "The ARN of the task execution role that the container can assume."
}

# Secrets
variable "secrets_arn_map" {
  type = map(string)
  description = "The ARNs for all secrets"
}

# ------------------------------------------------------------------------------
# Service configs
# ------------------------------------------------------------------------------
variable "log_level" {
  type        = string
}
variable "dapperdox_developer_version" {
  type        = string
}
variable "include_api_filing_public_specs" {
  type = string
}
variable "include_pending_public_specs" {
  type = string
}
variable "include_private_specs" {
  type = string
}
