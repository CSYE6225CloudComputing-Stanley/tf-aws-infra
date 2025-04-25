# Terraform AWS Infrastructure

## Overview

This project uses [Terraform](https://www.terraform.io/) to provision a scalable and secure AWS infrastructure for deploying an application. It automates the setup of networking, EC2, load balancing, security, environment configuration, and monitoring services.

---

### ☁️ Networking

- **VPC** spanning multiple Availability Zones, with both **Public** and **Private** subnets
- **Internet Gateway** for external access and **Route Tables** properly associated with subnets
- **NAT Gateway** to enable outbound internet traffic for private subnets

---

### 🖥️ EC2

- **EC2 instances** launched and managed via an **Auto Scaling Group (ASG)** using a **Launch Template**
- **User Data** scripts used during instance initialization to automate environment setup
- **Application** service automatically restarted after environment configuration

---

### 🌐 Load Balancing and Security

- **Application Load Balancer (ALB)** terminating HTTPS traffic on port 443, secured with:
  - An **ACM Certificate** manually imported and attached
  - **Target Group** integrating with the Auto Scaling Group for dynamic instance registration
  - **Health Checks** continuously monitoring application health
- **Security Groups** for EC2, RDS and Load Balancer
---

### 🔐 Secrets Management and Encryption

- **AWS Secrets Manager** used to securely retrieve environment variables (e.g., database credentials) at instance startup
- **AWS Key Management Service (KMS)**:
  - Customer-managed keys created to encrypt:
    - EC2 volume
    - S3 bucket objects
    - Secrets stored in Secrets Manager
    - RDS database encryption
  - All KMS keys have **90-day automatic rotation** enabled

---

### 📈 Monitoring and Metrics

- **Amazon CloudWatch Agent** installed and configured on each instance to collect:
  - **Application logs** from the application
  - **Custom Metrics** via **StatsD** for real-time performance monitoring



## 🛠 Install Dependencies
- **Terraform** ([Download](https://www.terraform.io/downloads.html))
- **AWS CLI** ([Download](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))

## 🔐 AWS Authentication

Ensure you have AWS credentials configured:

- Use `aws configure` to set up your credentials 

## 📂 Project Structure
```bash
tf-aws-infra/
├── environments/           # Environment-specific tfvars files (e.g., dev/)
│   └── dev/
│       ├── dev.tfvars
│       └── main.tf
├── modules/                # Reusable Terraform modules
│   ├── vpc/                # VPC setup
│   ├── ec2/                # EC2 instance deployment
│   └── .....
├── scripts/
│   └── user-data.sh        # EC2 User Data Script
├── .github/workflows/      # GitHub Actions CI/CD
├── .gitignore
└── README.md               
```

## 🛠️ EC2 User Data Script

During EC2 instance launch, a custom **User Data** script is executed to automate application setup.

The script does the following:

1. **Retrieve database credentials** securely from [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html)
2. **Set environment variables** for your application under `/etc/environment`
3. **Restart application** managed by `systemctl`
4. **Configure and start CloudWatch Agent** to collect logs and metrics (using StatsD)

## 📌 Configuration Variables

Example configuration (`dev.tfvars`):

```bash
aws_region           = "us-east-1"
profile              = "your aws profile"
vpc_name             = "my_vpc"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
private_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
instance_type        = "t2.medium"
my_ip = "your ip/32"
ami_id   = "your ami id"
key_name = "your instance key name"
DB_HOST     = "your rds db host"
DB_NAME     = "your db name"
DB_USERNAME = "your db username"
db_availability_zone = "us-east-1a"
iam_group_name       = "tf"
BUCKET_NAME = "bucket name"
ssl_cert_arn = "your ssl cert arn"
```

## 📌 Import certificate into aws Certificate Manager

```bash
aws acm import-certificate \
  --certificate fileb://demo_hahahaha_it_com.crt \
  --private-key fileb://private.key \
  --certificate-chain fileb://demo_hahahaha_it_com.ca-bundle \
  --region us-east-1
```

## 🚀 Usage

```bash
1️⃣ Initialize Terraform  
terraform init  

2️⃣ Format Configuration  
terraform fmt  

3️⃣ Validate Configuration  
terraform validate  

4️⃣ Preview Infrastructure Changes  
terraform plan -var-file=dev.tfvars  

5️⃣ Apply Terraform Configuration  
terraform apply -var-file=dev.tfvars  

6️⃣ Destroy Infrastructure (When No Longer Needed)  
terraform destroy -var-file=dev.tfvars  
```