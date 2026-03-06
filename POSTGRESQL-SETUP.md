# PostgreSQL EC2 Instance Setup

This section describes how the **PostgreSQL database** is deployed on an EC2 instance and connected to the internal network for API service.

## Architecture Overview

<img src="./diagram/postgresql-setup-architecture.png" width="700">

### Request Flow

1. API application connects to PostgreSQL using JDBC URL: **jdbc:postgresql://db.awsproject.internal:5432/demo**
2. PostgreSQL authenticates using **username/password**: `demo / demo123`
3. All traffic stays **within the internal AWS network**
4. The database is **not exposed to the internet**, only API services can access it

---

## EC2 Instance Configuration

| Setting          | Value                      |
| ---------------- | -------------------------- |
| Instance Name    | `awsproject-db`            |
| AMI              | Ubuntu Server 24.04        |
| Instance Type    | `t2.micro`                 |
| Key Pair         | `awsproject-prod-key.pem`  |
| Security Group   | `awsproject-backend-SG`    |
| User Data Script | `./userdata/postgresql.sh` |

---

## Database Configuration

```bash
spring.datasource.driver-class-name=org.postgresql.Driver
spring.datasource.url=jdbc:postgresql://db.awsproject.internal:5432/demo
spring.datasource.username=demo
spring.datasource.password=demo123
```

### Note:

- The database is **internal-only, connected via **AWS private network\*\*.
- Credentials are stored in **application.properties** for API service.
