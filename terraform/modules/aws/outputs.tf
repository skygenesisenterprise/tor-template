output "public_ip" {
  description = "Public IP of the instance"
  value       = aws_eip.tor_relay.public_ip
}

output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.tor_relay.id
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.tor_relay.id
}
