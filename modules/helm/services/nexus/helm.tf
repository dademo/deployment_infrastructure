// https://github.com/sonatype/helm3-charts/tree/master/charts/nexus-repository-manager

resource "helm_release" "nexus" {

  name = "nexus"
  repository = "https://sonatype.github.io/helm3-charts/"
  chart = "nexus-repository-manager"
  version = local.helm_nexus_version

  timeout = 300
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/nexus.tpl.yaml", local.helm_nexus_tpl_values)
  ]
}

locals {
  helm_nexus_tpl_values = {
    persistence_size = var.service.persistence_size
    persistence_storage_class = var.service.persistence_storage_class
    ingress_enabled = tostring(var.service.ingress_enabled)
    ingress_host = var.service.ingress_host
  }
}