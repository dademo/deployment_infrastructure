// https://github.com/bitnami/charts/tree/controller/bitnami/spark

resource "helm_release" "spark" {

  name = var.service_name
  repository = "https://charts.bitnami.com/bitnami"
  chart = "spark"
  version = local.helm_spark_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/spark.tpl.yaml", local.helm_spark_tpl_values)
  ]
}

locals {
  helm_spark_tpl_values = {
    namespace = var.namespace
    replica_count = var.service.replica_count
    controller_daemon_memory_limit = var.service.controller.daemon_memory_limit
    controller_config_options = join(" ", var.service.controller.config_options)
    controller_extra_env_vars = var.service.controller.extra_env_vars
    controller_resources_limits = var.service.controller.resources_limits
    controller_resources_requests = var.service.controller.resources_requests
    worker_java_options = join(" ", var.service.worker.java_options)
    worker_config_options = join(" ", var.service.worker.config_options)
    worker_daemon_memory_limit = var.service.worker.daemon_memory_limit
    worker_memory_limit = var.service.worker.memory_limit
    worker_core_limit = var.service.worker.core_limit
    worker_resources_limits = var.service.worker.resources_limits
    worker_resources_requests = var.service.worker.resources_requests
    ingress_enabled = var.service.ingress_enabled
    ingress_host = var.service.ingress_host
    prometheus_enabled = var.prometheus_enabled
  }
}
