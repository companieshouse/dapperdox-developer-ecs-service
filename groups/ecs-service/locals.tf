# Define all hardcoded local variable and local variables looked up from data resources
locals {
  stack_name                = "developer-site" # this must match the stack name the service deploys into
  name_prefix               = "${local.stack_name}-${var.environment}"
  service_name              = "dapperdox-developer"
  container_port            = "10000"
  docker_repo               = "dapperdox.developer.ch.gov.uk"
  lb_listener_rule_priority = 10
  lb_listener_paths         = ["/*"]
  vpc_name                  = data.aws_ssm_parameter.secret[format("/%s/%s", local.name_prefix, "vpc-name")].value


  # create a map of secret name => secret arn to pass into ecs service module
  # using the trimprefix function to remove the prefixed path from the secret name
  secrets_arn_map = {
    for sec in data.aws_ssm_parameter.secret :
    trimprefix(sec.name, "/${local.name_prefix}/") => sec.arn
  }

  task_secrets = []

  task_environment = [
    { "name" : "PORT", "value" : local.container_port },
    { "name" : "LOGLEVEL", "value" : var.log_level },
    { "name" : "INCLUDE_API_FILING_PUBLIC_SPECS", "value" : var.include_api_filing_public_specs },
    { "name" : "INCLUDE_PENDING_PUBLIC_SPECS", "value" : var.include_pending_public_specs },
    { "name" : "INCLUDE_PRIVATE_SPECS", "value" : var.include_private_specs }
  ]
}
