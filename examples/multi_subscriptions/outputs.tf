output "schedulers" {
  description = "Information about the created scheduler function apps"
  value       = module.multi_scheduler.schedulers
  sensitive   = true
}

output "service_plan_name" {
  description = "The name of the shared service plan"
  value       = module.multi_scheduler.service_plan_name
}

output "storage_account_name" {
  description = "The name of the shared storage account"
  value       = module.multi_scheduler.storage_account_name
}
