################################################################################
# Database
################################################################################

module "database" {
  source = "./materials/database"
}


################################################################################
# Backend
################################################################################

module "backend" {
  source         = "./materials/backend"
  image_username = module.database.database_username
  image_password = module.database.database_password
  image_host     = module.database.database_host
  image_port     = module.database.database_port
  image_database = module.database.database_database
}

################################################################################
# Frontend
################################################################################

module "frontend" {
  source = "./materials/frontend"
}


