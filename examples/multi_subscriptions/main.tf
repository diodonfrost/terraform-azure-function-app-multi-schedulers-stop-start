resource "random_pet" "suffix" {}

resource "tls_private_key" "test" {
  algorithm = "RSA"
  rsa_bits  = 4096
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

resource "azurerm_application_insights" "test" {
  name                = "test-${random_pet.suffix.id}"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  workspace_id        = azurerm_log_analytics_workspace.test.id
  application_type    = "other"
}


module "multi_scheduler" {
  source = "../../"

  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  subscription_ids = [
    var.subscription_1_id,
    var.subscription_2_id,
  ]

  application_insights = {
    connection_string   = azurerm_application_insights.test.connection_string
    instrumentation_key = azurerm_application_insights.test.instrumentation_key
  }

  schedulers = {
    azure-resources-stop = {
      function_app_name             = "stop-vms-at-night-${random_pet.suffix.id}"
      scheduler_action              = "stop"
      scheduler_ncrontab_expression = "0 0 22 * * 1-5" # UTC+00:00
      virtual_machine_schedule      = true
      scale_set_schedule            = true
      postgresql_schedule           = true
      mysql_schedule                = true
      aks_schedule                  = true
      container_group_schedule      = true
      scheduler_tag = {
        "tostop" = "true"
      }
    }
    azure-resources-start = {
      function_app_name             = "start-vms-at-morning-${random_pet.suffix.id}"
      scheduler_action              = "start"
      scheduler_ncrontab_expression = "0 0 6 * * 1-5" # UTC+00:00
      virtual_machine_schedule      = true
      scale_set_schedule            = true
      postgresql_schedule           = true
      mysql_schedule                = true
      aks_schedule                  = true
      container_group_schedule      = true
      scheduler_tag = {
        "tostop" = "true"
      }
    }
  }
}
