variable "k8s_config_context" {
    type = string
}

variable "dashboard_ingress_hostname" {
    type = string
    description = "The dashboard ingress hostname"
    default = "dashboard.k8s.local"
}

variable "supervision" {
    type = object({
        enabled = bool
        namespace = string
        alert_manager_enabled = bool
        alert_manager_external_url = string
        alert_manager_ingress_enabled = bool
        alert_manager_persistence_storage_class = string
        alert_manager_persistence_size = string
        alert_manager_replica_count = number
        kube_state_metrics_enabled = bool
        node_exporter_enabled = bool
        prometheus_enabled = bool
        prometheus_scrape_interval = string
        prometheus_scrape_timeout = string
        prometheus_evaluation_interval = string
        prometheus_persistence_storage_class = string
        prometheus_persistence_size = string
        prometheus_replica_count = number
        push_gateway_enabled = bool
        push_gateway_replica_count = number
        grafana_replication_count = number
        grafana_ingress_enabled = bool
        granafa_ingress_hosts = list(string)
        granafa_persistence_storage_class = string
        granafa_persistence_size = string
        granafa_plugins = list(string)
    })
    description = "Supervision service configuration"
    default = {
        enabled = true
        namespace = "supervision"
        alert_manager_enabled = true
        alert_manager_external_url = "alertmanager.k8s.local"
        alert_manager_ingress_enabled = true
        alert_manager_persistence_size = "2Gi"
        alert_manager_persistence_storage_class = "standard"
        alert_manager_replica_count = 2
        kube_state_metrics_enabled = true
        node_exporter_enabled = true
        prometheus_enabled = true
        prometheus_persistence_size = "8Gi"
        prometheus_persistence_storage_class = "standard"
        prometheus_replica_count = 2
        prometheus_scrape_interval = "1m"
        prometheus_scrape_timeout = "10s"
        prometheus_evaluation_interval = "1m"
        push_gateway_enabled = false
        push_gateway_replica_count = 2
        grafana_replication_count = 2
        grafana_ingress_enabled = true
        granafa_ingress_hosts = [ "grafana.k8s.local" ]
        granafa_persistence_storage_class = "standard"
        granafa_persistence_size = "10Gi"
        granafa_plugins = []
    }
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
        postgres_prometheus_enabled = bool
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
        postgres_prometheus_enabled = true
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
        postgres_prometheus_enabled = bool
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
        postgres_prometheus_enabled = true
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
        postgres_prometheus_enabled = bool
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
        postgres_prometheus_enabled = true
    }
}
