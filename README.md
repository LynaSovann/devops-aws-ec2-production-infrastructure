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
- user data: **./userdata/minio.sh**
