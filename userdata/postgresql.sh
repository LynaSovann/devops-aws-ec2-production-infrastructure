#!/bin/bash

# ==============================
# Update System
# ==============================
apt update -y
apt upgrade -y

# ==============================
# Install PostgreSQL
# ==============================
apt install postgresql postgresql-contrib -y

# Start and Enable PostgreSQL
systemctl start postgresql
systemctl enable postgresql

# ==============================
# Configure PostgreSQL for Remote Access
# ==============================

# Get PostgreSQL version directory automatically
PG_VERSION=$(ls /etc/postgresql)

# Allow PostgreSQL to listen on all interfaces
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/$PG_VERSION/main/postgresql.conf

# Allow password authentication from any IP (you can restrict later)
echo "host    all     all     0.0.0.0/0     md5" >> /etc/postgresql/$PG_VERSION/main/pg_hba.conf

# Restart PostgreSQL to apply changes
systemctl restart postgresql

# ==============================
# Create Database and User
# ==============================
sudo -u postgres psql <<EOF

CREATE USER demo WITH PASSWORD 'demo123';
CREATE DATABASE demo OWNER demo;
GRANT ALL PRIVILEGES ON DATABASE demo TO demo;

EOF

# ==============================
# Create products table
# ==============================
sudo -u postgres psql -d demo <<EOF

CREATE TABLE IF NOT EXISTS products
(
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    image_url    TEXT,
    description  TEXT
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO demo;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO demo;

EOF

echo "PostgreSQL setup with remote access completed successfully."