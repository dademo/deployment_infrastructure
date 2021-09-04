variable "module_sonarqube" {
  type = object({
    enabled = bool
    namespace = string
    service = object({
      replica_count = number
      persistence_size = string
      persistence_storage_class = string
      ingress_enabled = bool
      ingress_hosts = list(string)
    })
    deploy_postgresql = bool
    database_host = string
    database = object({
      database = string
      username = string
      persistence_size = string
      persistence_storage_class = string
      service = object({
        type = string
        node_port = string
        cluster_ip = string
        load_balancer_ip = string
      })
    })
    prometheus_enabled = bool
  })
  sensitive = false
  description = "Sonarqube module configuration."
  default = {
    enabled = true
    namespace = "sonarqube"
    service = {
      replica_count = 1
      persistence_size = "20Gi"
      persistence_storage_class = "standard"
      ingress_enabled = true
      ingress_hosts = [
        "sonarqube.k8s.local"
      ]
    }
    deploy_postgresql = true
    database_host = ""
    database = {
      database = "sonarqube"
      username = "sonarqube"
      persistence_size = "5Gi"
      persistence_storage_class = "standard"
      service = {
        type = "ClusterIP"
        node_port = ""
        cluster_ip = ""
        load_balancer_ip = ""
      }
    }
    prometheus_enabled = true
  }
}

variable "module_sonarqube_database_password" {
  type = string
  description = "The Sonarqube database password to use."
  sensitive = true
}