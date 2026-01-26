resource "random_pet" "suffix" {}

resource "random_id" "suffix" {
  byte_length = 6
}

resource "azurerm_resource_group" "test" {
  name     = "test-${random_pet.suffix.id}"
  location = "swedencentral"
}

resource "azurerm_log_analytics_workspace" "test" {
  name                = "test-${random_pet.suffix.id}"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_eventhub_namespace" "test" {
  name                = "test-${random_pet.suffix.id}"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  sku                 = "Basic"
  capacity            = 1
}

resource "azurerm_eventhub" "test" {
  name                = "acceptanceTestEventHub"
  namespace_name      = azurerm_eventhub_namespace.test.name
  resource_group_name = azurerm_resource_group.test.name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_namespace_authorization_rule" "test" {
  name                = "azure-function"
  namespace_name      = azurerm_eventhub_namespace.test.name
  resource_group_name = azurerm_resource_group.test.name
  listen              = false
  send                = true
  manage              = false
}

resource "azurerm_storage_account" "test" {
  name                     = random_id.suffix.hex
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


module "multi_scheduler" {
  source = "../../"

  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location

  schedulers = {
    to-event-hub = {
      function_app_name             = "fpn-to-event-hub-${random_pet.suffix.id}"
      scheduler_action              = "stop"
      scheduler_ncrontab_expression = "0 0 7 * * *" # UTC+00:00
      virtual_machine_schedule      = "true"
      scale_set_schedule            = "true"
      postgresql_schedule           = "true"
      mysql_schedule                = "true"
      aks_schedule                  = "true"
      container_group_schedule      = "true"
      diagnostic_settings = {
        name                           = "test-eh-${random_pet.suffix.id}"
        eventhub_name                  = azurerm_eventhub.test.name
        eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.test.id
      }
      scheduler_tag = {
        "tostop" : "true",
      }
    }
    to-log-analytics = {
      function_app_name             = "fpn-to-log-analytics-${random_pet.suffix.id}"
      scheduler_action              = "start"
      scheduler_ncrontab_expression = "0 0 7 * * *" # UTC+00:00
      virtual_machine_schedule      = "true"
      scale_set_schedule            = "true"
      postgresql_schedule           = "true"
      mysql_schedule                = "true"
      aks_schedule                  = "true"
      container_group_schedule      = "true"
      diagnostic_settings = {
        name             = "test-la-${random_pet.suffix.id}"
        log_analytics_id = azurerm_log_analytics_workspace.test.id
      }
      scheduler_tag = {
        "tostop" : "true",
      }
    }
    to-storage-account = {
      function_app_name             = "fpn-to-storage-account-${random_pet.suffix.id}"
      scheduler_action              = "start"
      scheduler_ncrontab_expression = "0 0 7 * * *" # UTC+00:00
      virtual_machine_schedule      = "true"
      scale_set_schedule            = "true"
      postgresql_schedule           = "true"
      mysql_schedule                = "true"
      aks_schedule                  = "true"
      container_group_schedule      = "true"
      diagnostic_settings = {
        name               = "test-sa-${random_pet.suffix.id}"
        storage_account_id = azurerm_storage_account.test.id
      }
      scheduler_tag = {
        "tostop" : "true",
      }
    }
  }
}
