################################################################################
# Getting data
################################################################################

data "aws_route53_zone" "opswat" {
  name = "devops-training.opswat.com"
}

data "aws_lb" "tu-abl" {
  name = "tu-cluster-alb"
}

################################################################################
# Route53: DNS for backend application
################################################################################

resource "aws_route53_record" "tu-be" {
  zone_id = data.aws_route53_zone.opswat.zone_id
  name    = "tu-be.devops-training.opswat.com"
  type    = "A"
  # ttl     = 300
  allow_overwrite = true
  # records = [data.aws_route53_zone.opswat.name]
  alias {
    name                   = data.aws_lb.tu-abl.dns_name
    zone_id                = data.aws_lb.tu-abl.zone_id
    evaluate_target_health = true
  }
}