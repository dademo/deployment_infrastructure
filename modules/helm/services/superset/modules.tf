module "database_deployment" {
  source = "./../../backends/postgresql"
  count = var.deploy_postgresql ? 1 : 0

  namespace = var.namespace
  service_name = local.postgresql_service_name
  image_tag = local.postgresql_image_tag
  database = var.database
  database_postgres_password = var.database_password
  database_password = var.database_password
  prometheus_enabled = var.prometheus_enabled
}

module "redis_deployment" {
  source = "./../../backends/redis"
  count = var.deploy_redis ? 1 : 0

  namespace = var.namespace
  service_name = local.redis_service_name
  service = var.redis
  redis_password = local.generate_redis_password ? random_password.redis_password[0].result : var.redis_password
  prometheus_enabled = var.prometheus_enabled
}
