locals {
    // Shared
    helm_postgresql_version = "10.4.5"
    helm_redis_version = "14.6.3"
    helm_minio_version = "4.1.6"
    // Specific components
    helm_gitea_version = "3.0.0"
    helm_gitlab_version = "5.0.2"
    helm_jenkins_version = "3.4.0"
    helm_keycloak_version = "3.1.1"
    helm_nexus_version = "29.2.0"
    helm_prometheus_version = "14.3.0"
    helm_grafana_version = "6.13.6"
    helm_dokuwiki_version = "11.1.15"
    helm_nextcloud_version = "2.6.5"
    helm_kafka_version = "14.0.1"
    helm_spark_version = "5.7.1"
    helm_mailu_version = "0.1.2"
}
