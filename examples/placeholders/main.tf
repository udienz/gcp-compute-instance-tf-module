# [terraform-project]/main.tf

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.47"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.47"
    }
  }
  required_version = ">= 0.13"
}

# Define the Google Cloud Provider
provider "google" {
  # credentials = file("./keys/gcp-service-account.json")
  project     = var.gcp_project
}

# Define the Google Cloud Provider with beta features
provider "google-beta" {
  # credentials = file("./keys/gcp-service-account.json")
  project     = var.gcp_project
}

# Get the existing network subnet
data "google_compute_subnetwork" "{{my_subnet_name}}" {
  name   = "{{my-subnet-name}}"
  region = var.gcp_region
}

# Provision a compute instance
module "{{name}}_instance" {
  source = "git::https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module.git"
  # source = "git::https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module.git?ref=0.4.0"

  # Required variables
  gcp_machine_type     = "e2-standard-2"
  gcp_project          = var.gcp_project
  gcp_region           = var.gcp_region
  gcp_region_zone      = var.gcp_region_zone
  gcp_subnetwork       = data.google_compute_subnetwork.{{my_subnet_name}}.self_link
  instance_description = "{{A description for what this instance does}}"
  instance_name        = "{{name}}"

  # Optional variables with default values
  disk_boot_size          = "10"
  disk_storage_enabled    = "false"
  disk_storage_mount_path = "/var/opt"
  disk_storage_size       = "100"
  dns_create_record       = "true"
  dns_ttl                 = "300"
  gcp_deletion_protection = "false"
  gcp_dns_zone_name       = var.gcp_dns_zone_name
  gcp_image               = var.gcp_image
  gcp_network_tags        = ["{{name}}", "{{firewall-rule-name}}"]

  # Labels for metadata and cost analytics
  labels = {
    "{{label_key1}}" = "{{label-value1}}"
    "{{label_key2}}" = "{{label-value2}}"
  }
}
