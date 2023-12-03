################################################################################
# Configure
################################################################################

variable "private_subnets_id" {
  description = ""
  type        = list(any)
  default     = []
}

################################################################################
# EKS cluster
################################################################################

variable "eks-cluster_role_name" {
  description = ""
  type        = string
  default     = "tu-cluster-role"
}

variable "eks-cluster_name" {
  description = ""
  type        = string
  default     = "tu-cluster"
}

################################################################################
# EKS node-group
################################################################################

variable "eks-node_role_name" {
  description = ""
  type        = string
  default     = "tu-eks-node-group"
}

variable "eks-node_group_name" {
  description = ""
  type        = string
  default     = "tu_node_group"
}

variable "eks-instance_types" {
  description = ""
  type        = string
  default     = "t3.small"
}