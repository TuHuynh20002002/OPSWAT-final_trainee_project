################################################################################
# ACM certificate
################################################################################

output "acm_certificate_arn_be" {
  value      = aws_acm_certificate.tu-be.arn
  depends_on = [null_resource.delay]
}