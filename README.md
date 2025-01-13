# Static Website Hosting on AWS with Terraform

This repository contains Terraform code to deploy a static website on AWS. The project uses an S3 bucket for hosting and CloudFront for global content delivery, ensuring scalability, security, and low-latency access. The infrastructure is modular and parameterized, making it easy to adapt to different environments.

---

## Features
- **Static Website Hosting**: Uses S3 to host website content.
- **Global Content Delivery**: CloudFront acts as a Content Delivery Network (CDN).
- **Security**: Implements bucket policies, Origin Access Identity (OAI), and HTTPS enforcement.
- **Flexibility**: Uses Terraform variables to allow customization for different environments.

---

## Prerequisites
Before running this project, ensure the following:
1. **Terraform**: Install [Terraform](https://www.terraform.io/downloads).
2. **AWS Account**: Ensure you have an AWS account with the necessary permissions:
   - `S3` for bucket creation.
   - `CloudFront` for content delivery configuration.
   - `IAM` for managing access policies.
3. **AWS CLI**: Install and configure the [AWS CLI](https://aws.amazon.com/cli/).

---

## Setup Instructions

### Step 1: Clone the Repository
Clone this repository to your local machine:
```bash
git clone https://github.com/valerieholtz/terraform_aws_webpage.git
```

### Step 2: Update Variables
Modify the `variables.tf` file to customize the deployment:
- `bucket_name`: Provide a unique name for your S3 bucket.
- `environment`: Specify the environment (e.g., `Production`, `Staging`, etc.).

### Step 3: Initialize Terraform
Initialize Terraform to download necessary provider plugins:
```bash
terraform init
```

### Step 4: Plan the Deployment
Preview the resources that will be created:
```bash
terraform plan
```

### Step 5: Deploy the Infrastructure
Apply the Terraform configuration to deploy the infrastructure:
```bash
terraform apply
```
- Type `yes` when prompted to confirm the deployment.

---

## Outputs
After deployment, Terraform will output the CloudFront URL for the website:
```bash
Outputs:

website_url = "https://<your-cloudfront-domain-name>"
```
Access the static website using the provided URL.

---

## Project Structure
- `provider.tf`: Configures the AWS provider and region.
- `s3.tf`: Defines the S3 bucket and configurations for static website hosting.
- `cloudfront.tf`: Configures CloudFront for global content delivery.
- `variables.tf`: Contains variables for customizing the deployment.
- `outputs.tf`: Outputs the CloudFront domain for easy access.
- `index.html`: The static content to be hosted.

---
