################################################################################
# RDS configure
################################################################################

variable "rds-name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "tu-trainee"
}

variable "rds-allocated_storage" {
  description = ""
  type        = number
  default     = 20
}

variable "rds-storage_type" {
  description = ""
  type        = string
  default     = "gp2"
}

variable "rds-db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = "perntodo"
}

variable "rds-engine" {
  description = ""
  type        = string
  default     = "postgres"
}

variable "rds-engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "14.7"
}

variable "rds-instance_class" {
  description = ""
  type        = string
  default     = "db.t3.micro"
}

variable "rds-username" {
  description = ""
  type        = string
  default     = "postgres"
}

variable "rds-port" {
  description = ""
  type        = number
  default     = 5432
}

variable "rds-storage_encrypted" {
  description = ""
  type        = bool
  default     = true
}

variable "rds-parameter_group_name" {
  description = ""
  type        = string
  default     = "default.postgres14"
}

variable "rds-manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager. Cannot be set if password is provided"
  type        = bool
  default     = true
}

variable "rds-skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true
}

variable "rds-publicly_accessible" {
  description = ""
  type        = bool
  default     = true
}
