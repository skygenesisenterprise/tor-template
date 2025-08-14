# Tor Relay Terraform Infrastructure

This directory contains Terraform configurations for deploying Tor relay infrastructure across multiple cloud providers.

## Supported Providers

- **AWS** - EC2 instances with security groups and Elastic IPs
- **Google Cloud Platform** - Compute Engine instances with firewall rules
- **Azure** - Virtual machines with network security groups

## Quick Start

1. **Initialize Terraform:**
   ```bash
   cd terraform
   terraform init
   ```

2. **Configure variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your settings
   ```

3. **Plan deployment:**
   ```bash
   terraform plan
   ```

4. **Deploy infrastructure:**
   ```bash
   terraform apply
   ```

## Configuration

### Required Variables

- `cloud_provider` - Choose between "aws", "gcp", or "azure"
- `tor_nickname` - Your relay's nickname
- `tor_contact_info` - Your contact information

### Provider-Specific Variables

#### AWS
- `aws_region` - AWS region (default: us-east-1)
- `aws_instance_type` - EC2 instance type (default: t3.medium)
- `aws_key_name` - EC2 key pair name for SSH access

#### GCP
- `gcp_project_id` - Your GCP project ID
- `gcp_region` - GCP region (default: us-central1)
- `gcp_machine_type` - Machine type (default: e2-medium)

#### Azure
- `azure_location` - Azure region (default: East US)
- `azure_resource_group` - Resource group name
- `azure_vm_size` - VM size (default: Standard_B2s)

## Example terraform.tfvars

```hcl
cloud_provider = "aws"
environment    = "prod"

tor_nickname     = "MyTorRelay"
tor_contact_info = "operator@example.com"

# AWS specific
aws_region        = "us-east-1"
aws_instance_type = "t3.medium"
aws_key_name      = "my-key-pair"
```
