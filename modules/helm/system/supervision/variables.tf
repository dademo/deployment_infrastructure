variable "namespace" {
  type = string
  default = "supervision"
  description = "The Kubernetes namespace where to deploy"
  sensitive = false
  validation {
    condition = length(var.namespace) > 0
    error_message = "The namespace value must not be null or empty."
  }
}

variable "istio_enabled" {
  type = bool
  default = false
  description = "Define if Istio is enabled."
  sensitive = false
}

variable "grafana" {
  type = object({
    enabled = bool
    replica_count = number
    admin_username = string
    ingress_enabled = bool
    ingress_hosts = list(string)
    persistence_storage_class = string
    persistence_size = string
    plugins = list(string)
  })
  default = {
    enabled = true
    replica_count = 2
    admin_username = "admin"
    ingress_enabled = true
    ingress_hosts = [
      "grafana.k8s.local"
    ]
    persistence_storage_class = "standard"
    persistence_size = "1Gi"
    plugins = []
  }
  description = "The Grafana service configuration."
  sensitive = false
  validation {
    condition = alltrue([
      var.grafana.replica_count > 0,
      var.grafana.replica_count % 1 == 0,
      (!var.grafana.ingress_enabled) || length(var.grafana.ingress_hosts) > 0,
      length(var.grafana.persistence_storage_class) > 0,
      can(regex("^[0-9]+[GM]i$", var.grafana.persistence_size)),
    ])
    error_message = "Invalid Grafana service configuration."
  }
}

variable "grafana_admin_password" {
  type = string
  description = "Grafana administrator password."
  sensitive = true
  validation {
    condition = length(var.grafana_admin_password) > 0
    error_message = "Grafana admin password must be defined and non-empty."
  }
}

variable "prometheus" {
  type = object({
    enabled = bool
    prometheus = object({
      replica_count = number
      scrape_interval = string
      scrape_timeout = string
      evaluation_interval = string
      persistence_storage_class = string
      persistence_size = string
    })
    kube_state_metrics_enabled = bool
    node_exporter_enabled = bool
    alert_manager = object({
      enabled = bool
      replica_count = number
      persistence_storage_class = string
      persistence_size = string
    })
    push_gateway = object({
      enabled = bool
      replica_count = number
      persistence_storage_class = string
      persistence_size = string
    })
  })
  description = "The supervision service configuration."
  sensitive = false
  default = {
    enabled = true
    prometheus = {
      replica_count = 1
      scrape_interval = "1m"
      scrape_timeout = "10s"
      evaluation_interval = "1m"
      persistence_size = "8Gi"
      persistence_storage_class = "standard"
    }
    kube_state_metrics_enabled = true
    node_exporter_enabled = true
    alert_manager = {
      enabled = false
      replica_count = 1
      persistence_size = "2Gi"
      persistence_storage_class = "standard"
    }
    push_gateway = {
      enabled = false
      replica_count = 1
      persistence_size = "2Gi"
      persistence_storage_class = "standard"
    }
  }
  validation {
    condition = alltrue([
      // Prometheus
      alltrue([
        can(regex("^[0-9]+[ms]$", var.prometheus.prometheus.scrape_interval)),
        can(regex("^[0-9]+[ms]$", var.prometheus.prometheus.scrape_timeout)),
        can(regex("^[0-9]+[ms]$", var.prometheus.prometheus.evaluation_interval)),
        length(var.prometheus.prometheus.persistence_storage_class) > 0,
        can(regex("^[0-9]+[GM]i$", var.prometheus.prometheus.persistence_size)),
        var.prometheus.prometheus.replica_count > 0,
        var.prometheus.prometheus.replica_count % 1 == 0,
      ]),
      // Alert manager
      (!var.prometheus.alert_manager.enabled) || alltrue([
        length(var.prometheus.alert_manager.persistence_storage_class) > 0,
        can(regex("^[0-9]+[GM]i$", var.prometheus.alert_manager.persistence_size)),
        var.prometheus.alert_manager.replica_count > 0,
        var.prometheus.alert_manager.replica_count % 1 == 0,
      ]),
      // Push gateway
      (!var.prometheus.alert_manager.enabled) || alltrue([
        length(var.prometheus.push_gateway.persistence_storage_class) > 0,
        can(regex("^[0-9]+[GM]i$", var.prometheus.push_gateway.persistence_size)),
        var.prometheus.push_gateway.replica_count > 0,
        var.prometheus.push_gateway.replica_count % 1 == 0,
      ]),
    ])
    error_message = "Invalid Prometheus service configuration."
  }
}
