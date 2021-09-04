variable "module_gitea" {
  type = object({
    enabled = bool
    namespace = string
    service = object({
      replica_count = number
      persistence_size = string
      persistence_storage_class = string
      ingress_enabled = bool
      ingress_hosts = list(string)
      admin_mail = string
      disable_registration = bool
      openid_registration_only = bool
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
  description = "Gitea module configuration."
  default = {
    enabled = true
    namespace = "gitea"
    service = {
      replica_count = 1
      persistence_size = "2Gi"
      persistence_storage_class = "standard"
      ingress_enabled = true
      ingress_hosts = [
        "gitea.k8s.local"
      ]
      admin_mail = "admin@gitea.k8s.local"
      disable_registration = false
      openid_registration_only = false
    }
    deploy_postgresql = true
    database_host = ""
    database = {
      database = "gitea"
      username = "gitea"
      persistence_size = "2Gi"
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

variable "module_gitea_database_password" {
  type = string
  description = "The Gitea database password to use."
  sensitive = true
}