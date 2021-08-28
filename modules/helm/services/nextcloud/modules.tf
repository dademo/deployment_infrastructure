module "database_deployment" {
  source = "./../../backends/postgresql"
  count = var.deploy_postgresql ? 1 : 0

  namespace = var.namespace
  service_name = local.postgresql_service_name
  image_tag = local.postgresql_image_tag
  database = var.database
  database_password = var.database_password
  database_postgres_password = var.database_password
  prometheus_enabled = var.prometheus_enabled
}
