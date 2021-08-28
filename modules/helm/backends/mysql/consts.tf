locals {
  helm_mysql_version = "8.8.4"
  secret_password_key = "mysql-password"

  mysql_secret_root_password_key = "mysql-root-password"
  mysql_secret_user_password_key = "mysql-password"
  mysql_secret_replication_password_key = "mysql-replication-password"
}
