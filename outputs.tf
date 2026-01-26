output "resource_group_name" {
  description = "The name of the created resource group"
  value       = azurerm_service_plan.this.resource_group_name
}

output "service_plan_id" {
  description = "The ID of the created service plan"
  value       = azurerm_service_plan.this.id
}

output "service_plan_name" {
  description = "The name of the created service plan"
  value       = azurerm_service_plan.this.name
}

output "storage_account_id" {
  description = "The ID of the created storage account"
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "The name of the created storage account"
  value       = azurerm_storage_account.this.name
}

output "storage_account_primary_access_key" {
  description = "The primary access key for the storage account"
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "storage_account_primary_connection_string" {
  description = "The primary connection string for the storage account"
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}

output "schedulers" {
  description = "Information about the created scheduler function apps"
  sensitive   = true
  value = {
    for k, v in module.scheduler : k => {
      function_app_id           = v.function_app_id
      function_app_name         = v.function_app_name
      function_app_master_key   = v.function_app_master_key
      default_hostname          = v.default_hostname
      app_settings              = v.app_settings
      diagnostic_settings_name  = v.diagnostic_settings_name
      application_insights_name = v.application_insights_name
      application_insights_id   = v.application_insights_id
    }
  }
}
