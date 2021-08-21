module "supervision" {
    source = "./modules/helm/supervision"
    count = var.module_supervision.enabled ? 1 : 0
    depends_on = [
      kubernetes_namespace.namespace["supervision"]
    ]

    // Variables
    namespace = var.module_supervision.namespace
    istio_enabled = var.module_supervision.istio_enabled
    grafana = var.module_supervision.grafana
    prometheus = var.module_supervision.prometheus
}

module "istio" {
    source = "./modules/helm/istio"
    count = var.module_istio.enabled ? 1 : 0
    depends_on = [
      kubernetes_namespace.namespace["istio"]
    ]

    // Variables
    namespace = var.module_istio.namespace
    enable_analysis = var.module_istio.enable_analysis
    system_ingress_enabled = var.module_istio.system_ingress_enabled
    system_egress_enabled = var.module_istio.system_egress_enabled
}

module "keycloak" {
    source = "./modules/helm/keycloak"
    count = var.module_keycloak.enabled ? 1 : 0
    depends_on = [
      kubernetes_namespace.namespace["keycloak"]
    ]

    // Variables
    namespace = var.module_keycloak.namespace
    service = var.module_keycloak.service
    deploy_postgresql = var.module_keycloak.deploy_postgresql
    database = var.module_keycloak.database
    database_password = var.module_keycloak_database_password
    prometheus_enabled = var.module_keycloak.prometheus_enabled
}

module "gitea" {
    source = "./modules/helm/gitea"
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
    source = "./modules/helm/jenkins"
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
    source = "./modules/helm/gocd"
    count = var.module_gocd.enabled ? 1 : 0
    depends_on = [
      kubernetes_namespace.namespace["gocd"]
    ]

    // Variables
    namespace = var.module_gocd.namespace
    service = var.module_gocd.service
}

module "nexus" {
    source = "./modules/helm/nexus"
    count = var.module_nexus.enabled ? 1 : 0
    depends_on = [
      kubernetes_namespace.namespace["nexus"]
    ]

    // Variables
    namespace = var.module_nexus.namespace
    service = var.module_nexus.service
}

module "sonarqube" {
    source = "./modules/helm/sonarqube"
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

module "minio" {
    source = "./modules/helm/minio"
    count = var.module_minio.enabled ? 1 : 0
    depends_on = [
      kubernetes_namespace.namespace["minio"]
    ]

    // Variables
    namespace = var.module_minio.namespace
    operator = var.module_minio.operator
    tenant_creds_access_key = var.module_minio.tenant_creds_access_key
    tenant_creds_secret_key = var.module_minio_tenant_creds_secret_key
}

module "dokuwiki" {
    source = "./modules/helm/dokuwiki"
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
    source = "./modules/helm/nextcloud"
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

module "dev" {
    source = "./modules/customs/dev"
    count = var.module_dev.enabled ? 1 : 0
    depends_on = [
      kubernetes_namespace.namespace["dev"]
    ]

    // Variables
    namespace = var.module_dev.namespace
    postgresql = var.module_dev.postgresql
    kafka = var.module_dev.kafka
    spark = var.module_dev.spark
    redis = var.module_dev.redis
    postgresql_password = var.module_dev_postgresql_password
    postgresql_image_tag = var.module_dev_postgresql_image_tag
    redis_password = var.module_dev_redis_password
}
