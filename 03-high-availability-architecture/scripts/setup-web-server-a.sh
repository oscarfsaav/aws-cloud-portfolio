#!/bin/bash
# Servidor web A (eu-west-3a) - Amazon Linux 2023
# Instala Apache y publica una página que identifica el servidor.

sudo dnf update -y
sudo dnf install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Hola desde el Web Server A en la Zona eu-west-3a</h1>" | sudo tee /var/www/html/index.html
