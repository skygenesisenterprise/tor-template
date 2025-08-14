variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
}

variable "tor_nickname" {
  description = "Tor relay nickname"
  type        = string
}

variable "tor_contact_info" {
  description = "Tor relay contact info"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
