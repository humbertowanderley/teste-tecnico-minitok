provider "google" {
  credentials = file("${path.module}/../../credentials/gcp_credentials.json")
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.zone
}

resource "google_compute_address" "static_ip" {
  name   = "parse-server-ip"
  region = "us-central1"
}

resource "google_compute_instance" "parse_vm" {
  name         = "parse-server-vm"
  machine_type = "e2-micro" # compatível com o tier gratuito
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size  = 10
    }
  }

  network_interface {
    network       = "default"
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata_startup_script = templatefile("${path.module}/start_script.sh.tpl", {
    parse_app_id       = var.parse_app_id
    parse_master_key   = var.parse_master_key
    parse_client_key   = var.parse_client_key
    database_uri = var.database_uri
  })

  tags = ["http-server"]
}

resource "google_compute_firewall" "allow-https" {
  name    = "allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}


resource "google_compute_firewall" "allow-parse-server-port" {
  name    = "allow-parse-server-port"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["1337"]
  }

  source_ranges = ["0.0.0.0/0"]
}
