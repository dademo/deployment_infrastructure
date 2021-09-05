variable "namespace" {
  type = string
  default = "dev"
  description = "The Kubernetes namespace where to deploy"
  sensitive = false
  validation {
    condition = length(var.namespace) > 0
    error_message = "The namespace value must not be null or empty."
  }
}

variable "postgresql" {
  type = object({
    enabled = bool
    service = object({
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
  })
  description = "The PostgreSQL database configuration"
  sensitive = false
  default = {
    enabled = false
    service = {
      database = "postgres"
      username = "postgres"
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
}

variable "mysql" {
  type = object({
    enabled = bool
    service = object({
      replica_count = number
      database = string
      username = string
      persistence_size = string
      persistence_storage_class = string
      primary_service = object({
        type = string
        node_port = string
        cluster_ip = string
        load_balancer_ip = string
      })
      secondary_service = object({
        type = string
        node_port = string
        cluster_ip = string
        load_balancer_ip = string
      })
    })
  })
  default = {
    enabled = false
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
  description = "The MySQL database configuration."
  sensitive = false
}

variable "mariadb" {
  type = object({
    enabled = bool
    service = object({
      replica_count = number
      database = string
      username = string
      persistence_size = string
      persistence_storage_class = string
      primary_service = object({
        type = string
        node_port = string
        cluster_ip = string
        load_balancer_ip = string
      })
      secondary_service = object({
        type = string
        node_port = string
        cluster_ip = string
        load_balancer_ip = string
      })
    })
  })
  default = {
    enabled = false
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
  description = "The MariDB database configuration."
  sensitive = false
}

variable "mongodb" {
  type = object({
    enabled = bool
    service = object({
      replica_count = number
      username = string
      database = string
      cluster_domain = string
      disable_javascript = bool
      arbiter_enabled = bool
      hidden_enabled = bool
      hidden_replica_count = number
      persistence_size = string
      persistence_storage_class = string
      service = object({
        type = string
        node_port = string
        cluster_ip = string
        load_balancer_ip = string
      })
      external_service = object({
        enabled = bool
        auto_discovery_enabled = bool
        type = string
        node_port = string
        load_balancer_ip = string
        domain = string
      })
    })
  })
  default = {
    enabled = false
    service = {
      replica_count = 1
      username = "mongodb"
      database = "dev"
      cluster_domain = "cluster.local"
      disable_javascript = false
      arbiter_enabled = true
      hidden_enabled = false
      hidden_replica_count = 1
      persistence_size = "8Gi"
      persistence_storage_class = "standard"
      service = {
        type = "ClusterIP"
        node_port = ""
        cluster_ip = ""
        load_balancer_ip = ""
      }
      external_service = {
        enabled = false
        auto_discovery_enabled = false
        type = "LoadBalancer"
        node_port = ""
        load_balancer_ip = ""
        domain = ""
      }
    }
  }
  description = "The MongoDB database configuration."
  sensitive = false
}

variable "kafka" {
  type = object({
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
      type = string
      persistence_size = string
      persistence_storage_class = string
      log_persistence_enabled = bool
      log_persistence_size = string
    })
  })
  description = "The Kafka service configuration"
  sensitive = false
  default = {
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
}

variable "spark" {
  type = object({
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
  description = "The Spark service configuration"
  sensitive = false
  default = {
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
}

variable "redis" {
  type = object({
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
  description = "The Redis service configuration"
  sensitive = false
  default = {
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
}

variable "rabbitmq" {
  type = object({
    enabled = bool
    service = object({
      replica_count = number
      username = string
      plugins = list(string)
      community_plugins = list(string)
      extra_plugins = list(string)
      clustering = object({
        enabled = bool
        rebalance = bool
      })
      persistence_size = string
      persistence_storage_class = string
      service = object({
        type = string
        node_port = string
        cluster_ip = string
        load_balancer_ip = string
        manager_enabled = bool
        manager_node_port = string
      })
      ingress_enabled = bool
      ingress_host = string
    })
  })
  description = "The RabbitMQ service configuration"
  sensitive = false
  default = {
    enabled = false
    service = {
      replica_count = 1
      username = "dev"
      plugins = [
        "rabbitmq_management",
        "rabbitmq_peer_discovery_k8s",
      ]
      community_plugins = []
      extra_plugins = []
      clustering = {
        enabled = true
        rebalance = false
      }
      persistence_size = "2Gi"
      persistence_storage_class = "standard"
      service = {
        type = "ClusterIP"
        node_port = ""
        cluster_ip = ""
        load_balancer_ip = ""
        manager_enabled = true
        manager_node_port = ""
      }
      ingress_enabled = true
      ingress_host = "rabbitmq.k8s.local"
    }
  }
}

variable "elastic" {
  type = object({
    enabled = bool
    elasticsearch = object({
      replica_count = number
      cluster_name = string
      node_group = string
      java_opts = list(string)
      cpu_limits_millis = number
      memory_limits_mega = number
      persistence_size = string
      persistence_storage_class = string
      service = object({
        type = string
        node_port = string
        load_balancer_ip = string
      })
      ingress_enabled = bool
      ingress_hosts = list(string)
    })
    kibana = object({
      enabled = bool
      replica_count = number
      service = object({
        type = string
        node_port = string
        load_balancer_ip = string
      })
      ingress_enabled = bool
      ingress_hosts = list(string)
    })
    apm = object({
      enabled = bool
      replica_count = number
      autoscaling = object({
        enabled = bool
        min_replicas = number
        max_replicas = number
        avg_cpu_utilization = number
      })
      service = object({
        type = string
        node_port = string
        load_balancer_ip = string
      })
      ingress_enabled = bool
      ingress_hosts = list(string)
    })
    filebeat = object({
      enabled = bool
      replica_count = number
      autoscaling = object({
        enabled = bool
        min_replicas = number
        max_replicas = number
        avg_cpu_utilization = number
      })
    })
    logstash = object({
      enabled = bool
      replica_count = number
      java_opts = list(string)
      cpu_limits_millis = number
      memory_limits_mega = number
      persistence_size = string
      persistence_storage_class = string
      ingress_enabled = bool
      ingress_hosts = list(string)
    })
    metricbeat = object({
      enabled = bool
      replica_count = number
      kube_state_metrics_host = string
    })
  })
  description = "The Elastic service configuration"
  sensitive = false
  default = {
    enabled = false
    elasticsearch = {
      replica_count = 3
      persistence_size = "8Gi"
      persistence_storage_class = "standard"
      cluster_name = "elasticsearch"
      node_group = "master"
      java_opts = []
      cpu_limits_millis = 1000
      memory_limits_mega = 2048
      persistence_size = "20Gi"
      persistence_storage_class = "standard"
      service = {
        type = "ClusterIP"
        node_port = ""
        cluster_ip = ""
        load_balancer_ip = ""
      }
      ingress_enabled = true
      ingress_hosts = [
        "elasticsearch.elastic.k8s.local",
      ]
    }
    kibana = {
      enabled = true
      replica_count = 1
      service = {
        type = "ClusterIP"
        node_port = ""
        cluster_ip = ""
        load_balancer_ip = ""
      }
      ingress_enabled = true
      ingress_hosts = [
        "kibana.elastic.k8s.local",
      ]
    }
    apm = {
      enabled = false
      replica_count = 1
      autoscaling = {
        enabled = true
        min_replicas = 1
        max_replicas = 3
        avg_cpu_utilization = 50
      }
      service = {
        type = "ClusterIP"
        node_port = ""
        cluster_ip = ""
        load_balancer_ip = ""
      }
      ingress_enabled = true
      ingress_hosts = [
        "apm.elastic.k8s.local",
      ]
    }
    filebeat = {
      enabled = false
      replica_count = 1
      autoscaling = {
        enabled = true
        min_replicas = 1
        max_replicas = 3
        avg_cpu_utilization = 50
      }
    }
    logstash = {
      enabled = false
      replica_count = 1
      java_opts = []
      cpu_limits_millis = 100
      memory_limits_mega = 1536
      persistence_size = "1Gi"
      persistence_storage_class = "standard"
      ingress_enabled = true
      ingress_hosts = [
        "logstash.elastic.k8s.local",
      ]
    }
    metricbeat = {
      enabled = false
      replica_count = 1
      kube_state_metrics_host = "prometheus-kube-state-metrics.supervision.svc.cluster.local:8080"
    }
  }
}

variable "pgadmin" {
  type = object({
    enabled = bool
    service = object({
      default_email = string
      login_banner = string
      persistence_size = string
      persistence_storage_class = string
      service = object({
        type = string
        node_port = number
        cluster_ip = string
        load_balancer_ip = string
      })
      ingress_enabled = bool
      ingress_hosts = list(string)
    })
  })
  description = "The PGAdmin service configuration"
  sensitive = false
  default = {
    enabled = false
    service = {
      default_email = "user@domain.com"
      login_banner = ""
      persistence_size = "1G"
      persistence_storage_class = "standard"
      service = {
        type = "ClusterIP"
        node_port = 0
        cluster_ip = ""
        load_balancer_ip = ""
      }
      ingress_enabled = true
      ingress_hosts = [
        "pgadmin.k8s.local"
      ]
    }
  }
}

variable "postgresql_password" {
  type = string
  description = "The postgresql database password to use."
  sensitive = true
}

variable "postgresql_postgres_password" {
  type = string
  description = "The postgresql postgres user password to use."
  sensitive = true
}

variable "postgresql_image_tag" {
  type = string
  description = "The postgresql database version tag to use."
  sensitive = false
  default = "13.3.0"
}

variable "mysql_root_password" {
  type = string
  description = "The MySQL database root user password to use."
  sensitive = true
}

variable "mysql_password" {
  type = string
  description = "The MySQL database password to use."
  sensitive = true
}

variable "mysql_replication_password" {
  type = string
  description = "The MySQL replication password to use."
  sensitive = true
}

variable "mariadb_root_password" {
  type = string
  description = "The MariaDB database root user password to use."
  sensitive = true
}

variable "mariadb_password" {
  type = string
  description = "The MariaDB database password to use."
  sensitive = true
}

variable "mariadb_replication_password" {
  type = string
  description = "The MariaDB replication password to use."
  sensitive = true
}

variable "mongodb_root_password" {
  type = string
  description = "The MongoDB database root user password to use."
  sensitive = true
}

variable "mongodb_password" {
  type = string
  description = "The MongoDB database password to use."
  sensitive = true
}

variable "mongodb_replicaset_password" {
  type = string
  description = "The MongoDB replica set password to use."
  sensitive = true
}

variable "redis_password" {
  type = string
  description = "The Redis service password to use."
  sensitive = true
}

variable "rabbitmq_password" {
  type = string
  description = "The RabbitMQ service password to use."
  sensitive = true
}

variable "pgadmin_password" {
  type = string
  description = "The PGAdmin service password to use."
  sensitive = true
}

variable "prometheus_enabled" {
  type = bool
  default = true
  description = "Define if prometheus supervision must be enabled."
  sensitive = false
}