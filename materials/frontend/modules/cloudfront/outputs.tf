################################################################################
# Cloudfront
################################################################################

output "cloudfront-alias_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront-alias_hosted_zone_id" {
  value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}