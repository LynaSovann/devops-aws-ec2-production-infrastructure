#!/bin/bash

# Exit immediately if a command fails
set -e

#--------------------------------------
# Variables
#--------------------------------------
NODE_VERSION="22.22.0"
NODE_DIST="node-v$NODE_VERSION-linux-x64"
NODE_URL="https://nodejs.org/dist/v$NODE_VERSION/$NODE_DIST.tar.xz"
NODE_DIR="/usr/local/node"
PROFILE_FILE="/etc/profile.d/node.sh"

#--------------------------------------
# Step 1 — Install prerequisites
#--------------------------------------
echo "Updating system and installing dependencies..."
sudo apt update -y
sudo apt install -y wget tar xz-utils build-essential

#--------------------------------------
# Step 2 — Download and install Node.js
#--------------------------------------
echo "Downloading Node.js $NODE_VERSION..."
cd /tmp
wget $NODE_URL

echo "Extracting Node.js..."
sudo tar -xJvf $NODE_DIST.tar.xz -C /usr/local
sudo mv /usr/local/$NODE_DIST $NODE_DIR

#--------------------------------------
# Step 3 — Add Node to PATH globally
#--------------------------------------
echo "Creating profile file to set NODE_HOME and PATH..."
sudo bash -c "cat > $PROFILE_FILE" <<EOL
export NODE_HOME=$NODE_DIR
export PATH=\$NODE_HOME/bin:\$PATH
EOL

# Apply environment variables immediately
source $PROFILE_FILE

#--------------------------------------
# Step 4 — Verify Node.js installation
#--------------------------------------
echo "Verifying Node.js installation..."
node -v
corepack --version

#--------------------------------------
# Step 5 — Enable Corepack and install Yarn
#--------------------------------------
echo "Enabling Corepack and installing Yarn..."
corepack enable
corepack prepare yarn@stable --activate

# Verify Yarn installation
echo "Verifying Yarn installation..."
yarn -v

echo "✅ Node.js $NODE_VERSION and Yarn installed successfully!"