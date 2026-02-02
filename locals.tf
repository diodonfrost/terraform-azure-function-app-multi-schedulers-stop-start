locals {
  # Generate a storage account name if not provided
  # Format: "funcsa" + random 8-character hex suffix = max 14 characters
  # This ensures we stay within Azure's 3-24 character limit and use only lowercase letters and numbers
  generated_storage_name = var.storage_account_name == null ? "funcsa${random_id.storage_suffix[0].hex}" : var.storage_account_name

  # Generate a service plan name if not provided and not using external service plan
  # Format: "asp-" + function app name + "-" + random 8-character hex suffix
  # This ensures a meaningful and unique name for the service plan
  generated_service_plan_name = var.service_plan_name == null ? "asp-scheduler-${random_id.service_plan_suffix[0].hex}" : var.service_plan_name

  # Subscription configuration - use provided list or current subscription
  effective_subscription_ids = length(var.subscription_ids) > 0 ? var.subscription_ids : [data.azurerm_subscription.current.subscription_id]

  # Cartesian product: each scheduler needs permissions on each subscription
  scheduler_subscription_pairs = {
    for pair in flatten([
      for scheduler_key, scheduler in var.schedulers : [
        for sub_id in local.effective_subscription_ids : {
          key             = "${scheduler_key}-${sub_id}"
          scheduler_key   = scheduler_key
          scheduler       = scheduler
          subscription_id = sub_id
        }
      ]
    ]) : pair.key => pair
  }
}
