################################################################################
# Data
################################################################################

locals {
  s3_origin_id = "myS3-Origin-unique"
}

# Find a certificate that is issued
# data "aws_acm_certificate" "tu-fe" {
#   domain   = "tu-fe.devops-training.opswat.com"
# }

# data "aws_s3_bucket" "bucket" {
#   bucket = "tu-trainee-bucket"
# }


################################################################################
# Cloudfront
################################################################################

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.s3_bucket_website_endpoint
    origin_id   = local.s3_origin_id
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      # "If the origin is an Amazon S3 bucket, CloudFront alays uses TLSv1.2."
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn            = var.acm-acm_certificate_arn
    # acm_certificate_arn            = data.aws_acm_certificate.tu-fe.arn
    ssl_support_method = "sni-only"
  }

  aliases = ["tu-fe.devops-training.opswat.com"]

}

