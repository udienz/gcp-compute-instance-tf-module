# [terraform-project]/variables.tf

variable "gcp_dns_zone_name" {
  type        = string
  description = "The GCP Cloud DNS zone name to create instance DNS A record in. This is not the FQDN. (Example: gitlab-sandbox-root-zone)"
}

variable "gcp_image" {
  type        = string
  description = "The GCP image name. (Default: ubuntu-1804-lts)"
  default     = "ubuntu-1804-lts"
}

variable "gcp_project" {
  type        = string
  description = "The GCP project ID that the instance is deployed in. (Example: my-project-name)"
}

variable "gcp_region" {
  type        = string
  description = "The GCP region that the resources will be deployed in. (Ex. us-east1)"
}

variable "gcp_region_zone" {
  type        = string
  description = "The GCP region availability zone that the resources will be deployed in. This must match the region. (Example: us-east1-c)"
}
