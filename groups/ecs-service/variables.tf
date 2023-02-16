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

# Certificates
variable "ssl_certificate_id" {
  type        = string
  description = "The ARN of the certificate for https access through the ALB."
}

# DNS
variable "zone_id" {
  default = "" # default of empty string is used as conditional when creating route53 records i.e. if no zone_id provided then no route53
  type        = string
  description = "The ID of the hosted zone to contain the Route 53 record."
}
variable "external_top_level_domain" {
  type        = string
  description = "The type levelel of the DNS domain for external access."
}
variable "internal_top_level_domain" {
  type        = string
  description = "The type levelel of the DNS domain for internal access."
}
variable "account_subdomain_prefix" {
  type = string
  description = "The first part of the account/identity service subdomain - either \"account\" or \"identity\""
  default = "account"
}

# ------------------------------------------------------------------------------
# Service configs
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
