# Production-Ready AWS Deployment (EC2 + ALB + ASG)

<img src="./diagram/aws-architecture.png">

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

Here are the Security Groups created for the project and their purpose:

- **awsproject-ALB-SG** - Controls traffic to the Applciation Load Balancer (ALB), allowing users to access the frontend.
  <img src="./img/sg/awsproject-alb-sg.png">

- **awsproject-app-SG** - Assigned to the Frontend EC2 instance. Allows incoming traffic from the ALB.
  <img src="./img/sg/awsproject-app-sg.png">

- **awsproject-api-SG** - Assigned to the API EC2 instance. Allows traffic from the Nginx reverse proxy.
  <img src="./img/sg/awsproject-api-sg.png">
  - **awsproject-api-nginx-sg** - For the Nginx reverse proxy in front of the API. Allows external requests and forwards them to the API instance.
    <img src="./img/sg/awsproject-api-nginx-sg.png">

- **awsproject-backend-SG** - For the PostgreSQL database instance. Only allows connections from the API service.
  <img src="./img/sg/awsproject-backend-sg.png">

- **awsproject-minio-SG** - Assigned to the Minio instance. Allows traffic from any services that need object storage access.
  <img src="./img/sg/awsproject-minio-sg.png">

### 3. Launch EC2 Instances

- **awsproject-app** - Hosts the frontend.
- **awsproject-api** - Hosts the api service.
- **awsproject-api-nginx** - Acts as reverse proxy for api service.
- **awsproject-db** - Postgresql database server.
- **awsproject-minio** - Minio server.

---

**awsproject-minio**

- Available in **MINIO-SETUP.md**

**awsproject-db**

- Available in **POSTGRESQL-SETUP.md**

**awsproject-api**

- Available in **API-SETUP.md**

**awsproject-api-nginx**

- Available in **API-REVERSE-PROXY.md**

**awsproject-app**

- Available in **APP-SETUP.md**
