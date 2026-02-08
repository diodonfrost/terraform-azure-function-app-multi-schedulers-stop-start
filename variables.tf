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

variable "subscription_ids" {
  description = "List of subscription IDs where the function apps will operate"
  type        = list(string)
  default     = []
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
    dry_run                       = optional(bool, false)
  }))
}

variable "application_insights" {
  description = "Application Insights configuration for all schedulers"
  type = object({
    connection_string   = string
    instrumentation_key = string
  })
  default = null
}

variable "diagnostic_settings" {
  description = "Diagnostic settings configuration for all schedulers"
  type = object({
    name                           = string
    storage_account_id             = optional(string, null)
    log_analytics_id               = optional(string, null)
    log_analytics_destination_type = optional(string, null)
    eventhub_name                  = optional(string, null)
    eventhub_authorization_rule_id = optional(string, null)
    log_categories                 = optional(list(string), ["FunctionAppLogs"])
    enable_metrics                 = optional(bool, false)
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
