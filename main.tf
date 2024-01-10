data "awscc_organizations_organizations" "current" {}
data "awscc_organizations_organization" "current" {
  id = data.awscc_organizations_organizations.current.id
}

locals {
  create = var.create

  template_is_file = length(var.template_path) > 0
  template_body    = length(var.template_body) > 0 ? var.template_body : (local.template_is_file ? file(var.template_path) : null)

  auto_deployment = merge(
    {
      enabled                          = true
      retain_stacks_on_account_removal = false
    },
    var.auto_deployment
  )

  parameters = length(var.parameters) > 0 ? [
    for k, v in var.parameters : {
      parameter_key   = k
      parameter_value = v
    }
  ] : null

  tags = length(var.tags) > 0 ? [
    for k, v in var.tags : {
      key   = k
      value = v
    }
  ] : null
}

resource "awscc_cloudformation_stack_set" "this" {
  count = local.create ? 1 : 0

  stack_set_name = var.stack_set_name
  description    = var.stack_set_description

  template_body = local.template_body
  template_url  = var.template_url

  permission_model        = "SELF-MANAGED"
  administration_role_arn = null
  auto_deployment         = local.auto_deployment
  call_as                 = "SELF"
  capabilities            = var.capabilities
  execution_role_name     = null
  managed_execution = {
    active = try(var.managed_execution.active, false)
  }
  operation_preferences = {
    failure_tolerance_count      = lookup(var.operation_preferences, "failure_tolerance_count", null)
    failure_tolerance_percentage = lookup(var.operation_preferences, "failure_tolerance_percentage", null)
    max_concurrent_count         = lookup(var.operation_preferences, "max_concurrent_count", null)
    max_concurrent_percentage    = lookup(var.operation_preferences, "max_concurrent_percentage", null)
    region_concurrency_type      = lookup(var.operation_preferences, "region_concurrency_type", null)
    region_order                 = lookup(var.operation_preferences, "region_order", null)
  }
  parameters = local.parameters
  stack_instances_group = (
    length(var.deployment_targets > 0) ?
    [
      for item in var.deployment_targets : {
        deployment_targets = {
          account_filter_type     = lookup(item, "account_filter_type", null)
          accounts                = lookup(item, "accounts", null)
          accounts_url            = lookup(item, "accounts_url", null)
          organizational_unit_ids = lookup(item, "organizational_unit_ids", null)
        }
      }
    ] :
    [
      {
        deployment_targets = {
          organizational_unit_ids = data.awscc_organizations_organization.current.root_id
        }
      }
    ]
  )
  tags = local.tags
}
