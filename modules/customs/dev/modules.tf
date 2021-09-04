module "postgresql_deployment" {
  source = "./../../helm/backends/postgresql"
  count = var.postgresql.enabled ? 1 : 0

  namespace = var.namespace
  service_name = local.postgresql_service_name
  image_tag = var.postgresql_image_tag
  database = var.postgresql.service
  database_postgres_password = var.postgresql_postgres_password
  database_password = var.postgresql_password
  prometheus_enabled = var.prometheus_enabled
}

module "mysql_deployment" {
  source = "./../../helm/backends/mysql"
  count = var.mysql.enabled ? 1 : 0

  namespace = var.namespace
  service_name = local.mysql_service_name
  database = var.mysql.service
  database_root_password = var.mysql_root_password
  database_password = var.mysql_password
  database_replication_password = var.mysql_replication_password
  prometheus_enabled = var.prometheus_enabled
}

module "mariadb_deployment" {
  source = "./../../helm/backends/mariadb"
  count = var.mariadb.enabled ? 1 : 0

  namespace = var.namespace
  service_name = local.mariadb_service_name
  database = var.mariadb.service
  database_root_password = var.mariadb_root_password
  database_password = var.mariadb_password
  database_replication_password = var.mariadb_replication_password
  prometheus_enabled = var.prometheus_enabled
}

module "mongodb_deployment" {
  source = "./../../helm/backends/mongodb"
  count = var.mongodb.enabled ? 1 : 0

  namespace = var.namespace
  service_name = local.mongodb_service_name
  database = var.mongodb.service
  mongodb_password = var.mongodb_password
  mongodb_root_password = var.mongodb_root_password
  mongodb_replicaset_password = var.mongodb_replicaset_password
  prometheus_enabled = var.prometheus_enabled
}

module "kafka_deployment" {
  source = "./../../helm/backends/kafka"
  count = var.kafka.enabled ? 1 : 0

  namespace = var.namespace
  service_name = local.kafka_service_name
  service = var.kafka.service
  prometheus_enabled = var.prometheus_enabled
}

module "spark_deployment" {
  source = "./../../helm/backends/spark"
  count = var.spark.enabled ? 1 : 0

  namespace = var.namespace
  service_name = local.spark_service_name
  service = var.spark.service
  prometheus_enabled = var.prometheus_enabled
}

module "redis_deployment" {
  source = "./../../helm/backends/redis"
  count = var.redis.enabled ? 1 : 0

  namespace = var.namespace
  service_name = local.redis_service_name
  service = var.redis.service
  redis_password = var.redis_password
  prometheus_enabled = var.prometheus_enabled
}

module "rabbitmq_deployment" {
  source = "./../../helm/backends/rabbitmq"
  count = var.rabbitmq.enabled ? 1 : 0

  namespace = var.namespace
  service_name = local.rabbitmq_service_name
  service = var.rabbitmq.service
  rabbitmq_password = var.rabbitmq_password
  prometheus_enabled = var.prometheus_enabled
}

module "elastic_deployment" {
  source = "./../../helm/services/elastic"
  count = var.elastic.enabled ? 1 : 0

  namespace = var.namespace
  service_name = local.elastic_service_name
  elasticsearch = var.elastic.elasticsearch
  kibana = var.elastic.kibana
  apm = var.elastic.apm
  filebeat = var.elastic.filebeat
  logstash = var.elastic.logstash
  metricbeat = var.elastic.metricbeat
}
