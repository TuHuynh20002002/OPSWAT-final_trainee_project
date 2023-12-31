################################################################################
# ECR repo
################################################################################

output "repository_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.repo.arn
}

################################################################################
# ECR image
################################################################################

output "image" {
  value = "${local.url}/${local.tag}"
}