#!/bin/bash

echo Recuerda tener tu dominio registrado en el DNS con A Record apuntando con el valor de tu ip pública por ejemplo: 3.143.38.79

echo Detener nginx para poder comenzar con el registro de ssl
sudo systemctl stop nginx

echo Instalando python certbot nginx
sudo wget -r --no-parent -A 'epel-release-*.rpm' https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/
sudo rpm -Uvh dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-*.rpm
sudo yum-config-manager --enable epel*
sudo yum install -y certbot 
sudo yum install -y python-certbot-nginx

echo Escribir el dominio que se certificará
read my_domain_name
sudo certbot certonly --standalone --debug -d $my_domain_name

echo Creando nuevo archivo de configuración de nginx
sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
sudo touch /etc/nginx/conf.d/server.conf

echo Escribe el puerto donde está corriendo tu aplicacion
read my_app_port

echo "server {
listen 80;
listen [::]:80;
server_name $my_domain_name;
return 301 https://$server_name$request_uri;
}
server {
listen 443 ssl http2 default_server;
listen [::]:443 ssl http2 default_server;
server_name $my_domain_name;
location / {
proxy_pass http://localhost:$my_app_port;
}
ssl_certificate /etc/letsencrypt/live/$my_domain_name/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/$my_domain_name/privkey.pem;
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
ssl_session_cache shared:SSL:5m;
ssl_session_timeout 1h;
add_header Strict-Transport-Security “max-age=15768000” always;
}" | sudo tee --append /etc/nginx/conf.d/server.conf

echo Ya solo queda reiniciar nginx
sudo service nginx restart

echo Servido! ❤️
