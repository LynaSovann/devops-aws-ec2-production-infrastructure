**awsproject-minio**

- Name: awsproject-minio
- Key Pair: awsproject-prod-key.pem
- Security Group: awsproject-minio-SG
- API: Ubuntu Server 24.04 , t2.micro
- user data: **./userdata/minio.sh**
- After Launch the instance

1. SSh to instance

```bash
ssh -i .\awsproject-prod-key.pem ubuntu@<public-ip-address>
```

2. Switch to root user

```bash
sudo -i
```

3. Install Nginx and request certificate for domain name **minio.lynasovann.site** for ssl

- Command line in file <./ingx/nginx.sh>

**awsproject-db**

- Name: awsproject-db
- Key Pair: awsproject-prod-key.pem
- Security Group: awsproject-backend-SG
- API: Ubuntu Server 24.04, t2.micro
- user data: **./userdata/postgresql.sh**
