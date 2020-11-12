###############################################################################
# Google Compute Instance Configuration Module
# -----------------------------------------------------------------------------
# outputs.tf
###############################################################################

# We use a single output value called `outputs` so that we can return a map of
# all outputs in a parent configuration with a single line without needing to
# declare each output key.

output "outputs" {
  value = {
    description = google_compute_instance.instance.description
    disk_boot = {
      size = var.disk_boot_size
    }
    disk_storage = {
      enabled = var.disk_storage_enabled
      size    = var.disk_storage_size
    }
    dns = {
      create_record = var.dns_create_record
      ttl           = var.dns_create_record ? var.dns_ttl : "null"
      zone_fqdn     = var.dns_create_record ? var.dns_zone_fqdn : "null"
      zone_name     = var.dns_create_record ? var.dns_zone_name : "null"
      instance_fqdn = var.dns_create_record ? local.instance_fqdn : "null"
    }
    gcp = {
      deletion_protection = var.gcp_deletion_protection
      image               = var.gcp_image
      machine_type        = var.gcp_machine_type
      project             = var.gcp_project
      region              = var.gcp_region
      region_zone         = var.gcp_region_zone
    }
    hostname = google_compute_instance.instance.hostname
    id       = google_compute_instance.instance.id
    labels   = var.labels
    name     = google_compute_instance.instance.name
    network = {
      external_ip       = google_compute_address.external_ip.address
      firewall_rule_tag = var.network_firewall_rule_tag
      internal_ip       = google_compute_instance.instance.network_interface[0].network_ip
      subnetwork        = var.gcp_subnetwork
    }
    self_link = google_compute_instance.instance.self_link
  }
}
