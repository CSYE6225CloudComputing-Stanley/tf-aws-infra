# Terraform AWS Infrastructure Project

## Overview

This project uses [Terraform](https://www.terraform.io/) to provision AWS infrastructure, including:

- **VPC** with both **Public** and **Private** subnets
- **Internet Gateway** and appropriate **Route Tables**
- **EC2 Security Group**
- **EC2 Instance** deployed in a **public subnet**


### 🛠 Install Dependencies

Ensure you have the following installed:

- **Terraform** ([Download](https://www.terraform.io/downloads.html))
- **AWS CLI** ([Download](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))

### 🔐 AWS Authentication

Ensure you have AWS credentials configured:

- Use `aws configure` to set up your credentials 

## 📌 Configuration Variables

Example configuration (`dev.tfvars`):

```bash
aws_region             = "us-east-1"
profile                = "aws cli profile"
vpc_name               = "my_vpc"
vpc_cidr               = "10.0.0.0/16"
public_subnet_cidrs    = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
private_subnet_cidrs   = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
availability_zones     = ["us-east-1a", "us-east-1b", "us-east-1c"]
instance_type          = "t2.medium"
ami_id                 = "your ami id"
webapp_instance_public_subnet = "10.0.1.0/24"
key_name               = "key file_name"
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