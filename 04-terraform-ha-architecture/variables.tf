variable "region" {
  description = "Región de AWS donde se despliega la infraestructura"
  type        = string
  default     = "eu-west-3"
}


variable "vpc_cidr" {
  description = "Rango de direcciones IPv4 de la VPC"
  type        = string
  default     = "10.16.0.0/16"
}

variable "azs" {
  description = "Zonas de disponibilidad donde se reparte la infraestructura"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}


variable "nat_per_az" {
  description = "true = un NAT Gateway por zona (resiliente, más caro); false = uno solo (más barato)"
  type        = bool
  default     = false
}


variable "instance_type" {
  description = "Tipo de instancia EC2 de los servidores web"
  type        = string
  default     = "t2.micro"
}


variable "domain_name" {
  description = "Dominio registrado, con zona alojada en Route 53"
  type        = string
  default     = "oscarfragueiro.com"
}

variable "subdomain" {
  description = "Subdominio donde se publica esta arquitectura"
  type        = string
  default     = "ha"
}