run "validate_creation" {
  command = apply

  assert {
    condition     = module.multi_scheduler.resource_group_name == azurerm_resource_group.test.name
    error_message = "Resource group name should be the same as the module resource group name"
  }

  assert {
    condition     = azurerm_resource_group.test.location == "swedencentral"
    error_message = "Resource group should be in swedencentral region"
  }

  assert {
    condition     = module.multi_scheduler.service_plan_id != ""
    error_message = "Service plan should be created"
  }

  assert {
    condition     = module.multi_scheduler.storage_account_id != ""
    error_message = "Storage account should be created"
  }

  assert {
    condition     = contains(keys(module.multi_scheduler.schedulers), "azure-resources-stop")
    error_message = "Should contain 'azure-resources-stop' scheduler"
  }

  assert {
    condition     = contains(keys(module.multi_scheduler.schedulers), "azure-resources-start")
    error_message = "Should contain 'azure-resources-start' scheduler"
  }

  assert {
    condition     = can(regex("stop-vms-at-night-", module.multi_scheduler.schedulers["azure-resources-stop"].function_app_name))
    error_message = "Stop scheduler function app name should contain 'stop-vms-at-night-'"
  }

  assert {
    condition     = can(regex("start-vms-at-morning-", module.multi_scheduler.schedulers["azure-resources-start"].function_app_name))
    error_message = "Start scheduler function app name should contain 'start-vms-at-morning-'"
  }
}
