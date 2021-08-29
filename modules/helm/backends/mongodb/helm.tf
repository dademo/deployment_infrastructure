// https://github.com/bitnami/charts/tree/master/bitnami/postgresql
resource "helm_release" "mongodb" {

  depends_on = [
    kubernetes_secret.auth
  ]

  name = var.service_name
  repository = "https://charts.bitnami.com/bitnami"
  chart = "mongodb"
  version = local.helm_mongodb_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/mongodb.tpl.yaml", local.helm_mongodb_tpl_values)
  ]
}

resource "kubernetes_secret" "auth" {

  metadata {
    name = "mongodb-auth"
    namespace = var.namespace
  }

  data = {
    "${local.mongodb_secret_user_password_key}" = var.mongodb_password
    "${local.mongodb_secret_root_password_key}" = var.mongodb_root_password
    "${local.mongodb_secret_replicaset_password_key}" = var.mongodb_replicaset_password
  }

  type = "Opaque"
}

locals {
  helm_mongodb_tpl_values = {
    replica_count = var.database.replica_count
    username = var.database.username
    database = var.database.database
    cluster_domain = var.database.cluster_domain
    disable_javascript = var.database.disable_javascript
    arbiter_enabled = var.database.arbiter_enabled
    hidden_enabled = var.database.hidden_enabled
    hidden_replica_count = var.database.hidden_replica_count
    auth_secret = kubernetes_secret.auth.metadata[0].name
    persistence_size = var.database.persistence_size
    persistence_storage_class = var.database.persistence_storage_class
    service_type = var.database.service.type
    service_node_port = var.database.service.node_port
    service_cluster_ip = var.database.service.cluster_ip
    service_load_balancer_ip = var.database.service.load_balancer_ip
    external_access_enabled = var.database.external_service.enabled
    external_access_auto_discovery_enabled = var.database.external_service.auto_discovery_enabled
    external_service_type = var.database.external_service.type
    external_service_node_port = var.database.external_service.node_port
    external_service_load_balancer_ip = var.database.external_service.load_balancer_ip
    external_service_domain = var.database.external_service.domain
    prometheus_enabled = tostring(var.prometheus_enabled)
  }
}
