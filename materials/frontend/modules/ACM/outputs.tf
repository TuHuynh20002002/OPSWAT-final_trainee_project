################################################################################
# ACM certificate
################################################################################

output "acm_certificate_arn_fe" {
  value      = aws_acm_certificate.tu-fe.arn
  depends_on = [null_resource.delay]
}