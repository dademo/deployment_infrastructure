module "dev" {
  source = "./modules/customs/dev"
  count = var.module_dev.enabled ? 1 : 0
  depends_on = [
    kubernetes_namespace.namespace["dev"]
  ]

  // Variables
  namespace = var.module_dev.namespace
  postgresql = var.module_dev.postgresql
  mysql = var.module_dev.mysql
  mariadb = var.module_dev.mariadb
  mongodb = var.module_dev.mongodb
  kafka = var.module_dev.kafka
  spark = var.module_dev.spark
  redis = var.module_dev.redis
  rabbitmq = var.module_dev.rabbitmq
  postgresql_password = var.module_dev_postgresql_password
  postgresql_postgres_password = var.module_dev_postgresql_postgres_password
  mysql_root_password = var.module_dev_mysql_root_password
  mysql_password = var.module_dev_mysql_password
  mysql_replication_password = var.module_dev_mysql_replication_password
  mariadb_root_password = var.module_dev_mysql_root_password
  mariadb_password = var.module_dev_mysql_password
  mariadb_replication_password = var.module_dev_mysql_replication_password
  mongodb_root_password = var.module_dev_mongodb_root_password
  mongodb_password = var.module_dev_mongodb_password
  mongodb_replicaset_password = var.module_dev_mongodb_replicaset_password
  postgresql_image_tag = var.module_dev_postgresql_image_tag
  redis_password = var.module_dev_redis_password
  rabbitmq_password = var.module_dev_rabbitmq_password
}
