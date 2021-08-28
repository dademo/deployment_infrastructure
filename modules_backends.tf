module "minio" {
  source = "./modules/helm/backends/minio"
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