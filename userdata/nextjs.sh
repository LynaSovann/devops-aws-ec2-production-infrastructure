#!/bin/bash
set -e

# ==============================
# Update System
# ==============================
apt update -y
apt upgrade -y


# ==============================
# Create Dedicated Frontend User
# ==============================
adduser --system --group --home /home/frontend --shell /bin/bash frontend

# ==============================
# Create Application Directory
# ==============================
mkdir -p /opt/frontend
chown -R frontend:frontend /opt/frontend

# ==============================
# Create Environment Config File
# ==============================
mkdir -p /etc/frontend

cat <<EOF > /etc/frontend/frontend.env
NODE_ENV=production
EOF

# Secure env file
chown root:frontend /etc/frontend/frontend.env
chmod 640 /etc/frontend/frontend.env

# ==============================
# Create systemd Service
# ==============================
cat <<EOF > /etc/systemd/system/frontend.service
[Unit]
Description=Next.js Frontend
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/frontend
EnvironmentFile=/etc/frontend/frontend.env
Environment="PATH=/usr/local/node/bin:/usr/bin:/bin"
ExecStart=/usr/local/node/bin/yarn start -H 0.0.0.0 -p 3000
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload

# Enable service (will start after you build project)
systemctl enable frontend

echo "Frontend base setup completed."
echo "Now manually:"
echo "1) Clone your project into /opt/frontend"
echo "2) cd app/frontend"
echo "3) yarn && yarn build"
echo "4) systemctl start frontend"
