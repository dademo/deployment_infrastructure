locals {
  helm_mariadb_version = "9.4.2"
  secret_password_key = "mariadb-password"

  mariadb_secret_root_password_key = "mariadb-root-password"
  mariadb_secret_user_password_key = "mariadb-password"
  mariadb_secret_replication_password_key = "mariadb-replication-password"
}
