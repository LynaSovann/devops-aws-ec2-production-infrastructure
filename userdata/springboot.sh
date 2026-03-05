#!/bin/bash
set -e

# ==============================
# Spring Boot Backend Setup
# Ubuntu 22.04 / 24.04
# ==============================

apt update -y
apt upgrade -y

# Create backend directory
mkdir -p /opt/backend

# Create dedicated system user (no login shell)
useradd -r -m -d /opt/backend -s /usr/sbin/nologin backend-user

# Set ownership
chown -R backend-user:backend-user /opt/backend

# ==============================
# Create Environment Configuration File
# ==============================

cat <<EOF > /etc/backend.conf
SPRING_PROFILES_ACTIVE=prod
EOF

# Secure env file
chmod 600 /etc/backend.conf

# ==============================
# Create systemd service
# ==============================

cat <<EOF > /etc/systemd/system/backend.service
[Unit]
Description=Spring Boot Backend Application
After=network.target

[Service]
User=backend-user
Group=backend-user

WorkingDirectory=/opt/backend
EnvironmentFile=/etc/backend.conf

ExecStart=/usr/bin/java -Xms256m -Xmx512m -jar /opt/backend/ROOT.war
SuccessExitStatus=143

Restart=always
RestartSec=5

LimitNOFILE=65536
TimeoutStopSec=30

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload

# Enable service (will start after WAR is uploaded)
systemctl enable backend

echo "Backend base setup completed."
echo "Upload ROOT.war to /opt/backend/ then run: systemctl start backend"

