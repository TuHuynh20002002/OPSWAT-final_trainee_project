################################################################################
# RDS parameters
################################################################################

locals {
  host     = module.RDS.rds_host
  dbname   = module.RDS.rds_database
  username = module.RDS.rds_username
  password = module.RDS.rds_password
  port     = module.RDS.rds_port
}

output "database_username" {
  value = local.username
}

output "database_password" {
  value = local.password
}

output "database_host" {
  value = local.host
}

output "database_port" {
  value = local.port
}

output "database_database" {
  value = local.dbname
}