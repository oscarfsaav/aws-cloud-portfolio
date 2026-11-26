#!/bin/bash
# Se ejecuta una vez, al arrancar cada servidor nuevo (Amazon Linux 2023)
dnf install -y httpd
systemctl enable --now httpd

# Pregunta a AWS (metadatos, IMDSv2) cual es el ID de la instancia y su zona
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat > /var/www/html/index.html <<EOF
<h1>Hola desde la instancia $INSTANCE_ID</h1>
<p>Zona de disponibilidad: $AZ</p>
EOF