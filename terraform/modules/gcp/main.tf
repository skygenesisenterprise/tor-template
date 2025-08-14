# GCP Firewall Rules
resource "google_compute_firewall" "tor_relay_ssh" {
  name    = "tor-relay-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["tor-relay"]
}

resource "google_compute_firewall" "tor_relay_ports" {
  name    = "tor-relay-ports"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9001", "9030"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["tor-relay"]
}

# GCP Compute Instance
resource "google_compute_instance" "tor_relay" {
  name         = "tor-relay-instance"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = templatefile("${path.module}/startup-script.sh", {
    tor_nickname     = var.tor_nickname
    tor_contact_info = var.tor_contact_info
  })

  tags = ["tor-relay"]

  labels = var.labels

  service_account {
    scopes = ["cloud-platform"]
  }
}
