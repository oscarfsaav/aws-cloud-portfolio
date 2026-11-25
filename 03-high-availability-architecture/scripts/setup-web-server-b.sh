#!/bin/bash
# Servidor web B (eu-west-3b) - Amazon Linux 2023
# Instala Apache y publica una página que identifica el servidor.

sudo dnf update -y
sudo dnf install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Hola desde el Web Server B en la Zona eu-west-3b</h1>" | sudo tee /var/www/html/index.html
