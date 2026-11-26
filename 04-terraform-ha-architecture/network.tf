# --- VPC ---
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "ha-vpc" }
}

# --- Puerta de la VPC hacia Internet ---
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = { Name = "ha-igw" }
}

# --- Subredes públicas (una por zona): aquí vivirá el balanceador ---
resource "aws_subnet" "public" {
  count = length(var.azs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = { Name = "ha-public-${var.azs[count.index]}" }
}

# --- Subredes privadas (una por zona): aquí vivirán los servidores web ---
resource "aws_subnet" "private" {
  count = length(var.azs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone = var.azs[count.index]

  tags = { Name = "ha-private-${var.azs[count.index]}" }
}


# --- Cuántos NAT Gateways se crean según la variable nat_per_az ---
locals {
  nat_count = var.nat_per_az ? length(var.azs) : 1
}

# --- IP elástica fija para cada NAT Gateway ---
resource "aws_eip" "nat" {
  count  = local.nat_count
  domain = "vpc"

  tags = { Name = "ha-nat-eip-${count.index + 1}" }
}

# --- NAT Gateways (viven en subredes públicas) ---
resource "aws_nat_gateway" "main" {
  count = local.nat_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = { Name = "ha-nat-${count.index + 1}" }

  depends_on = [aws_internet_gateway.main]
}

# --- Tabla de rutas pública: todo el tráfico a Internet por el IGW ---
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = { Name = "ha-public-rt" }
}

resource "aws_route_table_association" "public" {
  count = length(var.azs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# --- Tablas de rutas privadas (una por zona): salida a Internet por el NAT ---
resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[var.nat_per_az ? count.index : 0].id
  }

  tags = { Name = "ha-private-rt-${var.azs[count.index]}" }
}

resource "aws_route_table_association" "private" {
  count = length(var.azs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

