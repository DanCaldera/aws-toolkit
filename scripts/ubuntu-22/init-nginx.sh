# Install nginx
sudo apt install nginx

# Start nginx
sudo systemctl enable nginx

# Check nginx version
nginx -v

echo add folder sites-enables in nginx.conf
# sudo sed -i '15 i include /etc/nginx/sites-enabled/*;' /etc/nginx/nginx.conf

echo add default file on folder sites-enabled
sudo mkdir /etc/nginx/sites-enabled
sudo rm -rf /etc/nginx/sites-enabled/default
sudo touch /etc/nginx/sites-enabled/default

echo Choose the port where the app will be running (default port 3000)
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

echo Restart nginx
sudo service nginx restart

