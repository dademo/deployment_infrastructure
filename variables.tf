variable "k8s_config_context" {
    type = string
}

variable "k8s_dashboard" {
    type = object({
        enabled = bool
        namespace = string
        service_name = string
        service_port_http = number
        ingress_host = string
    })
    description = "Kubernetes dashboard configuration"
    default = {
        enabled = false
        namespace = "kube-system"
        service_name = "kubernetes-dashboard"
        service_port_http = 80
        ingress_host = "dashboard.k8s.local"
    }
}

variable "k8s_kibana_logging" {
    type = object({
        enabled = bool
        namespace = string
        service_name = string
        service_port_http = number
        ingress_host = string
    })
    description = "Kubernetes Kibana logging configuration"
    default = {
        enabled = false
        namespace = "kube-system"
        service_name = "kibana-logging"
        service_port_http = 5601
        ingress_host = "kibana.k8s.local"
    }
}

variable "k8s_registry" {
    type = object({
        enabled = bool
        namespace = string
        service_name = string
        service_port_http = number
        service_port_https = number
        ingress_host = string
    })
    description = "Kubernetes registry configuration"
    default = {
        enabled = false
        namespace = "kube-system"
        service_name = "registry"
        service_port_http = 80
        service_port_https = 443
        ingress_host = "registry.k8s.local"
    }
}

variable "k8s_shared" {
    type = object({
        redis_force_install = bool
        redis_replica_count = number
        redis_authentication_enabled = bool
        redis_password = string
        redis_persistence_storage_class = string
        redis_persistence_size = string
        redis_prometheus_enabled = bool
        redis_volume_permissions_enabled = bool
        redis_sysctl_enabled = bool
    })
    description = "Shared services configuration"
    default = {
        redis_force_install = false
        redis_replica_count = 2
        redis_authentication_enabled = false
        redis_password = "admin"
        redis_persistence_storage_class = "standard"
        redis_persistence_size = "8Gi"
        redis_prometheus_enabled = true
        redis_volume_permissions_enabled = false
        redis_sysctl_enabled = false
    }
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
        enabled = false
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
        postgresql_image_tag = string
        postgresql_prometheus_enabled = bool
        ingress_enabled = bool
        ingress_hosts = list(string)
        admin_mail = string
        prometheus_enabled = bool
    })
    description = "Gitea service configuration"
    default = {
        enabled = false
        namespace = "gitea"
        replica_count = 2
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        postgresql_persistence_size = "8Gi"
        postgresql_persistence_storage_class = "standard"
        postgresql_database = "gitea"
        postgresql_user = "gitea"
        postgresql_password = "gitea"
        postgresql_image_tag = "13.3.0"
        postgresql_prometheus_enabled = true
        ingress_enabled = true
        ingress_hosts = ["gitea.k8s.local"]
        admin_mail = "admin@gitea.k8s.local"
        prometheus_enabled = true
    }
}

