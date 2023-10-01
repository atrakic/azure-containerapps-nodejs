variable "environment_name" {
  description = "(Required) Specifies the name of the managed environment."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Specifies the resource group name"
  type        = string
  nullable    = false
}

variable "tags" {
  description = "(Optional) Specifies the tags of the log analytics workspace"
  type        = map(any)
  default     = {}
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "infrastructure_subnet_id" {
  description = "(Optional) Specifies resource id of the subnet hosting the Azure Container Apps environment."
  type        = string
}

variable "internal_load_balancer_enabled" {
  description = "(Optional) Should the Container Environment operate in Internal Load Balancing Mode? Defaults to false. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "instrumentation_key" {
  description = "(Optional) Specifies the instrumentation key of the application insights resource."
  type        = string
}

variable "workspace_id" {
  description = "(Optional) Specifies resource id of the log analytics workspace."
  type        = string
}

variable "dapr_components" {
  description = "(Optional) Specifies the dapr components."
  type = list(object({
    name           = string
    component_type = string
    ignore_errors  = optional(bool)
    version        = optional(string)
    init_timeout   = optional(string)
    scopes         = optional(list(string))
    metadata = optional(list(object({
      name        = string
      secret_name = optional(string)
      value       = optional(string)
    })))
    secret = optional(list(object({
      name  = string
      value = string
    })))
  }))
}

variable "container_apps" {
  description = "Container apps to deploy."
  nullable    = false

  type = map(object({
    name          = string
    revision_mode = optional(string)
    tags          = optional(map(string))

    ingress = optional(object({
      allow_insecure_connections = optional(bool, false)
      external_enabled           = optional(bool, false)
      target_port                = optional(number)
      transport                  = optional(string)
      traffic_weight = object({
        label           = optional(string)
        latest_revision = optional(bool)
        revision_suffix = optional(string)
        percentage      = optional(number)
      })
    }))

    dapr = optional(object({
      app_id       = optional(string)
      app_port     = optional(number)
      app_protocol = optional(string)
    }))

    secrets = optional(list(object({
      name  = string
      value = string
    })))

    template = object({
      containers = list(object({
        name    = string
        image   = string
        args    = optional(list(string))
        command = optional(list(string))
        cpu     = optional(number)
        memory  = optional(string)
        env = optional(list(object({
          name        = string
          secret_name = optional(string)
          value       = optional(string)
        })))
        liveness_probe = optional(object({
          failure_count_threshold = optional(number)
          header = optional(object({
            name  = string
            value = string
          }))
          host             = optional(string)
          initial_delay    = optional(number, 1)
          interval_seconds = optional(number, 10)
          path             = optional(string)
          port             = number
          timeout          = optional(number, 1)
          transport        = string
        }))
        readiness_probe = optional(object({
          failure_count_threshold = optional(number)
          header = optional(object({
            name  = string
            value = string
          }))
          host                    = optional(string)
          interval_seconds        = optional(number, 10)
          path                    = optional(string)
          port                    = number
          success_count_threshold = optional(number, 3)
          timeout                 = optional(number)
          transport               = string
        }))
        startup_probe = optional(object({
          failure_count_threshold = optional(number)
          header = optional(object({
            name  = string
            value = string
          }))
          host             = optional(string)
          interval_seconds = optional(number, 10)
          path             = optional(string)
          port             = number
          timeout          = optional(number)
          transport        = string
        }))
        volume_mounts = optional(object({
          name = string
          path = string
        }))
      }))

      min_replicas    = optional(number)
      max_replicas    = optional(number)
      revision_suffix = optional(string)

      volume = optional(list(object({
        name         = string
        storage_name = optional(string)
        storage_type = optional(string)
      })))

      registry = optional(list(object({
        server               = string
        username             = optional(string)
        password_secret_name = optional(string)
        identity             = optional(string)
      })))

    })
  }))

  validation {
    condition     = length(var.container_apps) >= 1
    error_message = "At least one container should be provided."
  }

}
