// https://github.com/bitnami/charts/tree/master/bitnami/kafka

resource "helm_release" "kafka" {
    
    count = var.kafka.enabled ? 1 : 0
    
    name       = "kafka"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "kafka"
    version    = local.helm_kafka_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.kafka[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/kafka.tpl.yaml", local.helm_kafka_tpl_values)}"
    ]
}

locals {
    helm_kafka_tpl_values = {
        namespace = var.kafka.namespace
        replica_count = var.kafka.replica_count
        heap_opts = join(" ", var.kafka.heap_opts)
        delete_topic_enable = var.kafka.delete_topic_enable
        auto_create_topics_enable = var.kafka.auto_create_topics_enable
        log_flush_interval_ms = var.kafka.log_flush_interval_ms
        log_retention_check_interval_ms = var.kafka.log_retention_check_interval_ms
        log_retention_hours = var.kafka.log_retention_hours
        default_replication_factor = var.kafka.default_replication_factor
        offsets_topic_replication_factor = var.kafka.offsets_topic_replication_factor
        transaction_state_log_replication_factor = var.kafka.transaction_state_log_replication_factor
        transaction_state_log_min_isr = var.kafka.transaction_state_log_min_isr
        num_io_threads = var.kafka.num_io_threads
        num_network_threads = var.kafka.num_network_threads
        num_partitions = var.kafka.num_partitions
        num_recovery_threads_per_data_dir = var.kafka.num_recovery_threads_per_data_dir
        service_type = var.kafka.service_type
        persistence_size = var.kafka.persistence_size
        persistence_storage_class = var.kafka.persistence_storage_class
        log_persistence_enabled = var.kafka.log_persistence_enabled
        log_persistence_size = var.kafka.log_persistence_size
        prometheus_enabled = var.kafka.prometheus_enabled
    }
}
