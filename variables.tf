variable "k8s_config_context" {
    type = string
}

variable "dashboard_ingress_hostname" {
    type = string
    description = "The dashboard ingress hostname"
    default = "dashboard.k8s.local"
}

variable "gitea" {
    type = object({
        enabled = bool
        namespace = string
        replica_count = number
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
        prometheus_enabled = bool
    })
    description = "Gitea service configuration"
    default = {
        enabled = true
        namespace = "gitea"
        replica_count = 2
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        postgresql_persistence_size = "2Gi"
        postgresql_persistence_storage_class = "standard"
        postgresql_database = "gitea"
        postgresql_user = "gitea"
        postgresql_password = "gitea"
        ingress_enabled = true
        ingress_hosts = ["gitea.k8s.local"]
        admin_mail = "admin@gitea.k8s.local"
        prometheus_enabled = true
    }
}

variable "jenkins" {
    type = object({
        enabled = bool
        namespace = string
        persistence_storage_class = string
        persistence_size = string
        ingress_enabled = bool
        ingress_host = string
        prometheus_enabled = bool
        additional_plugins = list(string)
    })
    description = "Jenkins service configuration"
    default = {
        enabled = true
        namespace = "jenkins"
        persistence_storage_class = "standard"
        persistence_size = "20Gi"
        ingress_enabled = true
        ingress_host = "jenkins.k8s.local"
        prometheus_enabled = true
        additional_plugins = []
    }
}


variable "nexus" {
    type = object({
        enabled = bool
        namespace = string
        persistence_storage_class = string
        persistence_size = string
        ingress_enabled = bool
        ingress_host = string
    })
    description = "Nexus service configuration"
    default = {
        enabled = true
        namespace = "nexus"
        persistence_storage_class = "standard"
        persistence_size = "20Gi"
        ingress_enabled = true
        ingress_host = "nexus.k8s.local"
    }
}

variable "sonarqube" {
    type = object({
        enabled = bool
        namespace = string
        replicaCount = number
        persistence_storage_class = string
        persistence_size = string
        ingress_enabled = bool
        ingress_hosts = list(string)
        postgresql_persistence_size = string
        postgresql_persistence_storage_class = string
        postgresql_database = string
        postgresql_user = string
        postgresql_password = string
        prometheus_enabled = bool
    })
    description = "Sonarqube service configuration"
    default = {
        enabled = true
        namespace = "sonarqube"
        replicaCount = 2
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        postgresql_persistence_size = "2Gi"
        postgresql_persistence_storage_class = "standard"
        postgresql_database = "sonarqube"
        postgresql_user = "sonarqube"
        postgresql_password = "sonarqube"
        ingress_enabled = true
        ingress_hosts = ["sonar.k8s.local"]
        prometheus_enabled = true
    }
}

variable "keycloak" {
    type = object({
        enabled = bool
        namespace = string
        replica_count = number
        ingress_enabled = bool
        ingress_host = string
        postgresql_persistence_size = string
        postgresql_persistence_storage_class = string
        postgresql_database = string
        postgresql_user = string
        postgresql_password = string
        prometheus_enabled = bool
    })
    description = "Keycloak service configuration"
    default = {
        enabled = true
        namespace = "keycloak"
        replica_count = 2
        postgresql_persistence_size = "2Gi"
        postgresql_persistence_storage_class = "standard"
        postgresql_database = "keycloak"
        postgresql_user = "keycloak"
        postgresql_password = "keycloak"
        ingress_enabled = true
        ingress_host = "keycloak.k8s.local"
        prometheus_enabled = true
    }
}
