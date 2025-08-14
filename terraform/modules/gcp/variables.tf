variable "machine_type" {
  description = "GCP machine type"
  type        = string
}

variable "zone" {
  description = "GCP zone"
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

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}
