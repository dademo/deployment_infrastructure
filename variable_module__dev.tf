variable "module_dev" {
    type = object({
        enabled = bool
        namespace = string
        postgresql = object({
            enabled = bool
            service = object({
                database = string
                username = string
                persistence_size = string
                persistence_storage_class = string
                service = object({
                    service_type = string
                    service_node_port = string
                    service_cluster_ip = string
                    service_load_balancer_ip = string
                })
            })
        })
        mysql = object({
            enabled = bool
            service = object({
                replica_count = number
                database = string
                username = string
                persistence_size = string
                persistence_storage_class = string
                primary_service = object({
                    service_type = string
                    service_node_port = string
                    service_cluster_ip = string
                    service_load_balancer_ip = string
                })
                secondary_service = object({
                    service_type = string
                    service_node_port = string
                    service_cluster_ip = string
                    service_load_balancer_ip = string
                })
            })
        })
        mariadb = object({
            enabled = bool
            service = object({
                replica_count = number
                database = string
                username = string
                persistence_size = string
                persistence_storage_class = string
                primary_service = object({
                    service_type = string
                    service_node_port = string
                    service_cluster_ip = string
                    service_load_balancer_ip = string
                })
                secondary_service = object({
                    service_type = string
                    service_node_port = string
                    service_cluster_ip = string
                    service_load_balancer_ip = string
                })
            })
        })
        kafka = object({
            enabled = bool
            service = object({
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
            })
        })
        spark = object({
            enabled = bool
            service = object({
                replica_count = number
                controller = object({
                    daemon_memory_limit = string
                    config_options = list(string)
                    extra_env_vars = list(string)
                    resources_limits = map(any)
                    resources_requests = map(any)
                })
                worker = object({
                    java_options = list(string)
                    config_options = list(string)
                    daemon_memory_limit = string
                    memory_limit = string
                    core_limit = string
                    resources_limits = map(any)
                    resources_requests = map(any)
                })
                ingress_enabled = bool
                ingress_host = string
            })
        })
        redis = object({
            enabled = bool
            service = object({
                replica_count = number
                authentication_enabled = bool
                persistence_size = string
                persistence_storage_class = string
                volume_permissions_enabled = bool
                sysctl_enabled = bool
            })
        })
        prometheus_enabled = bool
    })
    sensitive = false
    description = "Dev module configuration."
    default = {
        enabled = true
        namespace = "dev"
        postgresql = {
            enabled = false
            service = {
                database = "dev"
                username = "dev"
                persistence_size = "2Gi"
                persistence_storage_class = "standard"
                service = {
                    service_type = "ClusterIP"
                    service_node_port = ""
                    service_cluster_ip = ""
                    service_load_balancer_ip = ""
                }
            }
        }
        mysql = {
            enabled = false
            service = {
                replica_count = 0
                database = "mysql"
                username = "mysql"
                persistence_size = "2Gi"
                persistence_storage_class = "standard"
                primary_service = {
                    service_type = "ClusterIP"
                    service_node_port = ""
                    service_cluster_ip = ""
                    service_load_balancer_ip = ""
                }
                secondary_service = {
                    service_type = "ClusterIP"
                    service_node_port = ""
                    service_cluster_ip = ""
                    service_load_balancer_ip = ""
                }
            }
        }
        mariadb = {
            enabled = false
            service = {
                replica_count = 0
                database = "mariadb"
                username = "mariadb"
                persistence_size = "2Gi"
                persistence_storage_class = "standard"
                primary_service = {
                    service_type = "ClusterIP"
                    service_node_port = ""
                    service_cluster_ip = ""
                    service_load_balancer_ip = ""
                }
                secondary_service = {
                    service_type = "ClusterIP"
                    service_node_port = ""
                    service_cluster_ip = ""
                    service_load_balancer_ip = ""
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
                service_type = "ClusterIP"
                persistence_size = "2Gi"
                persistence_storage_class = "standard"
                log_persistence_enabled = true
                log_persistence_size = "1Gi"
            }
        }
        spark = {
            enabled = false
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
            enabled = false
            service = {
                replica_count = 0
                authentication_enabled = false
                persistence_size = "512Mi"
                persistence_storage_class = "standard"
                volume_permissions_enabled = false
                sysctl_enabled = false
            }
        }
        prometheus_enabled = true
    }
}

variable "module_dev_postgresql_password" {
    type = string
    description = "The PostgreSQL database password to use."
    sensitive = true
}

variable "module_dev_postgresql_postgres_password" {
    type = string
    description = "The PostgreSQL postgres user password to use."
    sensitive = true
}

variable "module_dev_postgresql_image_tag" {
    type = string
    description = "The PostgreSQL database version tag to use."
    sensitive = false
    default = "13.3.0"
}

variable "module_dev_mysql_root_password" {
    type = string
    description = "The MySQL database root user password to use."
    sensitive = true
}

variable "module_dev_mysql_password" {
    type = string
    description = "The MySQL database password to use."
    sensitive = true
}

variable "module_dev_mysql_replication_password" {
    type = string
    description = "The MySQL replication password to use."
    sensitive = true
}

variable "module_dev_mariadb_root_password" {
    type = string
    description = "The MariaDB database root user password to use."
    sensitive = true
}

variable "module_dev_mariadb_password" {
    type = string
    description = "The MariaDB database password to use."
    sensitive = true
}

variable "module_dev_mariadb_replication_password" {
    type = string
    description = "The MariaDB replication password to use."
    sensitive = true
}

variable "module_dev_redis_password" {
    type = string
    description = "The redis service password to use."
    sensitive = true
}