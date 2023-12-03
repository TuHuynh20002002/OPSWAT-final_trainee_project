################################################################################
# Configure
################################################################################

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "tu-trainee"
}

variable "region-virginia" {
  description = "Region in US East Virginia"
  type        = string
  default     = "us-east-1"
}

variable "region-oregon" {
  description = "Region in US West Oregon"
  type        = string
  default     = "us-west-2"
}

################################################################################
# VPC
################################################################################

variable "vpc-name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "tu-trainee-vpc"
}

variable "vpc-cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc-instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "vpc-enable_ipv6" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block"
  type        = bool
  default     = false
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

################################################################################
# Subnets
################################################################################

variable "subnet-public_subnet_count" {
  description = "Number of desired public subnets"
  type        = number
  default     = 3
}

variable "subnet-public_subnet_tags" {
  description = "Additional tags for the public route tables"
  type        = map(string)
  default     = {}
}

variable "subnet-private_subnet_count" {
  description = "Number of desired private subnets"
  type        = number
  default     = 3
}

variable "subnet-private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "eks-cluster_name" {
  description = ""
  type        = string
  default     = "tu-cluster"
}