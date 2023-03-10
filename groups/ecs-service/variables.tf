# Environment
variable "environment" {
  type        = string
  description = "The environment name, defined in envrionments vars."
}
variable "aws_region" {
  default     = "eu-west-2"
  type        = string
  description = "The AWS region for deployment."
}
variable "aws_profile" {
  default     = "development-eu-west-2"
  type        = string
  description = "The AWS profile to use for deployment."
}

# Terraform
variable "aws_bucket" {
  type        = string
  description = "The bucket used to store the current terraform state files"
}
variable "remote_state_bucket" {
  type        = string
  description = "Alternative bucket used to store the remote state files from ch-service-terraform"
}
variable "state_prefix" {
  type        = string
  description = "The bucket prefix used with the remote_state_bucket files."
}
variable "deploy_to" {
  type        = string
  description = "Bucket namespace used with remote_state_bucket and state_prefix."
}

# Docker Container
variable "docker_registry" {
  type        = string
  description = "The FQDN of the Docker registry."
}

# ------------------------------------------------------------------------------
# Service performance and scaling configs
# ------------------------------------------------------------------------------

variable "desired_task_count" {
  type = number
  description = "The desired ECS task count for this service"
  default = 1
}
variable "required_cpus" {
  type = number
  description = "The required cpu count for this service"
  default = 1
}
variable "required_memory" {
  type = number
  description = "The required memory for this service"
  default = 512
}

# ------------------------------------------------------------------------------
# Service environment variable configs
# ------------------------------------------------------------------------------

variable "log_level" {
  default     = "info"
  type        = string
  description = "The log level for services to use: trace, debug, info or error"
}
variable "dapperdox_developer_version" {
  type        = string
  description = "The version of the dapperdox.developer.ch.gov.uk container to run."
}
variable "include_api_filing_public_specs" {
  type = string
  default = "1"
}
variable "include_pending_public_specs" {
  type = string
  default = "0"
}
variable "include_private_specs" {
  type = string
  default = "0"
}
