variable "module_supervision" {
    type = object({
        enabled = bool
        namespace = string
        istio_enabled = bool
        grafana = object({
            enabled = bool
            replica_count = number
            admin_username = string
            ingress_enabled = bool
            ingress_hosts = list(string)
            persistence_storage_class = string
            persistence_size = string
            plugins = list(string)
        })
        prometheus = object({
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
    })
    sensitive = false
    description = "Supervision module configuration."
    default = {
        enabled = true
        namespace = "supervision"
        istio_enabled = true
        grafana = {
            enabled = true
            replica_count = 2
            admin_username = "admin"
            ingress_enabled = true
            ingress_hosts = ["grafana.k8s.local"]
            persistence_storage_class = "standard"
            persistence_size = "1Gi"
            plugins = []
        }
        prometheus = {
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
    }
}

variable "module_supervision_grafana_admin_password" {
    type = string
    description = "Grafana administrator password."
    sensitive = true
}