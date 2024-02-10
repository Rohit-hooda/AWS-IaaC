# Terraform VPC Infrastructure

This Terraform code creates multiple Virtual Private Clouds (VPCs) in a single region, each with 3 public subnets and 3 private subnets spread across different availability zones. It also creates an Internet Gateway and attaches it to the VPC, creates public and private route tables, and associates the subnets with their respective route tables.

## Prerequisites

Before running this Terraform code, you will need the following:

1. AWS account
2. Terraform installed on your local machine
3. AWS CLI installed on your local machine
4. Rename the "template_terraform.tfvars" to "terraform.tfvars" and provide appropriate values

## Usage

1. Clone this repository to your local machine.
2. Navigate to the project directory.
3. Initialize the working directory by running **terraform init**.
   ```
   terraform init
   ```
4. Validate the configuration by running **terraform validate**.
   ```
   terraform validate
   or
   terraform validate -var-file="variables.tfvars"
   ```
5. Preview the changes that will be made by running **terraform plan**.
   ```
   terraform plan
   ```
6. Apply the changes by running **terraform apply**.
   ```
   terraform apply
   ```
7. When you are finished, tear down the infrastructure by running **terraform destroy**.
   ```
   terraform destroy
   ```

## Resources

This Terraform code creates the following resources:

1. VPCs
2. Subnets
3. Internet Gateway
4. Route Tables
5. Route Table Associations
6. Launch Template 
7. Auto Scaling Group
8. Load Balancer
9. Target Group
10. RDS instance
11. Route53 record
12. S3 Bucket
