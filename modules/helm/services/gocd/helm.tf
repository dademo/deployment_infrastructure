// https://docs.gocd.org/current/gocd_on_kubernetes/helm_install.html

resource "helm_release" "gocd" {
    
    name = "gocd"
    repository = "https://gocd.github.io/helm-chart"
    chart = "gocd"
    version = local.helm_gocd_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = var.namespace

    values = [
        "${templatefile("${path.module}/templates/gocd.tpl.yaml", local.helm_gocd_tpl_values)}"
    ]
}

locals {
    helm_gocd_tpl_values = {
        persistence_size = var.service.persistence_size
        persistence_storage_class = var.service.persistence_storage_class
        agent_replica_count = var.service.agent.replica_count
        agent_persistence_enabled = var.service.agent.persistence_enabled
        agent_persistence_size = var.service.agent.persistence_size
        agent_persistence_storage_class = var.service.agent.persistence_storage_class
        ingress_enabled = tostring(var.service.ingress_enabled)
        ingress_hosts = var.service.ingress_hosts
    }
}
