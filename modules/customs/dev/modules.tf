module "postgresql_deployment" {
    source = "../../helm/postgresql"
    count = var.postgresql.enabled ? 1 : 0
  
    namespace = var.namespace
    service_name = local.postgresql_service_name
    image_tag = var.postgresql_image_tag
    database = var.postgresql.service
    database_password = var.postgresql_password
    prometheus_enabled = var.prometheus_enabled
}

module "kafka_deployment" {
    source = "../../helm/kafka"
    count = var.kafka.enabled ? 1 : 0
  
    namespace = var.namespace
    service_name = local.kafka_service_name
    service = var.kafka.service
    prometheus_enabled = var.prometheus_enabled
}

module "spark_deployment" {
    source = "../../helm/spark"
    count = var.spark.enabled ? 1 : 0
  
    namespace = var.namespace
    service_name = local.spark_service_name
    service = var.spark.service
    prometheus_enabled = var.prometheus_enabled
}

module "redis_deployment" {
    source = "../../helm/redis"
    count = var.redis.enabled ? 1 : 0
  
    namespace = var.namespace
    service_name = local.redis_service_name
    service = var.redis.service
    redis_password = var.redis_password
    prometheus_enabled = var.prometheus_enabled
}
