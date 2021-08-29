// https://github.com/bitnami/charts/tree/master/bitnami/postgresql
resource "helm_release" "rabbitmq" {

  depends_on = [
    kubernetes_secret.auth
  ]

  name = var.service_name
  repository = "https://charts.bitnami.com/bitnami"
  chart = "rabbitmq"
  version = local.helm_rabbitmq_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/rabbitmq.tpl.yaml", local.helm_rabbitmq_tpl_values)
  ]
}

resource "kubernetes_secret" "auth" {

  metadata {
    name = "rabbitmq-auth"
    namespace = var.namespace
  }

  data = {
    "${local.rabbitmq_secret_admin_password_key}" = var.rabbitmq_password
    "${local.rabbitmq_secret_erlang_cookie_password_key}": random_password.rabbitmq_erlang_cookie.result
  }

  type = "Opaque"
}

// https://www.rabbitmq.com/clustering.html#erlang-cookie
resource "random_password" "rabbitmq_erlang_cookie" {
  length = 255
  lower = true
  upper = true
  special = false
}

locals {
  helm_rabbitmq_tpl_values = {
    replica_count = var.service.replica_count
    username = var.service.username
    auth_secret = kubernetes_secret.auth.metadata[0].name
    plugins = join(" ", var.service.plugins)
    community_plugins = join(" ", var.service.community_plugins)
    extra_plugins = join(" ", var.service.extra_plugins)
    clustering_enabled = tostring(var.service.clustering.enabled)
    clustering_rebalance = tostring(var.service.clustering.rebalance)
    persistence_size = var.service.persistence_size
    persistence_storage_class = var.service.persistence_storage_class
    service_type = var.service.service.type
    service_node_port = var.service.service.node_port
    service_cluster_ip = var.service.service.cluster_ip
    service_load_balancer_ip = var.service.service.load_balancer_ip
    service_manager_enabled = var.service.service.manager_enabled
    service_manager_node_port = var.service.service.manager_node_port
    manager_ingress_enabled = var.service.ingress_enabled
    manager_ingress_host = var.service.ingress_host
    prometheus_enabled = tostring(var.prometheus_enabled)
  }
}
