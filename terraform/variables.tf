variable "cloud_provider" {
  description = "Cloud provider to use (aws, gcp, or azure)"
  type        = string
  default     = "aws"
  
  validation {
    condition     = contains(["aws", "gcp", "azure"], var.cloud_provider)
    error_message = "Cloud provider must be one of: aws, gcp, azure."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "prod"
}

# Tor Configuration
variable "tor_nickname" {
  description = "Nickname for the Tor relay"
  type        = string
  default     = "MyTorRelay"
}

variable "tor_contact_info" {
  description = "Contact information for the Tor relay operator"
  type        = string
  default     = "tor-operator@example.com"
}

# AWS Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "aws_key_name" {
  description = "AWS EC2 Key Pair name"
  type        = string
  default     = ""
}

variable "aws_availability_zone" {
  description = "AWS availability zone"
  type        = string
  default     = "us-east-1a"
}

# GCP Variables
variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
  default     = ""
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "gcp_machine_type" {
  description = "GCP machine type"
  type        = string
  default     = "e2-medium"
}

# Azure Variables
variable "azure_location" {
  description = "Azure location"
  type        = string
  default     = "East US"
}

variable "azure_resource_group" {
  description = "Azure resource group name"
  type        = string
  default     = "tor-relay-rg"
}

variable "azure_vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B2s"
}
