// https://docs.gitlab.com/charts/

resource "helm_release" "gitlab" {
    
    count = var.gitlab.enabled ? 1 : 0

    depends_on = [
      helm_release.gitlab_postgresql,
      helm_release.shared_redis,
    ]
    
    name = "gitlab"
    repository = "https://charts.gitlab.io/"
    chart = "gitlab"
    version = local.helm_gitlab_version

    timeout = 900
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = kubernetes_namespace.gitlab[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/gitlab/global.tpl.yaml", local.helm_gitlab_global_tpl_values)}",
        "${templatefile("helm_templates/gitlab/gitlab.tpl.yaml", local.helm_gitlab_gitlab_tpl_values)}",
        "${templatefile("helm_templates/gitlab/minio.tpl.yaml", local.helm_gitlab_minio_tpl_values)}",
    ]
}

// https://github.com/bitnami/charts/tree/master/bitnami/postgresql
resource "helm_release" "gitlab_postgresql" {
    
    count = var.gitlab.enabled ? 1 : 0
    
    name = "gitlab-postgresql"
    repository = "https://charts.bitnami.com/bitnami"
    chart = "postgresql"
    version = local.helm_postgresql_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = kubernetes_namespace.gitlab[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/postgresql.tpl.yaml", local.helm_gitlab_postgresql_tpl_values)}"
    ]
}

resource "kubernetes_secret" "gitlab_redis" {
    
    count = var.gitlab.enabled && var.k8s_shared.redis_authentication_enabled ? 1 : 0

    metadata {
        name = "gitlab-redis-credentials"
        namespace = kubernetes_namespace.gitlab[0].metadata[0].name
    }

    data = {
        "${local.gitlab_redis_secret_key}" = var.k8s_shared.redis_password
    }

    type = "Opaque"
}

resource "kubernetes_secret" "gitlab_saml_keycloak" {
    
    count = var.gitlab.enabled && var.gitlab.gitlab_saml_auth_enabled ? 1 : 0

    metadata {
        name = "gitlab-saml-keycloak"
        namespace = kubernetes_namespace.gitlab[0].metadata[0].name
    }

    data = yamldecode(templatefile("helm_templates/gitlab/omniauth_saml.tpl.yaml", local.helm_gitlab_omniauth_saml_keycloak_tpl_values))

    type = "Opaque"
}

locals {
    // Key as given by helm chart
    gitlab_postgresql_secret_name = "gitlab-postgresql"
    //gitlab_postgresql_secret_key = "postgresql-password"
    gitlab_postgresql_secret_key = "postgresql-postgres-password" // "postgres" user password
    gitlab_redis_secret_key = "redis-password"
    helm_gitlab_postgresql_tpl_values = {
        image_tag = var.gitlab.postgresql_image_tag
        database = var.gitlab.postgresql_database
        username = var.gitlab.postgresql_user
        password = var.gitlab.postgresql_password
        persistence_size = var.gitlab.postgresql_persistence_size
        persistence_storage_class = var.gitlab.postgresql_persistence_storage_class
        prometheus_enabled = tostring(var.gitea.postgresql_prometheus_enabled)
    }
    helm_gitlab_omniauth_saml_keycloak_tpl_values = {
        assertion_consumer_service_url = var.gitlab.gitlab_saml_assertion_consumer_service_url //"http://test-url.k8s.local"
        idp_cert_fingerprint = var.gitlab.gitlab_saml_idp_cert_fingerprint //"12:34:56..."
        idp_sso_target_url = var.gitlab.gitlab_saml_idp_sso_target_url //"http://idp-sso.k8s.local"
        issuer = var.gitlab.gitlab_saml_issuer //"gitlab"
    }
    helm_gitlab_global_tpl_values = {
        domain = var.gitlab.gitlab_domain
        namespace = var.gitlab.namespace
        database_svc_name = var.gitlab.enabled ? helm_release.gitlab_postgresql[0].name : ""
        database_name = var.gitlab.postgresql_database
        database_user = "postgres"
        database_password_secret_name = local.gitlab_postgresql_secret_name
        database_password_secret_key = local.gitlab_postgresql_secret_key
        redis_svc_name = format("%s-master", var.gitlab.enabled ? helm_release.shared_redis[0].metadata[0].name : "")
        redis_authentication_enabled = var.k8s_shared.redis_authentication_enabled
        redis_secret_name = var.k8s_shared.redis_authentication_enabled ? kubernetes_secret.gitlab_redis[0].metadata[0].name : ""
        redis_secret_key = local.gitlab_redis_secret_key
        providers = var.gitlab.gitlab_saml_auth_enabled ? [ kubernetes_secret.gitlab_saml_keycloak[0].metadata[0].name ] : []
    }
    helm_gitlab_gitlab_tpl_values = {
        persistence_storage_class = var.gitlab.gitaly_persistence_storage_class
        persistence_size = var.gitlab.gitaly_persistence_size
    }
    helm_gitlab_minio_tpl_values = {
        replicas = var.gitlab.minio_replicas
        persistence_storage_class = var.gitlab.minio_persistence_storage_class
        persistence_size = var.gitlab.minio_persistence_size
    }
}