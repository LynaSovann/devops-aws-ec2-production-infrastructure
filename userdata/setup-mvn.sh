#!/bin/bash

# Exit immediately if a command fails
set -e

#--------------------------------------
# Variables
#--------------------------------------
JAVA_VERSION="21"
JAVA_HOME_DIR="/usr/lib/jvm/java-21-openjdk-amd64"
MAVEN_VERSION="3.9.12"
MAVEN_DIR="/usr/local/maven"

#--------------------------------------
# Step 1 — Install OpenJDK
#--------------------------------------
echo "Installing OpenJDK $JAVA_VERSION..."
sudo apt update -y
sudo apt install -y openjdk-$JAVA_VERSION-jdk

# Set JAVA_HOME
export JAVA_HOME=$JAVA_HOME_DIR
export PATH=$JAVA_HOME/bin:$PATH

# Verify Java installation
echo "Verifying Java installation..."
java -version
echo "JAVA_HOME=$JAVA_HOME"

#--------------------------------------
# Step 2 — Install Apache Maven
#--------------------------------------
echo "Downloading Apache Maven $MAVEN_VERSION..."
cd /tmp
wget https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz

echo "Extracting Maven..."
sudo tar xzvf apache-maven-$MAVEN_VERSION-bin.tar.gz -C /usr/local
sudo mv /usr/local/apache-maven-$MAVEN_VERSION $MAVEN_DIR

# Add Maven to PATH
export PATH=$MAVEN_DIR/bin:$PATH

# Verify Maven installation
echo "Verifying Maven installation..."
mvn -v

echo "✅ OpenJDK $JAVA_VERSION and Maven $MAVEN_VERSION installed successfully!"