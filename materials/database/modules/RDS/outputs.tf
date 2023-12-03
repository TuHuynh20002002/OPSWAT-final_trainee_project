################################################################################
# RDS
################################################################################

locals {
  host     = aws_db_instance.database.address
  dbname   = var.rds-db_name
  username = var.rds-username
  password = random_password.password.result
  port     = aws_db_instance.database.port
}

output "rds_username" {
  value = local.username
}

output "rds_password" {
  value = local.password
}

output "rds_host" {
  value = local.host
}

output "rds_port" {
  value = local.port
}

output "rds_database" {
  value = local.dbname
}