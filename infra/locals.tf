locals {
  tags = merge(var.tags, {
    object_id = data.azurerm_client_config.current.object_id
  })

  container_apps = {
    podinfo = {
      name          = "podinfo"
      revision_mode = "Single"

      ingress = {
        allow_insecure_connections = true
        external_enabled           = true
        target_port                = 9898
        traffic_weight = {
          latest_revision = true
          percentage      = 100
        }
      }

      template = {
        containers = [{
          name   = "podinfo"
          image  = "stefanprodan/podinfo:latest"
          cpu    = 0.25
          memory = "0.5Gi"
          env = [{
            name  = "FOO"
            value = "BAR"
          }]
        }]
        min_replicas = 1
        max_replicas = 1
      }
    },
  }
}
