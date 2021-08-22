// https://artifacthub.io/packages/helm/bitnami/dokuwiki

resource "helm_release" "dokuwiki" {

    depends_on = [
        kubernetes_secret.auth
    ]

    name = "dokuwiki"
    repository = "https://charts.bitnami.com/bitnami"
    chart = "dokuwiki"
    version = local.helm_dokuwiki_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = var.namespace

    values = [
        "${templatefile("${path.module}/templates/dokuwiki.tpl.yaml", local.helm_dokuwiki_tpl_values)}"
    ]
}

resource "kubernetes_secret" "auth" {

    metadata {
        name = "dokuwiki-auth"
        namespace = var.namespace
    }

    data = {
        "dokuwiki-password" = var.auth_password
    }
    
    type = "Opaque"
}

locals {
    helm_dokuwiki_tpl_values = {
        namespace = var.namespace
        username = var.auth.username
        dokuwiki_auth_secret_name = kubernetes_secret.auth.metadata[0].name
        email = var.auth.email
        full_name = var.auth.full_name
        wiki_name = var.service.wiki_name
        persistence_size = var.service.persistence_size
        persistence_storage_class = var.service.persistence_storage_class
        ingress_enabled = tostring(var.service.ingress_enabled)
        ingress_host = var.service.ingress_host
        prometheus_enabled = tostring(var.prometheus_enabled)
    }
}
