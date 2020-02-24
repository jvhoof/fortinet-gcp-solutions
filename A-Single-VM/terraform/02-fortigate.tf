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

resource "google_compute_address" "fgt_public_ip" {
  name         = "${var.PREFIX}-fgt-public-ip"
  address_type = "EXTERNAL"
  region       = var.REGION
}

resource "google_compute_address" "fgt_external_ip" {
  name         = "${var.PREFIX}-fgt-external-ip"
  subnetwork   = google_compute_subnetwork.subnet-external.self_link
  address_type = "INTERNAL"
  address      = var.fgt_ipaddress_a["1"]
  region       = var.REGION
}

resource "google_compute_address" "fgt_internal_ip" {
  name         = "${var.PREFIX}-fgt-internal-ip"
  subnetwork   = google_compute_subnetwork.subnet-internal.self_link
  address_type = "INTERNAL"
  address      = var.fgt_ipaddress_a["2"]
  region       = var.REGION
}

resource "google_compute_instance" "fgt" {
  name                      = "${var.PREFIX}-fgt"
  machine_type              = var.fgt_machine_type
  zone                      = var.ZONE
  can_ip_forward            = true

  metadata = {
    license : file("${var.FGT_BYOL_LICENSE_FILE}")
#    user-data : data.template_file.fgt_a_custom_data.rendered
  }
  network_interface {
    subnetwork    = google_compute_subnetwork.subnet-external.self_link
    network_ip    = google_compute_address.fgt_external_ip.address
    access_config {
      nat_ip = google_compute_address.fgt_public_ip.address
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.subnet-internal.self_link
    network_ip    = google_compute_address.fgt_internal_ip.address
  }

  boot_disk {
    initialize_params {
      image = var.fgt_image
    }
  }
}

data "template_file" "fgt_a_custom_data" {
  template = "${file("${path.module}/customdata.tpl")}"

  vars = {
    fgt_vm_name = "${var.PREFIX}-fgt"
    fgt_external_ipaddr = var.fgt_ipaddress_a["1"]
    fgt_external_mask = var.subnetmask["1"]
    fgt_external_gw =  var.gateway_ipaddress["1"]
    fgt_internal_ipaddr = var.fgt_ipaddress_a["2"]
    fgt_internal_mask = var.subnetmask["2"]
    fgt_internal_gw =  var.gateway_ipaddress["2"]
    vpc_internal =  var.vpc-internal
  }
}
