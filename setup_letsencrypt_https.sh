#!/bin/bash

# Este script instala Certbot y configura SSL/TLS para el dominio.

# Comprobar que la variable de dominio esté definida
if [ -z "$CERTIFICATE_DOMAIN" ]; then
    echo "ERROR: \$CERTIFICATE_DOMAIN no está definida. Abortando."
    exit 1
fi

# 1. Instalar Certbot y plugin de Apache
sudo apt update -y
sudo apt install -y certbot python3-certbot-apache

# 2. Solicitar e instalar certificado SSL/TLS (reemplaza el email)
sudo certbot --apache -d "$CERTIFICATE_DOMAIN" \
    --non-interactive \
    --agree-tos \
    --redirect \
    -m "tu.correo@ejemplo.com"

# 3. Reiniciar Apache para aplicar los cambios
sudo systemctl restart apache2
