// https://docs.gitlab.com/charts/

resource "helm_release" "gitlab" {
    
    count = var.gitlab.enabled ? 1 : 0

    depends_on = [
      helm_release.gitlab_postgresql,
      helm_release.shared_redis,
    ]
    
    name       = "gitlab"
    repository = "https://charts.gitlab.io/"
    chart      = "gitlab"
    version    = local.helm_gitlab_version

    timeout = 900
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.gitlab[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/gitlab/global.tpl.yaml", local.helm_gitlab_global_tpl_values)}",
        "${templatefile("helm_templates/gitlab/gitlab.tpl.yaml", local.helm_gitlab_gitlab_tpl_values)}",
        "${templatefile("helm_templates/gitlab/minio.tpl.yaml", local.helm_gitlab_minio_tpl_values)}",
    ]
}

// https://github.com/bitnami/charts/tree/master/bitnami/postgresql
resource "helm_release" "gitlab_postgresql" {
    
    count = var.gitlab.enabled ? 1 : 0
    
    name       = "gitlab-postgresql"
    repository = "https://charts.bitnami.com/bitnami"
    chart      = "postgresql"
    version    = local.helm_postgresql_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace  = kubernetes_namespace.gitlab[0].metadata[0].name

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

// https://github.com/bitnami/charts/tree/master/bitnami/postgresql
//// resource "helm_release" "gitlab_minio_operator" {
////     
////     count = var.gitlab.enabled ? 1 : 0
////     
////     name       = "gitlab-minio"
////     repository = "https://operator.min.io/"
////     chart      = "minio-operator"
////     version    = local.helm_minio_version
//// 
////     timeout = 300
////     cleanup_on_fail = true
////     wait = true
////     wait_for_jobs = true
//// 
////     namespace  = kubernetes_namespace.gitlab[0].metadata[0].name
//// 
////     values = [
////         "${templatefile("helm_templates/minio_operator.tpl.yaml", local.helm_gitlab_minio_operator_tpl_values)}"
////     ]
//// }

resource "kubernetes_secret" "gitlab_saml_keycloak" {
    
    count = var.gitlab.enabled && var.gitlab.gitlab_saml_auth_enabled ? 1 : 0

    metadata {
        name = "gitlab-saml-keycloak"
        namespace = kubernetes_namespace.gitlab[0].metadata[0].name
    }

    data = yamldecode(templatefile("helm_templates/gitlab/omniauth_saml.tpl.yaml", local.helm_gitlab_omniauth_saml_keycloak_tpl_values))

    type = "Opaque"
}

//// resource "kubernetes_secret" "gitlab_minio_tenant_creds_secret" {
////     
////     count = var.gitlab.enabled ? 1 : 0
//// 
////     metadata {
////         name = "gitlab-minio-creds-secret"
////         namespace = kubernetes_namespace.gitlab[0].metadata[0].name
////         labels = {
////             app = "gitlab"
////         }
////     }
//// 
////     data = {
////         accesskey = var.gitlab.minio_tenant_creds_access_key
////         secretkey = var.gitlab.minio_tenant_creds_secret_key
////     }
//// 
////   type = "Opaque"
//// }

// https://www.hashicorp.com/blog/deploy-any-resource-with-the-new-kubernetes-provider-for-hashicorp-terraform
// https://registry.terraform.io/providers/hashicorp/kubernetes-alpha/latest/docs/resources/kubernetes_manifest
// https://github.com/minio/operator/tree/master/examples
//// resource "kubernetes_manifest" "gitlab_minio_tenant" {
//// 
////     provider = kubernetes-alpha
////     
////     count = var.gitlab.enabled ? 1 : 0
////     depends_on = [ helm_release.gitlab_minio_operator[0] ]
//// 
////     manifest = {
////         apiVersion = "minio.min.io/v2"
////         kind = "Tenant"
////         metadata = {
////             name = "gitlab-minio"
////             namespace = kubernetes_namespace.gitlab[0].metadata[0].name
////             labels = {
////                 app = "gitlab"
////             }
////             annotations = merge(var.gitlab.minio_tenant_prometheus_enabled ? {
////                 "prometheus.io/path": "/minio/v2/metrics/cluster"
////                 "prometheus.io/port": "9000"
////                 "prometheus.io/scrape": "true"
////             } : {})
////         }
////         spec = {
////             image = "minio/minio:RELEASE.2021-06-17T00-10-46Z"
////             imagePullPolicy = "IfNotPresent"
//// 
////             credsSecret = {
////                 name = kubernetes_secret.gitlab_minio_tenant_creds_secret[0].metadata[0].name
////             }
//// 
////             pools = [{
////                 ## Servers specifies the number of MinIO Tenant Pods / Servers in this pool.
////                 ## For standalone mode, supply 1. For distributed mode, supply 4 or more.
////                 ## Note that the operator does not support upgrading from standalone to distributed mode.
////                 servers = var.gitlab.minio_tenant_replica_count
//// 
////                 ## volumesPerServer specifies the number of volumes attached per MinIO Tenant Pod / Server.
////                 volumesPerServer = var.gitlab.minio_tenant_volumes_per_server
//// 
////                 ## This VolumeClaimTemplate is used across all the volumes provisioned for MinIO Tenant in this
////                 ## Pool.
////                 volumeClaimTemplate = {
////                     metadata = {
////                         name = "gitlab-minio-tenant-data"
////                     }
////                     spec = {
////                         accessModes = [ "ReadWriteOnce" ]
////                         resources = {
////                             requests = {
////                                 storage = var.gitlab.minio_tenant_volume_size
////                             }
////                         }
////                     }
////                 }
//// 
////                 ## Configure security context
////                 securityContext = {
////                     runAsUser = 1000
////                     runAsGroup = 1000
////                     runAsNonRoot = true
////                     fsGroup = 1000
////                 }
////             }]
//// 
////             mountPath = "/export"
//// 
////             requestAutoCert = false
//// 
////             env = [{
////                     name = "MINIO_BROWSER"
////                     value = "off" # to turn-off browser
////                 }, {
////                     name = "MINIO_STORAGE_CLASS_STANDARD"
////                     value = "EC:2"
////                 },
////             ]
////         }
////         //status = {}
////     }
////     wait_for = {
////         fields = {
////             "status.availableReplicas" = var.gitlab.minio_tenant_replica_count
////             "status.currentState" = "Initialized"
////         }
////     }
//// }

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
    // helm_gitlab_minio_operator_tpl_values = {
    //     operator_replica_count = var.gitlab.minio_operator_operator_replica_count
    //     console_replica_count = var.gitlab.minio_operator_console_replica_count
    //     ingress_enabled = var.gitlab.minio_operator_ingress_enabled
    //     ingress_host = var.gitlab.minio_operator_ingress_host
    //     prometheus_enabled = var.gitlab.minio_operator_prometheus_enabled
    // }
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