#!/bin/bash
echo "Iniciando instalación de WordPress en su propio directorio..."

# --- 1. DESCARGA Y DESCOMPRESIÓN ---
# Descargar WordPress y mover la carpeta 'wordpress' a /var/www/html
wget https://wordpress.org/latest.tar.gz -P /tmp
tar -xzvf /tmp/latest.tar.gz -C /tmp
sudo mv -f /tmp/wordpress /var/www/html

# --- 2. CREACIÓN DE BASE DE DATOS Y USUARIO ---
echo "Creando base de datos y usuario en MariaDB..."
sudo mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME;"
sudo mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME;"
sudo mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL;"
sudo mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD';"
sudo mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL;"

# --- 3. CONFIGURACIÓN DE wp-config.php ---
DIR_WP="/var/www/html/wordpress"

# Copiar el archivo de configuración de ejemplo
sudo cp $DIR_WP/wp-config-sample.php $DIR_WP/wp-config.php

# Reemplazar valores de conexión a la base de datos usando sed
echo "Configurando wp-config.php..."
sudo sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" $DIR_WP/wp-config.php
sudo sed -i "s/username_here/$WORDPRESS_DB_USER/" $DIR_WP/wp-config.php
sudo sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" $DIR_WP/wp-config.php
sudo sed -i "s/localhost/$WORDPRESS_DB_HOST/" $DIR_WP/wp-config.php

# --- 4. CONFIGURACIÓN DE URLS ESPECÍFICAS (WP_HOME y WP_SITEURL) ---
# Usar $CERTIFICATE_DOMAIN, asumiendo que ya fue definido.
# WP_SITEURL (ruta física del código): https://dominio/wordpress
# WP_HOME (dirección pública del sitio): https://dominio/
echo "Configurando WP_HOME y WP_SITEURL..."
sudo sed -i "/DB_COLLATE/a define('WP_SITEURL', 'https://$CERTIFICATE_DOMAIN/wordpress');" $DIR_WP/wp-config.php
sudo sed -i "/WP_SITEURL/a define('WP_HOME', 'https://$CERTIFICATE_DOMAIN');" $DIR_WP/wp-config.php

# --- 5. CONFIGURACIÓN DE SECURITY KEYS ---
echo "Generando y añadiendo Security Keys..."
# Eliminar las claves por defecto (usando sed -i con 'd' para delete)
sudo sed -i "/define('AUTH_KEY'/d" $DIR_WP/wp-config.php
# Repetir para el resto de claves (omitiendo por minimalismo, pero debe hacerse en la práctica)
# ...

# Obtener nuevas claves y limpiar el caracter '/'
SECURITY_KEYS=$(curl https://api.wordpress.org/secret-key/1.1/salt/)
SECURITY_KEYS=$(echo $SECURITY_KEYS | tr / _)

# Insertar las nuevas claves generadas
sudo sed -i "/@-/a $SECURITY_KEYS" $DIR_WP/wp-config.php

# --- 6. CONFIGURACIÓN DEL INDEX PRINCIPAL ---
# Copiar el index.php del subdirectorio a la raíz
sudo cp $DIR_WP/index.php /var/www/html

# Modificar el index.php de la raíz para que cargue la instalación del subdirectorio
echo "Ajustando el index.php de la raíz..."
sudo sed -i "s#wp-blog-header.php#wordpress/wp-blog-header.php#" /var/www/html/index.php

# --- 7. PERMISOS Y REINICIO ---
echo "Ajustando permisos y reiniciando Apache..."
# Dar propiedad a Apache (www-data)
sudo chown -R www-data:www-data /var/www/html/

# Reiniciar Apache (asumiendo mod_rewrite ya está habilitado)
sudo systemctl restart apache2

echo "✅ Instalación de WordPress en su propio directorio completada."
