#!/bin/bash
echo "Iniciando instalación de WordPress en el directorio raíz..."

# --- 1. DESCARGA Y DESCOMPRESIÓN ---
# Descargar WordPress y mover archivos a /var/www/html
wget https://wordpress.org/latest.tar.gz -P /tmp
tar -xzvf /tmp/latest.tar.gz -C /tmp
sudo mv -f /tmp/wordpress/* /var/www/html

# --- 2. CREACIÓN DE BASE DE DATOS Y USUARIO ---
# Nota: La sintaxis '<<< "..."' canaliza el comando a mysql.
echo "Creando base de datos y usuario en MariaDB..."
sudo mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME;"
sudo mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME;"
sudo mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL;"
sudo mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD';"
sudo mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL;"

# --- 3. CONFIGURACIÓN DE wp-config.php ---
# Copiar el archivo de configuración de ejemplo
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Reemplazar valores de conexión a la base de datos usando sed
echo "Configurando wp-config.php..."
sudo sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
sudo sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
sudo sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
sudo sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php

# --- 4. CONFIGURACIÓN DE SECURITY KEYS ---
echo "Generando y añadiendo Security Keys..."
# Eliminar las claves por defecto
sudo sed -i "/define('AUTH_KEY'/d" /var/www/html/wp-config.php
sudo sed -i "/define('SECURE_AUTH_KEY'/d" /var/www/html/wp-config.php
sudo sed -i "/define('LOGGED_IN_KEY'/d" /var/www/html/wp-config.php
sudo sed -i "/define('NONCE_KEY'/d" /var/www/html/wp-config.php
sudo sed -i "/define('AUTH_SALT'/d" /var/www/html/wp-config.php
sudo sed -i "/define('SECURE_AUTH_SALT'/d" /var/www/html/wp-config.php
sudo sed -i "/define('LOGGED_IN_SALT'/d" /var/www/html/wp-config.php
sudo sed -i "/define('NONCE_SALT'/d" /var/www/html/wp-config.php

# Obtener nuevas claves y limpiar el caracter '/'
SECURITY_KEYS=$(curl https://api.wordpress.org/secret-key/1.1/salt/)
SECURITY_KEYS=$(echo $SECURITY_KEYS | tr / _)

# Insertar las nuevas claves generadas antes del bloque "table prefix"
sudo sed -i "/@-/a $SECURITY_KEYS" /var/www/html/wp-config.php

# --- 5. PERMISOS Y ENLACES PERMANENTES ---
# Dar propiedad a Apache para que pueda escribir archivos (plugins, uploads)
echo "Ajustando permisos..."
sudo chown -R www-data:www-data /var/www/html/

# Habilitar mod_rewrite y reiniciar Apache (asumiendo que .htaccess se crea aparte)
echo "Habilitando mod_rewrite y reiniciando Apache..."
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "✅ Instalación de WordPress en el directorio raíz completada."
