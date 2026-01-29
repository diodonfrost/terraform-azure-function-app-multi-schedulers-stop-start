# terraform-azure-function-app-multi-scheduler-stop-start

Terraform module that creates multiple Azure Function schedulers at once for stopping and starting Azure resources.

This module is a wrapper around the [terraform-azure-function-app-scheduler-stop-start](https://github.com/diodonfrost/terraform-azure-function-app-scheduler-stop-start) module, allowing you to deploy multiple schedulers at once.

## Usage

```hcl
module "multi_scheduler" {
  source = "diodonfrost/function-app-multi-scheduler-stop-start/azure"
  version = "x.x.x"

  resource_group_name = "my-rg-name
  location            = "westeurope"

  schedulers = {
    azure-resources-stop = {
      function_app_name             = "stop-vms-at-night-my-project"
      scheduler_action              = "stop"
      scheduler_ncrontab_expression = "0 22 ? * MON-FRI *" # UTC+00:00
      virtual_machine_schedule      = "true"
      scale_set_schedule            = "true"
      postgresql_schedule           = "true"
      mysql_schedule                = "true"
      aks_schedule                  = "true"
      container_group_schedule      = "true"
      scheduler_tag = {
        "tostop" : "true",
      }
    }
    azure-resources-start = {
      function_app_name             = "start-vms-at-morning-my-project"
      scheduler_action              = "start"
      scheduler_ncrontab_expression = "0 6 ? * MON-FRI *" # UTC+00:00
      virtual_machine_schedule      = "true"
      scale_set_schedule            = "true"
      postgresql_schedule           = "true"
      mysql_schedule                = "true"
      aks_schedule                  = "true"
      container_group_schedule      = "true"
      scheduler_tag = {
        "tostop" : "true",
      }
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0, < 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.58.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.8.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_scheduler"></a> [scheduler](#module\_scheduler) | diodonfrost/function-app-scheduler-stop-start/azure | v3.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [random_id.service_plan_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.storage_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_insights"></a> [application\_insights](#input\_application\_insights) | Application Insights configuration for all schedulers | <pre>object({<br/>    connection_string   = string<br/>    instrumentation_key = string<br/>  })</pre> | `null` | no |
| <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings) | Diagnostic settings configuration for all schedulers | <pre>object({<br/>    name                           = string<br/>    storage_account_id             = optional(string, null)<br/>    log_analytics_id               = optional(string, null)<br/>    log_analytics_destination_type = optional(string, null)<br/>    eventhub_name                  = optional(string, null)<br/>    eventhub_authorization_rule_id = optional(string, null)<br/>    log_categories                 = optional(list(string), ["FunctionAppLogs"])<br/>    enable_metrics                 = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where resources will be created | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_schedulers"></a> [schedulers](#input\_schedulers) | Map of scheduler configurations | <pre>map(object({<br/>    function_app_name             = string<br/>    custom_app_settings           = optional(map(string), {})<br/>    scheduler_action              = string<br/>    scheduler_ncrontab_expression = string<br/>    scheduler_tag                 = map(string)<br/>    virtual_machine_schedule      = optional(bool, false)<br/>    postgresql_schedule           = optional(bool, false)<br/>    mysql_schedule                = optional(bool, false)<br/>    aks_schedule                  = optional(bool, false)<br/>    container_group_schedule      = optional(bool, false)<br/>    scale_set_schedule            = optional(bool, false)<br/>  }))</pre> | n/a | yes |
| <a name="input_service_plan_name"></a> [service\_plan\_name](#input\_service\_plan\_name) | Name of the service plan. If null, a name will be generated | `string` | `null` | no |
| <a name="input_service_plan_sku_name"></a> [service\_plan\_sku\_name](#input\_service\_plan\_sku\_name) | SKU name for the service plan | `string` | `"Y1"` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Name of the storage account. If null, a name will be generated | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the created resource group |
| <a name="output_schedulers"></a> [schedulers](#output\_schedulers) | Information about the created scheduler function apps |
| <a name="output_service_plan_id"></a> [service\_plan\_id](#output\_service\_plan\_id) | The ID of the created service plan |
| <a name="output_service_plan_name"></a> [service\_plan\_name](#output\_service\_plan\_name) | The name of the created service plan |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The ID of the created storage account |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | The name of the created storage account |
| <a name="output_storage_account_primary_access_key"></a> [storage\_account\_primary\_access\_key](#output\_storage\_account\_primary\_access\_key) | The primary access key for the storage account |
| <a name="output_storage_account_primary_connection_string"></a> [storage\_account\_primary\_connection\_string](#output\_storage\_account\_primary\_connection\_string) | The primary connection string for the storage account |
<!-- END_TF_DOCS -->

## Tests

Some of these tests create real resources in an Azure subscription. That means they cost money to run, especially if you don't clean up after yourself. Please be considerate of the resources you create and take extra care to clean everything up when you're done!

In order to run tests that access your Azure subscription, run 'azure login'

### End-to-end tests

#### Terraform test

```shell
# Test basic terraform deployment
cd examples/simple
terraform test -verbose
```

## Authors

Modules managed by diodonfrost.

## Licence

Apache Software License 2.0.
