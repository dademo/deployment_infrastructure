k8s_config_context = "minikube"

k8s_dashboard = {
    enabled = true
    namespace = "kubernetes-dashboard"
    service_name = "kubernetes-dashboard"
    service_port_http = 80
    ingress_host = "dashboard.k8s.local"
}

k8s_kibana_logging = {
    enabled = false
    namespace = "kube-system"
    service_name = "kibana-logging"
    service_port_http = 5601
    ingress_host = "kibana.k8s.local"
}

k8s_registry = {
    enabled = true
    namespace = "kube-system"
    service_name = "registry"
    service_port_http = 80
    service_port_https = 443
    ingress_host = "registry.k8s.local"
}

module_supervision = {
    enabled = true
    istio_enabled = true
    namespace = "supervision"
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

module_supervision_grafana_admin_password = "admin"

module_istio = {
    enabled = true
    namespace = "istio"
    enable_analysis = true
    system_ingress_enabled = false
    system_egress_enabled = false
}

module_keycloak = {
    enabled = true
    namespace = "keycloak"
    service = {
        replica_count = 1
        admin_username = "admin"
        management_username = "management"
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        ingress_enabled = true
        ingress_host = "keycloak.k8s.local"
    }
    deploy_postgresql = true
    database_host = ""
    database = {
        database = "keycloak"
        username = "keycloak"
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

module_keycloak_admin_password = "admin"

module_keycloak_management_password = "management"

module_keycloak_database_password = "keycloak"

module_gitea = {
    enabled = true
    namespace = "gitea"
    service = {
        replica_count = 1
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        ingress_enabled = true
        ingress_hosts = ["gitea.k8s.local"]
        admin_mail = "admin@gitea.k8s.local"
        disable_registration = true
        openid_registration_only = true
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

module_gitea_database_password = "gitea"

module_jenkins = {
    enabled = true
    namespace = "jenkins"
    service = {
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        ingress_enabled = true
        ingress_host = "jenkins.k8s.local"
    }
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
    prometheus_enabled = true
}

module_gocd = {
    enabled = true
    namespace = "gocd"
    service = {
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        agent = {
            replica_count = 0
            persistence_enabled = false
            persistence_size = "1Gi"
            persistence_storage_class = "standard"
        }
        ingress_enabled = true
        ingress_hosts = ["gocd.k8s.local"]
    }
}

module_nexus = {
    enabled = true
    namespace = "nexus"
    service = {
        persistence_storage_class = "standard"
        persistence_size = "5Gi"
        ingress_enabled = true
        ingress_host = "nexus.k8s.local"
    }
}

module_sonarqube = {
    enabled = true
    namespace = "sonarqube"
    service = {
        replica_count = 1
        persistence_size = "20Gi"
        persistence_storage_class = "standard"
        ingress_enabled = true
        ingress_hosts = ["sonarqube.k8s.local"]
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

module_sonarqube_database_password = "sonarqube"

module_minio = {
    enabled = true
    namespace = "minio"
    operator = {
        operator_replica_count = 3
        console_replica_count = 3
        ingress_enabled = true
        ingress_host = "minio.k8s.local"
    }
    tenant_creds_access_key = "minio"
    prometheus_enabled = true
}

module_minio_tenant_creds_secret_key = "minio123"

module_dokuwiki = {
    enabled = true
    namespace = "dokuwiki"
    auth = {
        username = "admin"
        email = "admin@k8s.local"
        full_name = "The Administrator"
    }
    service = {
        wiki_name = "WIKI"
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        ingress_enabled = true
        ingress_host = "dokuwiki.k8s.local"
    }
    prometheus_enabled = true
}

dokuwiki_auth_password = "dokuwiki"

module_nextcloud = {
    enabled = true
    namespace = "nextcloud"
    service = {
        admin_username = "admin"
        mail = {
            enabled = false
            from = "admin"
            domain = "k8s.local"
        }
        smtp = {
            host = "mail.k8s.local"
            secured = false
            port = 25
            auth_type = "LOGIN"
            username = "admin"
        }
        persistence_size = "20Gi"
        persistence_storage_class = "standard"
        ingress_enabled = true
        ingress_host = "nextcloud.k8s.local"
    }
    deploy_postgresql = true
    database_host = ""
    database = {
        database = "nextcloud"
        username = "nextcloud"
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

module_nextcloud_database_password = "nextcloud"

module_nextcloud_smtp_password = "nextcloud"

module_nextcloud_admin_password = "admin"

module_dev = {
    enabled = true
    namespace = "dev"
    postgresql = {
        enabled = true
        service = {
            database = "dev"
            username = "dev"
            persistence_size = "2Gi"
            persistence_storage_class = "standard"
            service = {
                type = "ClusterIP"
                node_port = ""
                cluster_ip = ""
                load_balancer_ip = ""
            }
        }
    }
    mysql = {
        enabled = true
        service = {
            replica_count = 0
            database = "mysql"
            username = "mysql"
            persistence_size = "2Gi"
            persistence_storage_class = "standard"
            primary_service = {
                type = "ClusterIP"
                node_port = ""
                cluster_ip = ""
                load_balancer_ip = ""
            }
            secondary_service = {
                type = "ClusterIP"
                node_port = ""
                cluster_ip = ""
                load_balancer_ip = ""
            }
        }
    }
    mariadb = {
        enabled = true
        service = {
            replica_count = 0
            database = "mariadb"
            username = "mariadb"
            persistence_size = "2Gi"
            persistence_storage_class = "standard"
            primary_service = {
                type = "ClusterIP"
                node_port = ""
                cluster_ip = ""
                load_balancer_ip = ""
            }
            secondary_service = {
                type = "ClusterIP"
                node_port = ""
                cluster_ip = ""
                load_balancer_ip = ""
            }
        }
    }
    kafka = {
        enabled = false
        service = {
            replica_count = 3
            heap_opts = [
                "-Xmx512m",
                "-Xms512m",
            ]
            delete_topic_enable = true
            auto_create_topics_enable = true
            log_flush_interval_ms = 1000
            log_retention_check_interval_ms = 300000
            log_retention_hours = 168
            default_replication_factor = 2
            offsets_topic_replication_factor = 2
            transaction_state_log_replication_factor = 2
            transaction_state_log_min_isr = 2
            num_io_threads = 8
            num_network_threads = 3
            num_partitions = 10
            num_recovery_threads_per_data_dir = 1
            type = "ClusterIP"
            persistence_size = "2Gi"
            persistence_storage_class = "standard"
            log_persistence_enabled = true
            log_persistence_size = "1Gi"
        }
    }
    spark = {
        enabled = true
        service = {
            replica_count = 3
            controller = {
                daemon_memory_limit = "1g"
                config_options = []
                extra_env_vars = []
                resources_limits = {
                    memory = "1Gi"
                }
                resources_requests = {}
            }
            worker = {
                java_options = []
                config_options = []
                daemon_memory_limit = ""
                memory_limit = "2g"
                core_limit = ""
                resources_limits = {
                    memory = "2Gi"
                }
                resources_requests = {}
            }
            ingress_enabled = true
            ingress_host = "spark.k8s.local"
        }
    }
    redis = {
        enabled = true
        service = {
            replica_count = 3
            authentication_enabled = false
            persistence_size = "512Mi"
            persistence_storage_class = "standard"
            volume_permissions_enabled = false
            sysctl_enabled = false
        }
    }
    prometheus_enabled = true
}

module_dev_postgresql_password = "dev"
module_dev_postgresql_postgres_password = "postgres"
module_dev_mysql_password = "mysql"
module_dev_mysql_root_password = "mysql"
module_dev_mysql_replication_password = "mysql"
module_dev_mariadb_password = "mysql"
module_dev_mariadb_root_password = "mysql"
module_dev_mariadb_replication_password = "mysql"
module_dev_redis_password = "redis"
