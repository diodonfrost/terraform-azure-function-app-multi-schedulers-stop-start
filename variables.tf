variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "service_plan_name" {
  description = "Name of the service plan. If null, a name will be generated"
  type        = string
  default     = null
}

variable "service_plan_sku_name" {
  description = "SKU name for the service plan"
  type        = string
  default     = "Y1"
}

variable "storage_account_name" {
  description = "Name of the storage account. If null, a name will be generated"
  type        = string
  default     = null
}

variable "schedulers" {
  description = "Map of scheduler configurations"
  type = map(object({
    function_app_name             = string
    custom_app_settings           = optional(map(string), {})
    scheduler_action              = string
    scheduler_ncrontab_expression = string
    scheduler_tag                 = map(string)
    virtual_machine_schedule      = optional(bool, false)
    postgresql_schedule           = optional(bool, false)
    mysql_schedule                = optional(bool, false)
    aks_schedule                  = optional(bool, false)
    container_group_schedule      = optional(bool, false)
    scale_set_schedule            = optional(bool, false)
    diagnostic_settings = optional(object({
      name                           = string
      storage_account_id             = optional(string, null)
      log_analytics_id               = optional(string, null)
      log_analytics_destination_type = optional(string, null)
      eventhub_name                  = optional(string, null)
      eventhub_authorization_rule_id = optional(string, null)
      log_categories                 = optional(list(string), ["FunctionAppLogs"])
      enable_metrics                 = optional(bool, false)
    }), null)
    application_insights = optional(object({
      enabled                    = optional(bool, false)
      log_analytics_workspace_id = optional(string, null)
    }), {})
  }))
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
