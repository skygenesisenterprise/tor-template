terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# AWS Provider Configuration
provider "aws" {
  region = var.aws_region
}

# Google Cloud Provider Configuration
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Azure Provider Configuration
provider "azurerm" {
  features {}
}

# Local variables
locals {
  common_tags = {
    Project     = "tor-relay"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Data sources for AMI/Image selection
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Conditional resource creation based on provider selection
module "aws_tor_relay" {
  count  = var.cloud_provider == "aws" ? 1 : 0
  source = "./modules/aws"

  instance_type     = var.aws_instance_type
  key_name         = var.aws_key_name
  ami_id           = data.aws_ami.ubuntu.id
  availability_zone = var.aws_availability_zone
  
  tor_nickname     = var.tor_nickname
  tor_contact_info = var.tor_contact_info
  
  tags = local.common_tags
}

module "gcp_tor_relay" {
  count  = var.cloud_provider == "gcp" ? 1 : 0
  source = "./modules/gcp"

  machine_type = var.gcp_machine_type
  zone         = var.gcp_zone
  
  tor_nickname     = var.tor_nickname
  tor_contact_info = var.tor_contact_info
  
  labels = local.common_tags
}

module "azure_tor_relay" {
  count  = var.cloud_provider == "azure" ? 1 : 0
  source = "./modules/azure"

  vm_size           = var.azure_vm_size
  location          = var.azure_location
  resource_group    = var.azure_resource_group
  
  tor_nickname     = var.tor_nickname
  tor_contact_info = var.tor_contact_info
  
  tags = local.common_tags
}
