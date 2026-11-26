locals {
  fqdn = "${var.subdomain}.${var.domain_name}"
}

# --- Zona de Route 53 que ya existe (la del proyecto 02) ---
data "aws_route53_zone" "main" {
  name = var.domain_name
}

# --- Certificado de ACM para el subdominio (en la region del ALB) ---
resource "aws_acm_certificate" "web" {
  domain_name       = local.fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# --- Registro DNS que demuestra que el dominio es tuyo (validacion) ---
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.web.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

# --- Espera a que ACM confirme que el certificado esta emitido ---
resource "aws_acm_certificate_validation" "web" {
  certificate_arn         = aws_acm_certificate.web.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

# --- ha.oscarfragueiro.com apunta al balanceador ---
resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.fqdn
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}