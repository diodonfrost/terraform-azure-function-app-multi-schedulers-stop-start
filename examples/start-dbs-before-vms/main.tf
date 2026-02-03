resource "random_pet" "suffix" {}

resource "azurerm_resource_group" "test" {
  name     = "test-${random_pet.suffix.id}"
  location = "swedencentral"
}

module "multi_scheduler" {
  source = "../../"

  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location

  schedulers = {
    azure-vms-stop = {
      function_app_name             = "stop-vms-at-night-${random_pet.suffix.id}"
      scheduler_action              = "stop"
      scheduler_ncrontab_expression = "0 0 22 * * 1-5" # UTC+00:00
      virtual_machine_schedule      = "true"
      scale_set_schedule            = "true"
      scheduler_tag = {
        "tostop" : "true",
      }
    }
    azure-vms-start = {
      function_app_name             = "start-vms-at-morning-${random_pet.suffix.id}"
      scheduler_action              = "start"
      scheduler_ncrontab_expression = "0 0 6 * * 1-5" # UTC+00:00
      virtual_machine_schedule      = "true"
      scale_set_schedule            = "true"
      scheduler_tag = {
        "tostop" : "true",
      }
    }
    azure-dbs-stop = {
      function_app_name             = "stop-dbs-at-night-${random_pet.suffix.id}"
      scheduler_action              = "stop"
      scheduler_ncrontab_expression = "0 0 22 * * 1-5" # UTC+00:00
      postgresql_schedule           = "true"
      mysql_schedule                = "true"
      scheduler_tag = {
        "tostop" : "true",
      }
    }
    azure-dbs-start = {
      function_app_name             = "start-dbs-at-morning-${random_pet.suffix.id}"
      scheduler_action              = "start"
      scheduler_ncrontab_expression = "0 30 5 * * 1-5" # UTC+00:00
      postgresql_schedule           = "true"
      mysql_schedule                = "true"
      scheduler_tag = {
        "tostop" : "true",
      }
    }
  }
}
