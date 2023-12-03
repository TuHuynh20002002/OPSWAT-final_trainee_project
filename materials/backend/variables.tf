################################################################################
# Configure
################################################################################

variable "image_username" {
  description = ""
  type        = string
  default     = "postgres"
}

variable "image_password" {
  description = ""
  type        = string
  default     = "admin"
}

variable "image_host" {
  description = ""
  type        = string
  default     = "localhost"
}

variable "image_port" {
  description = ""
  type        = number
  default     = 5432
}

variable "image_database" {
  description = ""
  type        = string
  default     = "perntodo"
}

################################################################################
# Image
################################################################################

variable "ecr-image_name" {
  description = ""
  type        = string
  default     = "tu-todo-image"
}

