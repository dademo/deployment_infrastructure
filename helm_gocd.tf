// https://docs.gocd.org/current/gocd_on_kubernetes/helm_install.html

resource "helm_release" "gocd" {
    
    count = var.gocd.enabled ? 1 : 0

    name = "gocd"
    repository = "https://gocd.github.io/helm-chart"
    chart = "gocd"
    version = local.helm_gocd_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = kubernetes_namespace.gocd[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/gocd.tpl.yaml", local.helm_gocd_tpl_values)}"
    ]
}

locals {
    helm_gocd_tpl_values = {
        persistence_size = var.gocd.persistence_size
        persistence_storage_class = var.gocd.persistence_storage_class
        agent_replica_count = var.gocd.agent_replica_count
        agent_persistence_enabled = var.gocd.agent_persistence_enabled
        agent_persistence_size = var.gocd.agent_persistence_size
        ingress_enabled = tostring(var.gocd.ingress_enabled)
        ingress_hosts = var.gocd.ingress_hosts
    }
}
