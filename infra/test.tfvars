location        = "swedencentral"
resource_prefix = "tf"

container_apps = {
  nodeapp = {
    name          = "nodeapp"
    revision_mode = "Single"
    ingress = {
      allow_insecure_connections = true
      external_enabled           = true
      target_port                = 3000
      transport                  = "http"
      traffic_weight = {
        label           = "blue"
        latest_revision = true
        revision_suffix = "blue"
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
        image  = "ghcr.io/atrakic/nodeapp:latest"
        cpu    = 0.25
        memory = "0.5Gi"
        env = [{
          name  = "PORT"
          value = 3000
        }]
      }]
      min_replicas = 1
      max_replicas = 1
    }
  },
}
