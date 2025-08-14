output "instance_ip" {
  description = "Public IP address of the Tor relay instance"
  value = var.cloud_provider == "aws" ? (
    length(module.aws_tor_relay) > 0 ? module.aws_tor_relay[0].public_ip : null
  ) : var.cloud_provider == "gcp" ? (
    length(module.gcp_tor_relay) > 0 ? module.gcp_tor_relay[0].public_ip : null
  ) : var.cloud_provider == "azure" ? (
    length(module.azure_tor_relay) > 0 ? module.azure_tor_relay[0].public_ip : null
  ) : null
}

output "instance_id" {
  description = "Instance ID of the Tor relay"
  value = var.cloud_provider == "aws" ? (
    length(module.aws_tor_relay) > 0 ? module.aws_tor_relay[0].instance_id : null
  ) : var.cloud_provider == "gcp" ? (
    length(module.gcp_tor_relay) > 0 ? module.gcp_tor_relay[0].instance_id : null
  ) : var.cloud_provider == "azure" ? (
    length(module.azure_tor_relay) > 0 ? module.azure_tor_relay[0].instance_id : null
  ) : null
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value = var.cloud_provider == "aws" ? (
    length(module.aws_tor_relay) > 0 ? "ssh -i ~/.ssh/${var.aws_key_name}.pem ubuntu@${module.aws_tor_relay[0].public_ip}" : null
  ) : var.cloud_provider == "gcp" ? (
    length(module.gcp_tor_relay) > 0 ? "gcloud compute ssh tor-relay-instance --zone=${var.gcp_zone}" : null
  ) : var.cloud_provider == "azure" ? (
    length(module.azure_tor_relay) > 0 ? "ssh azureuser@${module.azure_tor_relay[0].public_ip}" : null
  ) : null
}
