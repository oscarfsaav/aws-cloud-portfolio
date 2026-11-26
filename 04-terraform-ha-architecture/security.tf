# --- Security group del balanceador: único punto de entrada desde Internet ---
resource "aws_security_group" "alb" {
  name        = "ha-alb-sg"
  description = "Trafico web publico hacia el ALB"
  vpc_id      = aws_vpc.main.id

  tags = { Name = "ha-alb-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP desde Internet"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTPS desde Internet"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

# El ALB solo puede hablar con los servidores web, por el puerto 80
resource "aws_vpc_security_group_egress_rule" "alb_to_web" {
  security_group_id            = aws_security_group.alb.id
  description                  = "HTTP hacia los servidores web"
  referenced_security_group_id = aws_security_group.web.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

# --- Security group de los servidores web: solo aceptan trafico del ALB ---
resource "aws_security_group" "web" {
  name        = "ha-web-sg"
  description = "Servidores web privados, solo accesibles desde el ALB"
  vpc_id      = aws_vpc.main.id

  tags = { Name = "ha-web-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "web_from_alb" {
  security_group_id            = aws_security_group.web.id
  description                  = "HTTP solo desde el security group del ALB"
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

# Salida libre: necesaria para instalar paquetes (via NAT) y para Systems Manager
resource "aws_vpc_security_group_egress_rule" "web_all_out" {
  security_group_id = aws_security_group.web.id
  description       = "Salida a Internet a traves del NAT"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}