locals {
  helm_superset_version = "0.3.6"
  postgresql_service_name = "superset-postgresql"
  postgresql_image_tag = "13.3.0"
  redis_service_name = "superset-redis"

  superset_secret_database_key = "database-password"
  superset_secret_redis_key = "redis-password"
}
