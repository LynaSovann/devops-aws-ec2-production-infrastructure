#!/bin/bash
set -e

# MinIO Installation and SystemD Setup for Amazon Linux/CentOS

MINIO_USER="minio"
MINIO_GROUP="minio"
MINIO_DATA_DIR="/mnt/data/minio"
MINIO_CONFIG_DIR="/etc/minio"
MINIO_VERSION="latest"

# Create minio user and group
if ! id "$MINIO_USER" &>/dev/null; then
    groupadd -r "$MINIO_GROUP"
    useradd -r -s /sbin/nologin -g "$MINIO_GROUP" "$MINIO_USER"
fi

# Create directories
mkdir -p "$MINIO_DATA_DIR" "$MINIO_CONFIG_DIR"
chown -R "$MINIO_USER:$MINIO_GROUP" "$MINIO_DATA_DIR" "$MINIO_CONFIG_DIR"

# Download and install MinIO
wget -q https://dl.min.io/server/minio/release/linux-amd64/minio -O /usr/local/bin/minio
chmod +x /usr/local/bin/minio

# Create MinIO environment file
cat > "$MINIO_CONFIG_DIR/minio.env" << 'EOF'
MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=admin123
MINIO_VOLUMES="/mnt/data/minio"
MINIO_OPTS="--address :9000 --console-address :9001"
EOF

chown "$MINIO_USER:$MINIO_GROUP" "$MINIO_CONFIG_DIR/minio.env"
chmod 600 "$MINIO_CONFIG_DIR/minio.env"

# Create SystemD service file
cat > /etc/systemd/system/minio.service << EOF
[Unit]
Description=MinIO
Documentation=https://docs.min.io
Wants=network-online.target
After=network-online.target
AssertFileNotEmpty=$MINIO_CONFIG_DIR/minio.env

[Service]
Type=notify
User=$MINIO_USER
Group=$MINIO_GROUP
EnvironmentFile=$MINIO_CONFIG_DIR/minio.env
ExecStart=/usr/local/bin/minio server \$MINIO_OPTS \$MINIO_VOLUMES
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal
SyslogIdentifier=minio

[Install]
WantedBy=multi-user.target
EOF

# Enable and start MinIO service
systemctl daemon-reload
systemctl enable minio
systemctl start minio
systemctl status minio