variable "gitlab" {
    type = object({
        enabled = bool
        namespace = string
        postgresql_database = string
        postgresql_user = string
        postgresql_password = string
        postgresql_persistence_size = string
        postgresql_persistence_storage_class = string
        postgresql_image_tag = string
        postgresql_prometheus_enabled = bool
        minio_persistence_size = string
        minio_persistence_storage_class = string
        minio_replicas = number
        gitlab_saml_auth_enabled = bool
        gitlab_saml_assertion_consumer_service_url = string
        gitlab_saml_idp_cert_fingerprint = string
        gitlab_saml_idp_sso_target_url = string
        gitlab_saml_issuer = string
        gitlab_domain = string
        gitaly_persistence_storage_class = string
        gitaly_persistence_size = string
    })
    description = "Gitlab service configuration"
    default = {
        enabled = false
        namespace = "gitlab"
        postgresql_database = "gitlab"
        postgresql_user = "gitlab"
        postgresql_password = "gitlab"
        postgresql_persistence_size = "8Gi"
        postgresql_persistence_storage_class = "standard"
        postgresql_image_tag = "13.3.0"
        postgresql_prometheus_enabled = true
        minio_persistence_size = "2Gi"
        minio_persistence_storage_class = "standard"
        minio_replicas = 4
        minio_tenant_prometheus_enabled = true
        gitaly_persistence_storage_class = "standard"
        gitaly_persistence_size = "50Gi"
        gitlab_saml_auth_enabled = false
        gitlab_domain = "k8s.local"
        // https://docs.gitlab.com/charts/charts/globals.html#providers
        gitlab_saml_assertion_consumer_service_url = "https://gitlab.example.com/users/auth/saml/callback"
        gitlab_saml_idp_cert_fingerprint = "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
        gitlab_saml_idp_sso_target_url = "https://SAML_IDP/app/xxxxxxxxx/xxxxxxxxx/sso/saml"
        gitlab_saml_issuer = "https://gitlab.example.com"
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
        additional_plugins = list(object({
            plugin = string
            version = string
        }))
    })
    description = "Jenkins service configuration"
    default = {
        enabled = false
        namespace = "jenkins"
        persistence_storage_class = "standard"
        persistence_size = "20Gi"
        ingress_enabled = true
        ingress_host = "jenkins.k8s.local"
        prometheus_enabled = true
        additional_plugins = [
            // System
            { plugin = "saml",                      version = "2.0.7" },
            { plugin = "credentials",               version = "2.5" },
            { plugin = "mailer",                    version = "1.34" },
            // Interface
            { plugin = "cloudbees-folder",          version = "6.15" },
            { plugin = "dashboard-view",            version = "2.17" },
            // Pipeline
            { plugin = "pipeline-model-definition", version = "1.8.5" },
            { plugin = "pipeline-stage-step",       version = "2.5" },
            { plugin = "pipeline-build-step",       version = "2.13" },
            { plugin = "workflow-scm-step",         version = "2.13" },
            { plugin = "pipeline-github",           version = "2.7" },
            // Development tools
            { plugin = "gitlab-plugin",             version = "1.5.20" },
            { plugin = "git-client",                version = "3.7.2" },
            { plugin = "xunit",                     version = "3.0.2" },
            { plugin = "junit",                     version = "1.51" },
            { plugin = "jacoco",                    version = "3.3.0" },
            // ... and more
            { plugin = "blueocean",                 version = "1.24.7" },
        ]
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
        enabled = false
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
        postgresql_image_tag = string
        postgresql_prometheus_enabled = bool
        prometheus_enabled = bool
    })
    description = "Sonarqube service configuration"
    default = {
        enabled = false
        namespace = "sonarqube"
        replicaCount = 2
        persistence_size = "5Gi"
        persistence_storage_class = "standard"
        postgresql_persistence_size = "8Gi"
        postgresql_persistence_storage_class = "standard"
        postgresql_database = "sonarqube"
        postgresql_user = "sonarqube"
        postgresql_password = "sonarqube"
        postgresql_image_tag = "13.3.0"
        postgresql_prometheus_enabled = true
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
        postgresql_image_tag = string
        postgresql_prometheus_enabled = bool
        prometheus_enabled = bool
    })
    description = "Keycloak service configuration"
    default = {
        enabled = false
        namespace = "keycloak"
        replica_count = 2
        postgresql_persistence_size = "8Gi"
        postgresql_persistence_storage_class = "standard"
        postgresql_database = "keycloak"
        postgresql_user = "keycloak"
        postgresql_password = "keycloak"
        postgresql_image_tag = "13.3.0"
        postgresql_prometheus_enabled = true
        ingress_enabled = true
        ingress_host = "keycloak.k8s.local"
        prometheus_enabled = true
    }
}

variable "dokuwiki" {
    type = object({
        enabled = bool
        namespace = string
        username = string
        password = string
        email = string
        full_name = string
        wiki_name = string
        persistence_size = string
        persistence_storage_class = string
        ingress_enabled = bool
        ingress_host = string
        prometheus_enabled = bool
    })
    description = "Docuwiki service configuration"
    default = {
        enabled = false
        namespace = "dokuwiki"
        username = "admin"
        password = "admin"
        email = "admin@k8s.local"
        full_name = "Administrator"
        wiki_name = "dademo's wiki"
        persistence_size = "8Gi"
        persistence_storage_class = "standard"
        ingress_enabled = true
        ingress_host = "dokuwiki.k8s.local"
        prometheus_enabled = true
    }
}

variable "nextcloud" {
    type = object({
        enabled = bool
        namespace = string
        admin_username = string
        admin_password = string
        mail_enabled = bool
        mail_from = string
        mail_domain = string
        smtp_host = string
        smtp_secured = bool
        smtp_port = number
        smtp_auth_type = string
        smtp_username = string
        smtp_password = string
        persistence_size = string
        persistence_storage_class = string
        ingress_enabled = bool
        ingress_host = string
        postgresql_database =  string
        postgresql_name = string
        postgresql_user = string
        postgresql_password =  string
        postgresql_persistence_size = string
        postgresql_persistence_storage_class = string
        postgresql_image_tag = string
        postgresql_prometheus_enabled = bool
        prometheus_enabled = bool
    })
    description = "Nextcloud service configuration"
    default = {
        enabled = false
        namespace = "nextcloud"
        admin_username = "admin"
        admin_password = "admin"
        mail_enabled = false
        mail_from = "admin@k8s.local"
        mail_domain = "k8s.local"
        smtp_host = "mailu.k8s.local"
        smtp_secured = false
        smtp_port = 25
        smtp_auth_type = "LOGIN"
        smtp_username = "admin"
        smtp_password = "admin"
        persistence_size = "8Gi"
        persistence_storage_class = "standard"
        ingress_enabled = true
        ingress_host = "nextcloud.k8s.local"
        postgresql_database =  "nextcloud"
        postgresql_name = "nextcloud"
        postgresql_user = "nextcloud"
        postgresql_password =  "nextcloud"
        postgresql_persistence_size = "8Gi"
        postgresql_persistence_storage_class = "standard"
        postgresql_image_tag = "13.3.0"
        postgresql_prometheus_enabled = true
        prometheus_enabled = true
    }
}

