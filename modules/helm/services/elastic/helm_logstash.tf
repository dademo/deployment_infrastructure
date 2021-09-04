// https://github.com/elastic/helm-charts/tree/master/logstash
resource "helm_release" "logstash" {

  count = var.logstash.enabled ? 1 : 0

  depends_on = [
    helm_release.elasticsearch
  ]

  name = "${var.service_name}-logstash"
  repository = "https://helm.elastic.co"
  chart = "logstash"
  version = local.helm_elastic_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/logstash.tpl.yaml", local.helm_logstash_tpl_values)
  ]
}

locals {
  helm_logstash_tpl_values = {
    replica_count = var.logstash.replica_count
    http_port = 9600
    logstash_java_opts = join(" ", var.logstash.java_opts)
    cpu_limits_millis = var.logstash.cpu_limits_millis
    memory_limits_mega = var.logstash.memory_limits_mega
    persistence_size = var.logstash.persistence_size
    persistence_storage_class = var.logstash.persistence_storage_class
    ingress_enabled = tostring(var.logstash.ingress_enabled)
    ingress_hosts = var.logstash.ingress_hosts
  }
}
