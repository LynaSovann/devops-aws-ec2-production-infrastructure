# Production-Ready AWS Deployment (EC2 + ALB + ASG + S3)

## Project Overview

This project demonstrates a **real-world enterprise-style deployment** on aws using traditional virtual machines (EC2), without Docker and Kubernetes.

The architecture focuses on:

- High availability
- Scalability
- Secure networking
- Proper DNS configuration
- HTTPS encryption
- Controlled access to cloud resources

## Infrastructure Components

- EC2 (Application & Services)
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- Route 53 (Private DNS for Internal Communication)
- GoDaddy (Public Domain DNS)
- SSL Certificate (AWS Certificate Manager)
- Security Groups
- HTTPS (SSL Termination at Load Balancer)

## AWS Setup Flow

### 1. Create Key Pair

- Generate a Key Pair to allow SSH access to your EC2 instances. **awsproject-prod-key.pem**

### 2. Generate Security Groups

- **awsproject-ALB-SG** - Controls traffic to the load balancer.
- **awsproject-app-SG** - For the application EC2 instance (Frontend).
- **awsproject-api-SG** - For the API EC2 instance.
- **awsproject-backend-SG** - For Postgresql and Minio access.

### 3. Launch EC2 Instances

- **awsproject-app** - Hosts the frontend.
- **awsproject-api** - Hosts the api service.
- **awsproject-db** - Postgresql database server.
- **awsproject-minio** - Minio server.

---

**awsproject-minio**

- Name: awsproject-minio
- Key Pair: awsproject-prod-key.pem
- Security Group: awsproject-backend-SG
- API: Amazon Linux 2023, t2.micro
- user data

```bash
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
```
