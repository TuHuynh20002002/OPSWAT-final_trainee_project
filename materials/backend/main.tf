################################################################################
# Networking
################################################################################

module "networking" {
  source = "./modules/networking"
}

################################################################################
# ACM certificate
################################################################################

module "acm" {
  source = "./modules/ACM"
}


################################################################################
# Container image
################################################################################

module "image" {
  source = "./modules/image"
}

# data "aws_ecr_repository" "image" {
#   name = var.ecr-image_name
# }

################################################################################
# Helm aws configuration
################################################################################

resource "null_resource" "helm_aws_modfiy" {
  provisioner "local-exec" {
    when        = create
    command     = "./scripts/helm.sh"
    interpreter = ["sh"]
    working_dir = path.module
    environment = {
      CONTAINER_IMAGE = module.image.image
      # CONTAINER_IMAGE = "${data.aws_ecr_repository.image.url}:latest"
      ACM_ARN = module.acm.acm_certificate_arn_be

      USERNAME = base64encode(var.image_username)
      PASSWORD = base64encode(var.image_password)
      HOST     = var.image_host
      PORT     = var.image_port
      DATABASE = var.image_database
    }
  }
}

################################################################################
# EKS
################################################################################

module "eks" {
  source             = "./modules/EKS"
  private_subnets_id = module.networking.private_subnets_id
  depends_on         = [null_resource.helm_aws_modfiy, module.networking]
}

################################################################################
# Route 53: DNS for backend application
################################################################################

module "route53" {
  source     = "./modules/route53"
  depends_on = [module.eks]
}