##############################################################################################################
#
# FortiGate Terraform deployment in Google Cloud Platform (GCP)
# Single VM
#
##############################################################################################################
#
# Deployment of the virtual private cloud
#
##############################################################################################################

resource "google_compute_network" "vpc-external" {
  name                    = "${var.PREFIX}-vpc-external"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet-external" {
  name          = "${var.PREFIX}-subnet-external"
  ip_cidr_range = var.subnet-external["1"]
  network       = google_compute_network.vpc-external.self_link
  region        = var.REGION
}

resource "google_compute_network" "vpc-internal" {
  name                    = "${var.PREFIX}-vpc-internal"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet-internal" {
  name          = "${var.PREFIX}-subnet-internal"
  ip_cidr_range = var.subnet-internal["1"]
  network       = google_compute_network.vpc-internal.self_link
  region        = var.REGION
}

resource "google_compute_route" "route-internal" {
  name                   = "internal-route"
  dest_range             = "0.0.0.0/0"
  network                = google_compute_network.vpc-internal.self_link
  next_hop_instance      = google_compute_instance.fgt.name
  next_hop_instance_zone = var.ZONE
  priority               = 100

  depends_on = [
    google_compute_instance.fgt,
    google_compute_network.vpc-external,
    google_compute_network.vpc-internal,
  ]
}

resource "google_compute_firewall" "fw-inbound-allow-ports" {
  name    = "fw-inbound-allow-ports"
  network = google_compute_network.vpc-external.self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "22", "443", "8443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "fw-outbound-allow-all" {
  name    = "fw-outbound-allow-all"
  network = google_compute_network.vpc-internal.self_link

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

