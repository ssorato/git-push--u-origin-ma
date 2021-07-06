data "aws_route53_zone" "myzone" {
  name = "${var.route53_hosted_zone}."
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.myzone.id
  name    = "ecs"
  type    = "A"

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}