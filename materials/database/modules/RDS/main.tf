################################################################################
# Data
################################################################################

data "aws_kms_alias" "kms_key" {
  name = "alias/aws/rds"
}

# data "aws_vpc" "vpc" {
#   tags = {
#     Name = "tu-trainee-vpc"
#   }
# }

################################################################################
# KMS 
################################################################################

# resource "aws_kms_key" "kms_key" {
#   description             = "kms-key for final exam"
#   deletion_window_in_days = 10

#   tags = {
#     "Name" = "tu-trainee-db"
#   }
# }

# resource "aws_kms_alias" "kms_alias" {
#   name          = "alias/tu-trainee-key"
#   target_key_id = aws_kms_key.kms_key.key_id
# }

################################################################################
# Random password
################################################################################

resource "random_password" "password" {
  length  = 16
  special = false
  # override_special = "%@"
  # upper = false
}

resource "random_password" "random_name" {
  length  = 4
  special = false
  upper   = false
}

################################################################################
# RDS
################################################################################

resource "aws_db_instance" "database" {
  # vpc_security_group_ids = [data.aws_vpc.vpc.id]
  identifier           = "${var.rds-name}-db-${random_password.random_name.result}"
  allocated_storage    = var.rds-allocated_storage
  storage_type         = var.rds-storage_type
  db_name              = var.rds-db_name
  engine               = var.rds-engine
  engine_version       = var.rds-engine_version
  instance_class       = var.rds-instance_class
  username             = var.rds-username
  password             = random_password.password.result
  kms_key_id           = data.aws_kms_alias.kms_key.target_key_arn
  port                 = var.rds-port
  parameter_group_name = var.rds-parameter_group_name
  skip_final_snapshot  = var.rds-skip_final_snapshot
  publicly_accessible  = var.rds-publicly_accessible
  storage_encrypted    = var.rds-storage_encrypted
}

locals {
  secrets = jsonencode({
    host       = aws_db_instance.database.address
    identifier = "${var.rds-name}-db-${random_password.random_name.result}"
    dbname     = var.rds-db_name
    username   = var.rds-username
    password   = random_password.password.result
    port       = aws_db_instance.database.port
  })
}

################################################################################
# Secret manager
################################################################################

resource "aws_secretsmanager_secret" "secret" {
  name = "tu-trainee-secret-${random_password.random_name.result}"
  # kms_key_id = aws_kms_alias.kms_alias.id
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = local.secrets
}

################################################################################
# Create table
################################################################################

resource "null_resource" "create_table" {
  provisioner "local-exec" {
    when    = create
    command = "sh ./scripts/create_database.sh"
    environment = {
      HOST       = aws_db_instance.database.address
      PORT       = var.rds-port
      USERNAME   = var.rds-username
      DATABASE   = var.rds-db_name
      PGPASSWORD = random_password.password.result
    }
    working_dir = path.module
  }

  depends_on = [aws_db_instance.database, aws_secretsmanager_secret_version.secret]
}