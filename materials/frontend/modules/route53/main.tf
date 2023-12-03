################################################################################
# Route 53: DNS for frontend application
################################################################################

data "aws_route53_zone" "opswat" {
  name = "devops-training.opswat.com"
}

resource "aws_route53_record" "tu-fe" {
  zone_id = data.aws_route53_zone.opswat.zone_id
  name    = "tu-fe.devops-training.opswat.com"
  type    = "A"
  # ttl     = 300
  allow_overwrite = true
  # records = [data.aws_route53_zone.opswat.name]
  alias {
    name                   = var.route53-alias_name
    zone_id                = var.route53-hosted_zone_id
    evaluate_target_health = true
  }
}