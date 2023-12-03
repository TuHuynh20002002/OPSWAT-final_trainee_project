################################################################################
# ACM certificate
################################################################################

resource "aws_acm_certificate" "tu-be" {
  domain_name       = var.acm-domain_name
  validation_method = var.acm-validation_method

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "tu-be" {
  certificate_arn = aws_acm_certificate.tu-be.arn
  depends_on      = [aws_acm_certificate.tu-be]
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  triggers = {
    "before" = "${aws_acm_certificate_validation.tu-be.id}"
  }
}