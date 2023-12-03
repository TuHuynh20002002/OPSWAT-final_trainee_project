################################################################################
# ACM certificate
################################################################################

resource "aws_acm_certificate" "tu-fe" {
  provider          = aws.virginia
  domain_name       = var.acm-domain_name
  validation_method = var.acm-validation_method

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "tu-fe" {
  provider        = aws.virginia
  certificate_arn = aws_acm_certificate.tu-fe.arn
  depends_on      = [aws_acm_certificate.tu-fe]
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  triggers = {
    "before" = "${aws_acm_certificate_validation.tu-fe.id}"
  }
}