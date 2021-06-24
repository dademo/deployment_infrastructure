variable "k8s_config_context" {
    type = string
}

variable "gitea" {
    type = object({
        namespace = string
        persistence_size = string
        persistence_storage_class = string
        postgresql_persistence_size = string
        postgresql_persistence_storage_class = string
        postgresql_database = string
        postgresql_user = string
        postgresql_password = string
        ingress_enabled = bool
        ingress_hosts = list(string)
        admin_mail = string
        prometheus_enabled = string
    })
    default = {
        namespace = "gitea"
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        postgresql_persistence_size = "2Gi"
        postgresql_persistence_storage_class = "standard"
        postgresql_database = "gitea"
        postgresql_user = "gitea"
        postgresql_password = "gitea"
        ingress_enabled = "true"
        ingress_hosts = ["gitea.k8s.localdomain"]
        admin_mail = "admin@gitea.k8s.localdomain"
        prometheus_enabled = "true"
    }
}

variable "jenkins" {
    type = object({
        namespace = string
        persistence_storage_class = string
        persistence_size = string
        ingress_enabled = string
        ingress_host = string
        prometheus_enabled = string
    })
    default = {
        namespace = "jenkins"
        persistence_storage_class = "standard"
        persistence_size = "20Gi"
        ingress_enabled = "true"
        ingress_host = "jenkins.k8s.localdomain"
        prometheus_enabled = "true"
    }
}
