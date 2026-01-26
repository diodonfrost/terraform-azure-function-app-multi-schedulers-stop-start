resource "random_id" "service_plan_suffix" {
  count       = var.service_plan_name == null ? 1 : 0
  byte_length = 4
}

resource "azurerm_service_plan" "this" {
  name                = local.generated_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.service_plan_sku_name

  tags = var.tags
}

module "scheduler" {
  for_each = var.schedulers
  source   = "diodonfrost/function-app-scheduler-stop-start/azure"
  version  = "v2.0.0"

  resource_group_name           = var.resource_group_name
  location                      = var.location
  function_app_name             = each.value.function_app_name
  custom_app_settings           = each.value.custom_app_settings
  scheduler_action              = each.value.scheduler_action
  scheduler_ncrontab_expression = each.value.scheduler_ncrontab_expression
  scheduler_tag                 = each.value.scheduler_tag
  virtual_machine_schedule      = each.value.virtual_machine_schedule
  postgresql_schedule           = each.value.postgresql_schedule
  mysql_schedule                = each.value.mysql_schedule
  aks_schedule                  = each.value.aks_schedule
  container_group_schedule      = each.value.container_group_schedule
  scale_set_schedule            = each.value.scale_set_schedule

  existing_service_plan = {
    name                = azurerm_service_plan.this.name
    resource_group_name = var.resource_group_name
  }
  existing_storage_account = {
    name                = azurerm_storage_account.this.name
    resource_group_name = var.resource_group_name
  }

  diagnostic_settings = each.value.diagnostic_settings != null ? {
    name                           = each.value.diagnostic_settings["name"]
    storage_account_id             = each.value.diagnostic_settings["storage_account_id"]
    log_analytics_id               = each.value.diagnostic_settings["log_analytics_id"]
    log_analytics_destination_type = each.value.diagnostic_settings["log_analytics_destination_type"]
    eventhub_name                  = each.value.diagnostic_settings["eventhub_name"]
    eventhub_authorization_rule_id = each.value.diagnostic_settings["eventhub_authorization_rule_id"]
    log_categories                 = each.value.diagnostic_settings["log_categories"]
    enable_metrics                 = each.value.diagnostic_settings["enable_metrics"]
  } : null

  tags = var.tags
}
