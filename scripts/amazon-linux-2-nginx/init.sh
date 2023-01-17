#!/bin/bash

echo Actualización de paquetes:
sudo yum update -y

echo install nodejs
curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs

echo Instalar git en tu instancia de EC2
sudo yum install git -y

echo Revisar la versión de git
git version

echo Instalar pm2
sudo npm install pm2 -g

echo Instalar yarn
sudo npm install yarn -g

echo Instalar NginX
sudo amazon-linux-extras install rust1 -y

echo Revisar la versión instalada de linux
cat /etc/os-release

echo Agrega archivo de configuración de Nginx
echo '[nginx]
name=nginx repo
baseurl=https://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1' | sudo tee --append /etc/yum.repos.d/nginx.repo

echo Instalar Nginx
sudo yum install nginx -y

echo Revisar la versión de nginx 
nginx -v

echo Iniciar NginX
sudo service nginx start

echo Añadir carpeta sites-enables in nginx.conf
sudo sed -i '15 i include /etc/nginx/sites-enabled/*;' /etc/nginx/nginx.conf

echo Crear archivo default en carpeta sites-enabled
sudo mkdir /etc/nginx/sites-enabled
sudo touch /etc/nginx/sites-enabled/default

echo Elegir el puerto donde se leerá la aplicación 3000 default
read port_nginx_conf
echo "server {
   listen         80 default_server;
   listen         [::]:80 default_server;
   server_name    localhost;
   root           /usr/share/nginx/html;
location / {
       proxy_pass http://127.0.0.1:$port_nginx_conf;
       proxy_http_version 1.1;
       proxy_set_header Upgrade \$http_upgrade;
       proxy_set_header Connection 'upgrade';
       proxy_set_header Host \$host;
       proxy_cache_bypass \$http_upgrade;
   }
}" | sudo tee --append /etc/nginx/sites-enabled/default

echo Reiniciar nginx
sudo service nginx restart

