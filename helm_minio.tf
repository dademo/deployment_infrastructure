// https://github.com/minio/operator/tree/master/helm/minio-operator

resource "helm_release" "minio_operator" {
    
    count = var.minio.enabled ? 1 : 0
    
    name = "minio"
    repository = "https://operator.min.io/"
    chart = "minio-operator"
    version = local.helm_minio_version

    timeout = 300
    cleanup_on_fail = true
    wait = true
    wait_for_jobs = true

    namespace = kubernetes_namespace.minio[0].metadata[0].name

    values = [
        "${templatefile("helm_templates/minio_operator.tpl.yaml", local.helm_minio_operator_tpl_values)}"
    ]
}

resource "kubernetes_secret" "minio_tenant_creds_secret" {
    
    count = var.minio.enabled ? 1 : 0

    metadata {
        name = "minio-creds-secret"
        namespace = kubernetes_namespace.minio[0].metadata[0].name
    }

    data = {
        accesskey = var.minio.tenant_creds_access_key
        secretkey = var.minio.tenant_creds_secret_key
    }
    
    type = "Opaque"
}

// https://www.hashicorp.com/blog/deploy-any-resource-with-the-new-kubernetes-provider-for-hashicorp-terraform
// https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest
// https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/guides/alpha-manifest-migration-guide
// https://github.com/minio/operator/tree/master/examples
//// resource "kubernetes_manifest" "minio_tenant" {
////     
////     count = var.minio.enabled ? 1 : 0
////     depends_on = [ helm_release.minio_operator[0] ]
//// 
////     manifest = yamldecode(templatefile("manifest_templates/minio_tenant.tpl.yaml", local.minio_tenant_tpl_values))
////     
////     wait_for = {
////         fields = {
////             "status.availableReplicas" = var.minio.tenant_replica_count
////             "status.currentState" = "Initialized"
////         }
////     }
//// }

locals {
    helm_minio_operator_tpl_values = {
        operator_replica_count = var.minio.operator_operator_replica_count
        console_replica_count = var.minio.operator_console_replica_count
        ingress_enabled = var.minio.operator_ingress_enabled
        ingress_host = var.minio.operator_ingress_host
        prometheus_enabled = var.minio.operator_prometheus_enabled
    }
    minio_tenant_tpl_values = {
        name = var.minio.tenant_name
        namespace = var.minio.namespace
        creds_secret = var.minio.enabled ? kubernetes_secret.minio_tenant_creds_secret[0].metadata[0].name : ""
        name = var.minio.tenant_name
        replica_count = var.minio.tenant_replica_count
        volumes_per_server = var.minio.tenant_volumes_per_server
        volume_size = var.minio.tenant_volume_size
        prometheus_enabled = var.minio.tenant_prometheus_enabled
    }
}

