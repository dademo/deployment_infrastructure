// https://github.com/bitnami/charts/tree/master/bitnami/kafka

resource "helm_release" "kafka" {
    
    name = var.service_name
    repository = "https://charts.bitnami.com/bitnami"
    chart = "kafka"
    version = local.helm_kafka_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = var.namespace

    values = [
        "${templatefile("${path.module}/templates/kafka.tpl.yaml", local.helm_kafka_tpl_values)}"
    ]
}

locals {
    helm_kafka_tpl_values = {
        namespace = var.namespace
        replica_count = var.service.replica_count
        heap_opts = join(" ", var.service.heap_opts)
        delete_topic_enable = var.service.delete_topic_enable
        auto_create_topics_enable = var.service.auto_create_topics_enable
        log_flush_interval_ms = var.service.log_flush_interval_ms
        log_retention_check_interval_ms = var.service.log_retention_check_interval_ms
        log_retention_hours = var.service.log_retention_hours
        default_replication_factor = var.service.default_replication_factor
        offsets_topic_replication_factor = var.service.offsets_topic_replication_factor
        transaction_state_log_replication_factor = var.service.transaction_state_log_replication_factor
        transaction_state_log_min_isr = var.service.transaction_state_log_min_isr
        num_io_threads = var.service.num_io_threads
        num_network_threads = var.service.num_network_threads
        num_partitions = var.service.num_partitions
        num_recovery_threads_per_data_dir = var.service.num_recovery_threads_per_data_dir
        service_type = var.service.service_type
        persistence_size = var.service.persistence_size
        persistence_storage_class = var.service.persistence_storage_class
        log_persistence_enabled = var.service.log_persistence_enabled
        log_persistence_size = var.service.log_persistence_size
        prometheus_enabled = var.prometheus_enabled
    }
}
