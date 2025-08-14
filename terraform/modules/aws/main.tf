# AWS Security Group
resource "aws_security_group" "tor_relay" {
  name_prefix = "tor-relay-"
  description = "Security group for Tor relay"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tor ORPort
  ingress {
    from_port   = 9001
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tor DirPort
  ingress {
    from_port   = 9030
    to_port     = 9030
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# User data script for Tor installation
locals {
  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    tor_nickname     = var.tor_nickname
    tor_contact_info = var.tor_contact_info
  }))
}

# AWS EC2 Instance
resource "aws_instance" "tor_relay" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name              = var.key_name
  availability_zone     = var.availability_zone
  vpc_security_group_ids = [aws_security_group.tor_relay.id]
  
  user_data = local.user_data

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  tags = merge(var.tags, {
    Name = "tor-relay-${var.tor_nickname}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP
resource "aws_eip" "tor_relay" {
  instance = aws_instance.tor_relay.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "tor-relay-eip-${var.tor_nickname}"
  })
}
