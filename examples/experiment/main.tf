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
  credentials = file("./keys/gcp-service-account.json")
  project     = var.gcp_project
}

# Define the Google Cloud Provider with beta features
provider "google-beta" {
  credentials = file("./keys/gcp-service-account.json")
  project     = var.gcp_project
}

# Get the existing network subnet
data "google_compute_subnetwork" "default_subnet" {
  name   = "default"
  region = var.gcp_region
}

# Provision a compute instance
module "experiment_instance" {
  source = "git::https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module.git"
  # source = "git::https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module.git?ref=0.4.0"

  # Required variables
  gcp_machine_type     = "e2-standard-2"
  gcp_project          = var.gcp_project
  gcp_region           = var.gcp_region
  gcp_region_zone      = var.gcp_region_zone
  gcp_subnetwork       = data.google_compute_subnetwork.default_subnet.self_link
  instance_description = "Instance for Terraform module experiment"
  instance_name        = "terraform-module-experiment-instance"

  # Optional variables with default values
  dns_create_record = "false"
  gcp_dns_zone_name = var.gcp_dns_zone_name
  gcp_image         = "ubuntu-1804-lts"

}
