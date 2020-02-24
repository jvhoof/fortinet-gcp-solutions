##############################################################################################################
#
# FortiGate Terraform deployment in Google Cloud Platform (GCP)
# Single VM
#
##############################################################################################################

# Prefix for all resources created for this deployment in Microsoft Azure
variable "PREFIX" {
  description = "Added name to each deployed resource"
}

variable "REGION" {
  description = "GCP region"
}

variable "ZONE" {
  description = "GCP zone"
}

variable "PROJECT" {
  description = "GCP project name"
}

#variable "USERNAME" {}

#variable "PASSWORD" {}

##############################################################################################################
# FortiGate VM and image
##############################################################################################################

variable "fgt_machine_type" {
  default = "n1-standard-2"
}

variable "fgt_image" {
  default = "https://console.cloud.google.com/compute/imagesDetail/projects/infra-lodge-268907/global/images/fgt-v6-build1066"
#  default = "https://www.googleapis.com/compute/v1/projects/fortigcp-project-001/global/images/fortinet-fgtondemand-623-20191223-001-w-license"
}

variable "FGT_BYOL_LICENSE_FILE" {
  default = ""
}

variable "FGT_SSH_PUBLIC_KEY_FILE" {
  default = ""
}

##############################################################################################################
# Deployment in Google Cloud Platform
##############################################################################################################

provider "google" {
  credentials = file("~/.ssh/infra-lodge-268907-645e17abb2a9.json")
  project     = var.PROJECT
  region      = var.REGION
}

##############################################################################################################
# Static variables
##############################################################################################################

variable "vpc-external" {
  description = "VPC external"
  default = "172.16.48.0/25"
}

variable "vpc-internal" {
  description = "VPC external"
  default = "172.16.48.128/25"
}

variable "subnet-external" {
  type        = map
  description = ""

  default = {
    "1" = "172.16.48.0/27"        # External
  }
}

variable "subnet-internal" {
  type        = map
  description = ""

  default = {
    "1" = "172.16.48.128/27"        # Internal
  }
}

variable "subnetmask" {
  type        = map
  description = ""

  default = {
    "1" = "27"        # External
    "2" = "27"        # Internal
  }
}


variable "fgt_ipaddress_a" {
  type        = map
  description = ""

  default = {
    "1" = "172.16.48.3"        # External
    "2" = "172.16.48.130"       # Internal
  }
}

variable "gateway_ipaddress" {
  type        = map
  description = ""

  default = {
    "1" = "172.16.48.1"        # External
    "2" = "172.16.48.133"      # Internal
  }
}

##############################################################################################################
