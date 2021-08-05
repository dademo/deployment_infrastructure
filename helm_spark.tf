// https://github.com/bitnami/charts/tree/controller/bitnami/spark

resource "helm_release" "spark" {
    
    count = var.spark.enabled ? 1 : 0
    
    name       = "spark"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "spark"
    version    = local.helm_spark_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.spark[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/spark.tpl.yaml", local.helm_spark_tpl_values)}"
    ]
}

locals {
    helm_spark_tpl_values = {
        namespace = var.spark.namespace
        replica_count = var.spark.replica_count
        controller_daemon_memory_limit = var.spark.controller_daemon_memory_limit
        controller_config_options = join(" ", var.spark.controller_config_options)
        controller_extra_env_vars = var.spark.controller_extra_env_vars
        controller_resources_limits = var.spark.controller_resources_limits
        controller_resources_requests = var.spark.controller_resources_requests
        worker_java_options = join(" ", var.spark.worker_java_options)
        worker_config_options = join(" ", var.spark.worker_config_options)
        worker_daemon_memory_limit = var.spark.worker_daemon_memory_limit
        worker_memory_limit = var.spark.worker_memory_limit
        worker_core_limit = var.spark.worker_core_limit
        worker_resources_limits = var.spark.worker_resources_limits
        worker_resources_requests = var.spark.worker_resources_requests
        ingress_enabled = var.spark.ingress_enabled
        ingress_host = var.spark.ingress_host
        prometheus_enabled = var.spark.prometheus_enabled
    }
}
