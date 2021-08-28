locals {
  helm_keycloak_version = "3.1.1"
  postgresql_service_name = "keycloak-postgresql"
  postgresql_image_tag = "13.3.0"

  keycloak_secret_admin_password_key = "admin-password"
  keycloak_secret_management_password_key = "management-password"
  keycloak_secret_database_key = "database-password"
}
