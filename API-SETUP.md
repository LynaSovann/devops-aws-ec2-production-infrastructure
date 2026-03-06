# Backend / API EC2 Instance Setup

This section describe how the **Spring Boot backend/API service** is deployed on an EC2 instance, connected to **PostgreSQL** and **MinIO**, and managed with **systemd**.

## Architecture Overview

<img src="./diagram/api-setup-architecture.png" height="700">

### Request Flow

1. A client sends a request to `https://api.lynasovann.site`.
2. DNS resolves the domain to the **API Reverse Proxy EC2 instance**.
3. **NGINX** receives the request on **port 443 (HTTPS)**.
4. NGINX forwards the request to the **backend API service** running on `api.awsproject.internal:8080`.
5. The **Spring Boot backend** process the request.
6. The backend communicates with:
   - **PostgreSQL** for database operations.
   - **MinIO** for object storage.
7. The response is returned through **NGINX → Client**.

---

## EC2 Instance Configuration

| Setting          | Value                      |
| ---------------- | -------------------------- |
| Instance Name    | `awsproject-api`           |
| AMI              | Ubuntu Server 24.04        |
| Instance Type    | `t3.micro`                 |
| Key Pair         | `awsproject-prod-key.pem`  |
| Security Group   | `awsproject-api-SG`        |
| User Data Script | `./userdata/springboot.sh` |

---

## Instance Access

- SSH Into Instance

```bash
ssh -i awsproject-prod-key.pem ubuntu@<public-ip-address>
```

- Switch to Root User

```bash
sudo -i
```

---

## Setup Java and Maven

- Run the setup script provided in the userdata folder:

```bash
./userdata/setup-mvn.sh
```

This will install **Java JDK** and Maven for building the backend project.

---

## Deploy the Backend Project

- Clone the Repository

```bash
git clone https://github.com/LynaSovann/backend-for-testing.git
```

- Update Configuration, edit `application.properties`

```bash
vim backend-for-testing/src/main/resources/application.properties
```

Configuration:

```bash
spring.application.name=backend

spring.datasource.driver-class-name=org.postgresql.Driver
spring.datasource.url=jdbc:postgresql://db.awsproject.internal:5432/demo
spring.datasource.username=demo
spring.datasource.password=demo123

minio.url=https://minio.lynasovann.site
minio.access.name=admin
minio.access.secret=admin123
minio.bucket.name=product-images
```

---

### Build the Project

- Change to the project root directory:

```bash
/usr/local/maven/bin/mvn clean install
```

- Copy the generated JAR/WAR file to the service folder:

```bash
cp target/backend-0.0.1-SNAPSHOT.jar /opt/backend/ROOT.war
```

### Manage Backend Service

- Restart the backend systemd service:

```bash
systemctl restart backend
```

- Check the status

```bash
systemctl status backend
```

---

### ✅ Result

- The backend/API service is running as a **systemd- managed service**.
- The application is connected to:
  - **PostgreSQL** for database operations.
  - **MinIO** for object storage.
- The service is accessible through the **NGINX reverse proxy instance** at:
  `https://api.lynasovann.site`
