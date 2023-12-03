################################################################################
# S3 bucket static web
################################################################################

output "s3_bucket_website_endpoint" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}