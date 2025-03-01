# Infrastructure as Code (IaC) Project with Terraform & Ansible  

This project demonstrates how to use **Terraform** and **Ansible** to automate infrastructure provisioning and configuration management on **AWS**.  

## Prerequisites  

To try this web server, you need:  
- An **AWS account**  
- AWS **Access Key** and **Secret Key**  

### Set Up AWS Credentials  
1. **Create an AWS Account** and log in at [AWS Console](https://console.aws.amazon.com/).  
2. Navigate to **Security Credentials** → **Access Keys** and generate a new key pair.  
3. **Best Practice:** Avoid hardcoding credentials. Instead, store them in a `.env` file or export them as environment variables:  
   ```sh
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   ```
4. **Temporary Setup for Local Testing (Not Recommended in Production)**  
   You can hardcode the credentials in the Terraform provider block:  
   ```hcl
   provider "aws" {
     region     = "us-west-2"
     access_key = "my-access-key"
     secret_key = "my-secret-key"
   }
   ```
   More details: [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)  

5. **After testing**, delete your access key for security reasons.  

---

## Step 1: Initialize Terraform  
Run:  
```sh
terraform init
```
This command:  
- Initializes the Terraform environment  
- Downloads the necessary AWS provider plugins  

## Step 2: Apply Terraform Configuration  
Run:  
```sh
terraform apply
```
This will create the infrastructure, including:  
✅ EC2 instance (Ubuntu Server)  
✅ VPC  
✅ Internet Gateway  
✅ Route Tables  
✅ Network Interfaces  

You can verify the resources in your **AWS Console**.  

## Step 3: Access the Web Server  
1. Retrieve the **public IP address** of the provisioned EC2 instance.  
2. Open a browser and navigate to `http://<EC2_PUBLIC_IP>`.  
3. You should see a simple **"Hello, World!"** message.  

The instance is preconfigured with **Apache** via a simple Bash script that updates the web server’s index page.  

---

## Step 4: Configuration Management with Ansible  
Later, **Ansible** was integrated to:  
- Provision additional **EC2 instances** on top of the one created by Terraform  
- Perform **configuration management**  
- Dynamically load inventory  

### How Ansible Works in This Project  
- Ansible playbooks were executed from a **Master Node**.  
- All provisioned **Ubuntu servers** responded to the configuration.  
- Apache was installed on all instances using **Yum**.  
- A basic HTTP webpage was deployed across all instances.  

---

## Exploring Further  
Try out different **Terraform** and **Ansible** commands to experiment with Infrastructure as Code (IaC) automation.  
