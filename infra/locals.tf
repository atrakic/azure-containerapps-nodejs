locals {
  tags = merge(var.tags, {
    object_id = data.azurerm_client_config.current.object_id
  })

  container_apps = try(coalesce(var.container_apps, local.default_container_apps))
  default_container_apps = {
    podinfo = {
      name          = "nodeapp"
      revision_mode = "Single"

      ingress = {
        allow_insecure_connections = true
        external_enabled           = true
        target_port                = 3000
        traffic_weight = {
          latest_revision = true
          percentage      = 100
        }
      }

      dapr = {
        app_id       = "nodeapp"
        app_port     = 3000
        app_protocol = "http"
      }

      template = {
        containers = [{
          name   = "nodeapp"
          image  = "ghcr.io/atrakic/nodeapp:latest
          cpu    = 0.25
          memory = "0.5Gi"
          env = [{
            name  = "DAPR"
            value = "TRUE"
          }]
        }]
        min_replicas = 1
        max_replicas = 1
      }
    },
  }
}
