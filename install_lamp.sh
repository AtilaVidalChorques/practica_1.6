#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root (sudo)."
  exit 1
fi

echo "Actualizando paquetes del sistema..."
apt update && apt upgrade -y

echo "Instalando Apache..."
apt install apache2 -y
systemctl enable apache2
systemctl start apache2

echo "Instalando MySQL (MariaDB)..."
apt install mariadb-server mariadb-client -y
systemctl enable mariadb
systemctl start mariadb

echo "Ejecutando configuración segura de MariaDB..."
mysql_secure_installation

echo "Instalando PHP y módulos comunes..."
apt install php libapache2-mod-php php-mysql php-cli php-curl php-gd php-xml php-mbstring -y

systemctl restart apache2

echo "Creando archivo de prueba PHP..."
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
chown www-data:www-data /var/www/html/info.php

echo "Instalación completada."
echo "Puedes verificar Apache en: http://localhost"
echo "Y la configuración de PHP en: http://localhost/info.php"
