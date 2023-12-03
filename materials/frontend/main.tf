################################################################################
# S3: static web
################################################################################

module "s3" {
  source = "./modules/s3"
}

################################################################################
# ACM certificate
################################################################################

module "acm" {
  source = "./modules/ACM"
}

################################################################################
# Cloudfront
################################################################################

module "cloudfront" {
  source                     = "./modules/cloudfront"
  acm-acm_certificate_arn    = module.acm.acm_certificate_arn_fe
  s3_bucket_website_endpoint = module.s3.s3_bucket_website_endpoint
}

################################################################################
# Route53
################################################################################

module "route53" {
  source                 = "./modules/route53"
  route53-alias_name     = module.cloudfront.cloudfront-alias_name
  route53-hosted_zone_id = module.cloudfront.cloudfront-alias_hosted_zone_id
}


