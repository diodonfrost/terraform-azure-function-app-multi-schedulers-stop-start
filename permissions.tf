data "azurerm_subscription" "current" {}

resource "azurerm_role_definition" "this" {
  for_each = toset(local.effective_subscription_ids)

  name        = "scheduler-stop-start-${substr(each.value, 0, 8)}"
  scope       = "/subscriptions/${each.value}"
  description = "Custom role to stop and start Azure resources"

  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/write",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/powerOff/action",
      "Microsoft.Compute/virtualMachines/deallocate/action",
      "Microsoft.Compute/virtualMachineScaleSets/read",
      "Microsoft.Compute/virtualMachineScaleSets/setOrchestrationServiceState/action",
      "Microsoft.Compute/virtualMachineScaleSets/start/action",
      "Microsoft.Compute/virtualMachineScaleSets/powerOff/action",
      "Microsoft.Compute/virtualMachineScaleSets/deallocate/action",
      "Microsoft.DBforPostgreSQL/flexibleServers/read",
      "Microsoft.DBforPostgreSQL/flexibleServers/start/action",
      "Microsoft.DBforPostgreSQL/flexibleServers/stop/action",
      "Microsoft.DBforMySQL/flexibleServers/read",
      "Microsoft.DBforMySQL/flexibleServers/start/action",
      "Microsoft.DBforMySQL/flexibleServers/stop/action",
      "Microsoft.ContainerService/managedClusters/read",
      "Microsoft.ContainerService/managedClusters/start/action",
      "Microsoft.ContainerService/managedClusters/stop/action",
      "Microsoft.ContainerInstance/containerGroups/read",
      "Microsoft.ContainerInstance/containerGroups/start/action",
      "Microsoft.ContainerInstance/containerGroups/stop/action",
      "Microsoft.Insights/*/read",
      "Microsoft.Insights/*/write",
      "Microsoft.Insights/*/action",
      "Microsoft.OperationalInsights/*/read",
      "Microsoft.OperationalInsights/*/write",
      "Microsoft.OperationalInsights/*/action",
      "Microsoft.AlertsManagement/alerts/*/read",
      "Microsoft.AlertsManagement/alerts/*/action"
    ]
    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/${each.value}"
  ]
}

resource "azurerm_role_assignment" "this" {
  for_each = local.scheduler_subscription_pairs

  scope              = "/subscriptions/${each.value.subscription_id}"
  role_definition_id = azurerm_role_definition.this[each.value.subscription_id].role_definition_resource_id
  principal_id       = module.scheduler[each.value.scheduler_key].function_app_principal_id
}
