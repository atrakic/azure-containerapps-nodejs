output "self" {
  description = "TF state environment"
  value = {
    workspace   = terraform.workspace
    last_update = timestamp()
  }
}

output "log_analytics_name" {
  value = module.log_analytics_workspace.name
}

output "container_app_fqdn" {
  value = module.container_apps.container_app_fqdn
}

output "container_app_ips" {
  value = module.container_apps.container_app_ips
}

output "container_app_environment_name" {
  value = module.container_apps.container_app_environment_name
}
