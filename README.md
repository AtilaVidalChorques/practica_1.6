# Instalación de WordPress en el directorio raíz

Descargamos la ultima versión de WordPress con el comando wget https://wordpress.org/latest.tar.gz -P /tmp

<img width="889" height="252" alt="image" src="https://github.com/user-attachments/assets/192a9cf8-7e20-48aa-bb72-230e1bfc2f1d" />

Descomprimimos el archivo .tar.gz con el comando tar -xzvf /tmp/latest.tar.gz -C /tmp

<img width="589" height="267" alt="image" src="https://github.com/user-attachments/assets/1646ce7b-22c0-44fb-95a1-9109850189fa" />

Movemos lo que acabamos de descomprimir de /tmp/wordpress hasta /var/www/html.

<img width="620" height="40" alt="image" src="https://github.com/user-attachments/assets/60ad9f45-0593-4414-88f7-b31afcd35d66" />

Creamos el archivo .env y ponemos las credenciales que usaremos para entrar a WordPress

<img width="433" height="137" alt="image" src="https://github.com/user-attachments/assets/c2a2de01-380b-4c72-955a-583f6319f8b6" />

Creamos la base de datos y el usuario en MySQL

<img width="710" height="231" alt="image" src="https://github.com/user-attachments/assets/1d2c3563-126f-466d-a4a4-7cd06b2377e1" />

<img width="741" height="346" alt="image" src="https://github.com/user-attachments/assets/66903cf8-00e5-4708-b161-53223651d71c" />

Entramos al archuivo /var/www/html/wp-config-sample.php y tendra que quedar asi.

<img width="636" height="394" alt="image" src="https://github.com/user-attachments/assets/ed53dfcc-5fac-4ad4-9101-5ef900d02e55" />

Una vez hecho usaremos el comando cp para copiar el archivo wp-config-sample.php a /var/www/html/wp-config.php

<img width="738" height="60" alt="image" src="https://github.com/user-attachments/assets/f33efec8-1a6d-4a22-96ba-b6fd5df7cd37" />

Cambiamos el propietario y el grupo al directorio /var/www/html.

<img width="664" height="40" alt="image" src="https://github.com/user-attachments/assets/5f7e86ae-303e-4795-b1cb-f15da51e1a58" />

Preparamos la configuración para los enlaces permanentes de WordPress.

<img width="513" height="215" alt="image" src="https://github.com/user-attachments/assets/c904f99e-6e8b-490f-9709-d164c5279d82" />

Habilitamos el módulo mod_rewrite de Apache.

<img width="475" height="101" alt="image" src="https://github.com/user-attachments/assets/53c4723d-817a-414e-8005-631dff71319e" />

Reiniciar el servicio de Apache para que los cambios surtan efecto

<img width="525" height="38" alt="image" src="https://github.com/user-attachments/assets/14e36ea1-8f3d-4c5c-a5bf-505f16808c1a" />

# Comprobar si WordPress funciona

Como podemos ver el WordPres funciona correctamente ya que nos sale bien. Habia un error a la hora de crear el usuario pero ya esta solucionado y ya me a dejado entrar.

<img width="519" height="789" alt="image" src="https://github.com/user-attachments/assets/5bc5acf6-084c-42c1-8480-15a3f86c3aca" />

Como podemos ver nos deja entrar he instalar el WordPress.

<img width="768" height="971" alt="image" src="https://github.com/user-attachments/assets/89169646-ee7e-41fc-84f5-85a68c618a3b" />



