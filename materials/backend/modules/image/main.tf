################################################################################
# ECR container image repo
################################################################################

resource "aws_ecr_repository" "repo" {
  name                 = var.image-image_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }
}

locals {
  url            = split("/", aws_ecr_repository.repo.repository_url)[0]
  repository_url = aws_ecr_repository.repo.repository_url
  image_name     = aws_ecr_repository.repo.name
  tag            = "${aws_ecr_repository.repo.name}:v1"
}

################################################################################
# Build and upload image
################################################################################

resource "null_resource" "build_and_upload" {
  provisioner "local-exec" {
    when    = create
    command = <<-EOT
        aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ${local.url}
        docker build -t ${local.url}/${local.tag} ./server/. 
        docker push ${local.url}/${local.tag}
      EOT

    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
  }

  triggers = {
    image = "${local.url}/${local.tag}"
  }

  provisioner "local-exec" {
    when        = destroy
    command     = <<EOT
      docker image rm --force ${self.triggers.image}
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
