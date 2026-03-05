# Update package index
sudo apt update -y

# Install Nginx
sudo apt install -y nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Start Nginx service
sudo systemctl start nginx

# Check Nginx status
sudo systemctl status nginx


sudo apt update
sudo apt install certbot python3-certbot-nginx -y

sudo certbot --nginx -d <your domain>

ln -s /etc/nginx/sites-available/<your domain> /etc/nginx/sites-enabled/<your domain>

systemctl restart nginx
systemctl enable nginx
systemctl status nginx