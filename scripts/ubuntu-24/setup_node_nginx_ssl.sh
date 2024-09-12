#!/bin/bash

# Variables - replace with your domain and email
DOMAIN="yourdomain.com"
WWW_DOMAIN="www.yourdomain.com"
NODE_PORT=3000
EMAIL="youremail@example.com" # For SSL certificate

# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Node.js, Nginx, and Certbot
echo "Installing Nginx and Certbot..."
sudo apt install nginx certbot python3-certbot-nginx -y

# Start and enable Nginx service
echo "Starting and enabling Nginx..."
sudo systemctl start nginx
sudo systemctl enable nginx

# Create an Nginx configuration for the Node.js app
echo "Configuring Nginx for your domain..."
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"
sudo cat > $NGINX_CONF <<EOF
server {
    listen 80;
    server_name $DOMAIN $WWW_DOMAIN;

    # Redirect all HTTP to HTTPS
    location / {
        return 301 https://\$server_name\$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name $DOMAIN $WWW_DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        proxy_pass http://localhost:$NODE_PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Enable the site configuration
echo "Enabling Nginx configuration..."
sudo ln -s $NGINX_CONF /etc/nginx/sites-enabled/

# Test Nginx configuration and reload
echo "Testing Nginx configuration..."
sudo nginx -t
echo "Reloading Nginx..."
sudo systemctl reload nginx

# Install SSL certificate using Certbot
echo "Installing SSL certificate with Certbot..."
sudo certbot --nginx --non-interactive --agree-tos --email $EMAIL -d $DOMAIN -d $WWW_DOMAIN

# Ensure that Nginx is running
echo "Ensuring Nginx is running..."
sudo systemctl restart nginx

# Install pm2 to manage the Node.js app
echo "Installing pm2 for Node.js app management..."
sudo npm install pm2 -g

# Make sure the Node.js app is running with pm2
echo "Starting Node.js app with pm2..."
pm2 start app.js --name "node_app"

# Setup pm2 to start on boot
echo "Setting up pm2 to start on system boot..."
pm2 startup
pm2 save

# Test SSL renewal (dry run)
echo "Testing SSL certificate renewal..."
sudo certbot renew --dry-run

echo "Setup completed! Your Node.js app should now be accessible at https://$DOMAIN."
