################################################################################
# S3 bucket configure
################################################################################

variable "s3-bucket_name" {
  description = ""
  type        = string
  default     = "tu-trainee-bucket"
}

variable "s3-force_destroy" {
  description = ""
  type        = bool
  default     = true
}