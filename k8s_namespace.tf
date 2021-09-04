resource "kubernetes_namespace" "namespace" {

  for_each = toset(concat(
  var.module_istio.enabled ? [
    "istio"
  ] : [],
  var.module_supervision.enabled ? [
    "supervision"
  ] : [],
  var.module_keycloak.enabled ? [
    "keycloak"
  ] : [],
  var.module_gitea.enabled ? [
    "gitea"
  ] : [],
  var.module_jenkins.enabled ? [
    "jenkins"
  ] : [],
  var.module_gocd.enabled ? [
    "gocd"
  ] : [],
  var.module_nexus.enabled ? [
    "nexus"
  ] : [],
  var.module_sonarqube.enabled ? [
    "sonarqube"
  ] : [],
  var.module_minio.enabled ? [
    "minio"
  ] : [],
  var.module_dokuwiki.enabled ? [
    "dokuwiki"
  ] : [],
  var.module_nextcloud.enabled ? [
    "nextcloud"
  ] : [],
  var.module_dev.enabled ? [
    "dev"
  ] : [],
  ))

  metadata {
    name = each.value
    labels = {
      "terraform-module" = local.service_mapping[each.value]
    }
  }
}

locals {

  service_mapping = {
    istio = var.module_istio.namespace
    supervision = var.module_supervision.namespace
    keycloak = var.module_keycloak.namespace
    gitea = var.module_gitea.namespace
    jenkins = var.module_jenkins.namespace
    gocd = var.module_gocd.namespace
    nexus = var.module_nexus.namespace
    sonarqube = var.module_sonarqube.namespace
    minio = var.module_minio.namespace
    dokuwiki = var.module_dokuwiki.namespace
    nextcloud = var.module_nextcloud.namespace
    dev = var.module_dev.namespace
  }
}
