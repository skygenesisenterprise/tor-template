output "public_ip" {
  description = "Public IP of the instance"
  value       = google_compute_instance.tor_relay.network_interface[0].access_config[0].nat_ip
}

output "instance_id" {
  description = "Instance ID"
  value       = google_compute_instance.tor_relay.id
}
