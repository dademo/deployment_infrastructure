// https://docs.dokuwiki.io/en-us/install-on-kubernetes/

resource "helm_release" "dokuwiki" {

    count = var.dokuwiki.enabled ? 1 : 0

    name       = "dokuwiki"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "dokuwiki"
    version    = local.helm_dokuwiki_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.dokuwiki[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/dokuwiki.tpl.yaml", local.helm_dokuwiki_tpl_values)}"
    ]
}

locals {
    helm_dokuwiki_tpl_values = {
        namespace = var.dokuwiki.namespace
        username = var.dokuwiki.username
        password = var.dokuwiki.password
        email = var.dokuwiki.email
        full_name = var.dokuwiki.full_name
        wiki_name = var.dokuwiki.wiki_name
        persistence_size = var.dokuwiki.persistence_size
        persistence_storage_class = var.dokuwiki.persistence_storage_class
        ingress_enabled = tostring(var.dokuwiki.ingress_enabled)
        ingress_host = var.dokuwiki.ingress_host
        prometheus_enabled = tostring(var.dokuwiki.prometheus_enabled)
    }
}
