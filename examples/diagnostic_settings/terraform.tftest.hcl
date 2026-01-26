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
    condition     = contains(keys(module.multi_scheduler.schedulers), "to-event-hub")
    error_message = "Should contain 'to-event-hub' scheduler"
  }

  assert {
    condition     = contains(keys(module.multi_scheduler.schedulers), "to-log-analytics")
    error_message = "Should contain 'to-log-analytics' scheduler"
  }

  assert {
    condition     = contains(keys(module.multi_scheduler.schedulers), "to-storage-account")
    error_message = "Should contain 'to-storage-account' scheduler"
  }

  assert {
    condition     = module.multi_scheduler.schedulers["to-event-hub"].diagnostic_settings_name == "test-eh-${random_pet.suffix.id}"
    error_message = "Event hub scheduler diagnostic settings name is invalid"
  }

  assert {
    condition     = module.multi_scheduler.schedulers["to-log-analytics"].diagnostic_settings_name == "test-la-${random_pet.suffix.id}"
    error_message = "Log analytics scheduler diagnostic settings name is invalid"
  }

  assert {
    condition     = module.multi_scheduler.schedulers["to-storage-account"].diagnostic_settings_name == "test-sa-${random_pet.suffix.id}"
    error_message = "Storage account scheduler diagnostic settings name is invalid"
  }
}
