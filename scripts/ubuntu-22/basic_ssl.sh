echo Detener nginx para poder comenzar con el registro de ssl
sudo systemctl stop nginx

sudo apt update
sudo apt install certbot python3-certbot-nginx