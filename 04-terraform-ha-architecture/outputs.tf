output "alb_dns_name" {
  description = "Direccion DNS publica del balanceador"
  value       = aws_lb.main.dns_name
}


output "site_url" {
  description = "Direccion publica con HTTPS"
  value       = "https://${local.fqdn}"
}