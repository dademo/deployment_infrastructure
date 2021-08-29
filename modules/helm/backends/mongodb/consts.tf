locals {
  helm_mongodb_version = "10.23.13"

  mongodb_secret_user_password_key = "mongodb-password"
  mongodb_secret_root_password_key = "mongodb-root-password"
  mongodb_secret_replicaset_password_key = "mongodb-replica-set-key"
}
