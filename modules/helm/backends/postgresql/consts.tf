locals {
  helm_postgresql_version = "10.4.5"

  postgresql_secret_postgres_password_key = "postgresql-postgres-password"
  postgresql_secret_user_password_key = "postgresql-password"
}
