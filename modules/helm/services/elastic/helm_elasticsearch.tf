// https://github.com/elastic/helm-charts/tree/master/elasticsearch
resource "helm_release" "elasticsearch" {

  name = "${var.service_name}-elasticsearch"
  repository = "https://helm.elastic.co"
  chart = "elasticsearch"
  version = local.helm_elastic_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/elasticsearch.tpl.yaml", local.helm_elasticsearch_tpl_values)
  ]
}

locals {
  helm_elasticsearch_tpl_values = {
    replica_count = var.elasticsearch.replica_count
    cluster_name = var.elasticsearch.cluster_name
    node_group = var.elasticsearch.node_group
    es_java_opts = join(" ", var.elasticsearch.java_opts)
    cpu_limits_millis = var.elasticsearch.cpu_limits_millis
    memory_limits_mega = var.elasticsearch.memory_limits_mega
    http_port = 9200
    transport_port = 9300
    persistence_size = var.elasticsearch.persistence_size
    persistence_storage_class = var.elasticsearch.persistence_storage_class
    service_type = var.elasticsearch.service.type
    service_node_port = var.elasticsearch.service.node_port
    service_load_balancer_ip = var.elasticsearch.service.load_balancer_ip
    ingress_enabled = tostring(var.elasticsearch.ingress_enabled)
    ingress_hosts = var.elasticsearch.ingress_hosts
  }
}
