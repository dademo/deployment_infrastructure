locals {
  helm_rabbitmq_version = "8.20.4"

  rabbitmq_secret_admin_password_key = "rabbitmq-password"
  rabbitmq_secret_erlang_cookie_password_key = "rabbitmq-erlang-cookie"
}
