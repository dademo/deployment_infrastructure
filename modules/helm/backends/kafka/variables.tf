variable "namespace" {
    type = string
    default = "kafka"
    description = "The Kubernetes namespace where to deploy"
    sensitive = false
    validation {
        condition = length(var.namespace) > 0
        error_message = "The namespace value must not be null or empty."
    }
}

variable "service_name" {
    type = string
    default = "kafka"
    description = "The service name to use."
    sensitive = false
    validation {
        condition = length(var.service_name) > 0
        error_message = "Service name must not be empty."
    }
}

variable "service" {
    type = object({
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
    default = {
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
        type = "LoadBalancer"
        persistence_size = "2Gi"
        persistence_storage_class = "standard"
        log_persistence_enabled = true
        log_persistence_size = "1Gi"
    }
    description = "The Kafka service configuration"
    sensitive = false
    validation {
        condition = alltrue([
            var.service.replica_count > 0,
            var.service.replica_count % 1 == 0,
            var.service.log_flush_interval_ms > 0,
            var.service.log_flush_interval_ms % 1 == 0,
            var.service.log_retention_check_interval_ms > 0,
            var.service.log_retention_check_interval_ms % 1 == 0,
            var.service.log_retention_hours > 0,
            var.service.log_retention_hours % 1 == 0,
            var.service.default_replication_factor > 0,
            var.service.default_replication_factor % 1 == 0,
            var.service.offsets_topic_replication_factor > 0,
            var.service.offsets_topic_replication_factor % 1 == 0,
            var.service.transaction_state_log_replication_factor > 0,
            var.service.transaction_state_log_replication_factor % 1 == 0,
            var.service.transaction_state_log_min_isr > 0,
            var.service.transaction_state_log_min_isr % 1 == 0,
            var.service.num_io_threads > 0,
            var.service.num_io_threads % 1 == 0,
            var.service.num_network_threads > 0,
            var.service.num_network_threads % 1 == 0,
            var.service.num_partitions > 0,
            var.service.num_partitions % 1 == 0,
            var.service.num_recovery_threads_per_data_dir > 0,
            var.service.num_recovery_threads_per_data_dir % 1 == 0,
            contains(["ClusterIP", "NodePort", "LoadBalancer", "ExternalName"], var.service.type),
            length(var.service.persistence_storage_class) > 0,
            can(regex("^[0-9]+[GM]i$", var.service.persistence_size)),
            can(regex("^[0-9]+[GM]i$", var.service.log_persistence_size)),
        ])
        error_message = "Invalid Kafka service configuration."
    }
}

variable "prometheus_enabled" {
    type = bool
    default = true
    description = "Define if prometheus supervision must be enabled."
    sensitive = false
}