variable "kafka" {

    type = object({
        enabled = bool
        namespace = string
        replica_count = number
        heap_opts = list(string)
        delete_topic_enable = bool
        auto_create_topics_enable = bool
        log_flush_interval_ms = number
        log_retention_check_interval_ms = number
        log_retention_hours = number
        default_replication_factor = number
        offsets_topic_replication_factor = number
        transaction_state_log_replication_factor = number
        transaction_state_log_min_isr = number
        num_io_threads = number
        num_network_threads = number
        num_partitions = number
        num_recovery_threads_per_data_dir = number
        service_type = string
        persistence_size = string
        persistence_storage_class = string
        log_persistence_enabled = bool
        log_persistence_size = string
        prometheus_enabled = bool
    })
    description = "Kafka service configuration"
    default = {
        enabled = false
        namespace = "kafka"
        replica_count = 3
        heap_opts = [
            "-Xmx1024m",
            "-Xms1024m",
        ]
        delete_topic_enable = false
        auto_create_topics_enable = false
        log_flush_interval_ms = 1000
        log_retention_check_interval_ms = 300000
        log_retention_hours = 168
        default_replication_factor = 1
        offsets_topic_replication_factor = 1
        transaction_state_log_replication_factor = 1
        transaction_state_log_min_isr = 1
        num_io_threads = 8
        num_network_threads = 3
        num_partitions = 1
        num_recovery_threads_per_data_dir = 1
        service_type = "ClusterIP"
        persistence_size = "8Gi"
        persistence_storage_class = "standard"
        log_persistence_enabled = false
        log_persistence_size = "8Gi"
        prometheus_enabled = true
    }
}

variable "spark" {

    type = object({
        enabled = bool
        namespace = string
        replica_count = number
        controller_daemon_memory_limit = string
        controller_config_options = list(string)
        controller_extra_env_vars = list(string)
        controller_resources_limits = map(string)
        controller_resources_requests = map(string)
        worker_java_options = list(string)
        worker_config_options = list(string)
        worker_daemon_memory_limit = string
        worker_memory_limit = string
        worker_core_limit = string
        worker_resources_limits = map(string)
        worker_resources_requests = map(string)
        ingress_enabled = bool
        ingress_host = string
        prometheus_enabled = bool
    })
    description = "Spark service configuration"
    default = {
        enabled = false
        namespace = "spark"
        replica_count = 3
        controller_daemon_memory_limit = ""
        controller_config_options = []
        controller_extra_env_vars = []
        controller_resources_limits = {}
        controller_resources_requests = {}
        worker_java_options = []
        worker_config_options = []
        worker_daemon_memory_limit = ""
        worker_memory_limit = ""
        worker_core_limit = ""
        worker_resources_limits = {}
        worker_resources_requests = {}
        ingress_enabled = true
        ingress_host = "spark.k8s.local"
        prometheus_enabled = true
    }
}

variable "minio" {

    type = object({
        enabled = bool
        namespace = string
        operator_operator_replica_count = number
        operator_console_replica_count = number
        operator_ingress_enabled = bool
        operator_ingress_host = string
        operator_prometheus_enabled = bool
        tenant_name = string
        tenant_creds_access_key = string
        tenant_creds_secret_key = string
        tenant_replica_count = number
        tenant_volumes_per_server = number
        tenant_volume_size = string
        tenant_prometheus_enabled = bool
    })
    description = "MinIO service configuration"
    default = {
        enabled = false
        namespace = "minio"
        operator_operator_replica_count = 3
        operator_console_replica_count = 3
        operator_ingress_enabled = true
        operator_ingress_host = "minio.k8s.local"
        operator_prometheus_enabled = true
        tenant_name = "minio-tenant"
        tenant_creds_access_key = "minio"
        tenant_creds_secret_key = "minio123"
        tenant_replica_count = 4
        tenant_volumes_per_server = 4
        tenant_volume_size = "10Gi"
        tenant_prometheus_enabled = true
    }
}
