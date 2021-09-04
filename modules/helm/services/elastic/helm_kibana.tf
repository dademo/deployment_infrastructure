// https://github.com/elastic/helm-charts/tree/master/kibana
resource "helm_release" "kibana" {

  count = var.kibana.enabled ? 1 : 0

  depends_on = [
    helm_release.elasticsearch
  ]

  name = "${var.service_name}-kibana"
  repository = "https://helm.elastic.co"
  chart = "kibana"
  version = local.helm_elastic_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/kibana.tpl.yaml", local.helm_kibana_tpl_values)
  ]
}

locals {
  helm_kibana_tpl_values = {
    elasticsearch_hosts = "http://${var.elasticsearch.cluster_name}-${var.elasticsearch.node_group}:9200"
    http_port = 5601
    replica_count = var.kibana.replica_count
    service_type = var.kibana.service.type
    service_node_port = var.kibana.service.node_port
    service_load_balancer_ip = var.kibana.service.load_balancer_ip
    ingress_enabled = tostring(var.kibana.ingress_enabled)
    ingress_hosts = var.kibana.ingress_hosts
  }
}
