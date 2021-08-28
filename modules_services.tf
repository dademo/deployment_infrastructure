module "keycloak" {
  source = "./modules/helm/services/keycloak"
  count = var.module_keycloak.enabled ? 1 : 0
  depends_on = [
    kubernetes_namespace.namespace["keycloak"]
  ]

  // Variables
  namespace = var.module_keycloak.namespace
  service = var.module_keycloak.service
  deploy_postgresql = var.module_keycloak.deploy_postgresql
  database = var.module_keycloak.database
  admin_password = var.module_keycloak_admin_password
  management_password = var.module_keycloak_management_password
  database_password = var.module_keycloak_database_password
  prometheus_enabled = var.module_keycloak.prometheus_enabled
}

module "gitea" {
  source = "./modules/helm/services/gitea"
  count = var.module_gitea.enabled ? 1 : 0
  depends_on = [
    kubernetes_namespace.namespace["gitea"]
  ]

  // Variables
  namespace = var.module_gitea.namespace
  service = var.module_gitea.service
  deploy_postgresql = var.module_gitea.deploy_postgresql
  database = var.module_gitea.database
  database_password = var.module_gitea_database_password
  prometheus_enabled = var.module_gitea.prometheus_enabled
}

module "jenkins" {
  source = "./modules/helm/services/jenkins"
  count = var.module_jenkins.enabled ? 1 : 0
  depends_on = [
    kubernetes_namespace.namespace["jenkins"]
  ]

  // Variables
  namespace = var.module_jenkins.namespace
  service = var.module_jenkins.service
  additional_plugins = var.module_jenkins.additional_plugins
  prometheus_enabled = var.module_jenkins.prometheus_enabled
}

module "gocd" {
  source = "./modules/helm/services/gocd"
  count = var.module_gocd.enabled ? 1 : 0
  depends_on = [
    kubernetes_namespace.namespace["gocd"]
  ]

  // Variables
  namespace = var.module_gocd.namespace
  service = var.module_gocd.service
}

module "nexus" {
  source = "./modules/helm/services/nexus"
  count = var.module_nexus.enabled ? 1 : 0
  depends_on = [
    kubernetes_namespace.namespace["nexus"]
  ]

  // Variables
  namespace = var.module_nexus.namespace
  service = var.module_nexus.service
}

module "sonarqube" {
  source = "./modules/helm/services/sonarqube"
  count = var.module_sonarqube.enabled ? 1 : 0
  depends_on = [
    kubernetes_namespace.namespace["sonarqube"]
  ]

  // Variables
  namespace = var.module_sonarqube.namespace
  service = var.module_sonarqube.service
  deploy_postgresql = var.module_sonarqube.deploy_postgresql
  database = var.module_sonarqube.database
  database_password = var.module_sonarqube_database_password
  prometheus_enabled = var.module_sonarqube.prometheus_enabled
}

module "dokuwiki" {
  source = "./modules/helm/services/dokuwiki"
  count = var.module_dokuwiki.enabled ? 1 : 0
  depends_on = [
    kubernetes_namespace.namespace["dokuwiki"]
  ]

  // Variables
  namespace = var.module_dokuwiki.namespace
  auth = var.module_dokuwiki.auth
  auth_password = var.dokuwiki_auth_password
  service = var.module_dokuwiki.service
  prometheus_enabled = var.module_dokuwiki.prometheus_enabled
}

module "nextcloud" {
  source = "./modules/helm/services/nextcloud"
  count = var.module_nextcloud.enabled ? 1 : 0
  depends_on = [
    kubernetes_namespace.namespace["nextcloud"]
  ]

  // Variables
  namespace = var.module_nextcloud.namespace
  service = var.module_nextcloud.service
  deploy_postgresql = var.module_nextcloud.deploy_postgresql
  database = var.module_nextcloud.database
  database_password = var.module_nextcloud_database_password
  smtp_password = var.module_nextcloud_smtp_password
  service_admin_password = var.module_nextcloud_service_admin_password
  prometheus_enabled = var.module_nextcloud.prometheus_enabled
}
