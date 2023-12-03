################################################################################
# ACM certificate
################################################################################

variable "acm-domain_name" {
  description = ""
  type        = string
  default     = "tu-fe.devops-training.opswat.com"
}

variable "acm-validation_method" {
  description = ""
  type        = string
  default     = "DNS"
}

