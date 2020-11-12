###############################################################################
# Google Compute Instance Configuration Module
# -----------------------------------------------------------------------------
# main.tf
###############################################################################

# The trimsuffix function is used to remove the trailing decimals from the FQDN
# since some variables will include the DNS zone with a trailing period and
# other variables may affix an extra decimal (two total). By removing the
# decimals, we can have predictability and them in where appropriate for
# the hostname (no decimal) and DNS record (decimal)

locals {
  instance_name = var.short_name
  instance_fqdn = trimsuffix(trimsuffix("${var.short_name}.${var.dns_zone_fqdn}", ".."), ".")
}

# Create additional disk volume for instance
resource "google_compute_disk" "storage_disk" {
  count = var.disk_storage_enabled ? 1 : 0

  labels = {
    gl_env_type           = lookup(var.labels, "gl_env_type", "undefined")
    gl_env_name           = lookup(var.labels, "gl_env_name", "undefined")
    gl_env_continent      = lookup(var.labels, "gl_env_continent", "undefined")
    gl_owner_email_handle = lookup(var.labels, "gl_owner_email_handle", "undefined")
    gl_owner_timezone     = lookup(var.labels, "gl_owner_timezone", "undefined")
    gl_entity             = lookup(var.labels, "gl_entity", "undefined")
    gl_dept               = lookup(var.labels, "gl_dept", "undefined")
    gl_dept_group         = lookup(var.labels, "gl_dept_group", "undefined")
    gl_resource_group     = lookup(var.labels, "gl_resource_group", "undefined")
    gl_resource_host      = lookup(var.labels, "gl_resource_host", "undefined")
    gl_resource_name      = "${lookup(var.labels, "gl_resource_name", "undefined")}-storage-disk"
    gl_resource_type      = "storage-disk"
  }
  name = "${var.labels.gl_resource_host}-storage-disk"
  size = var.disk_storage_size
  type = "pd-ssd"
  zone = var.gcp_region_zone
}

# Attach additional disk to instance, so that we can move this
# volume to another instance if needed later.
# This will appear at /dev/disk/by-id/google-{NAME}
resource "google_compute_attached_disk" "attach_storage_disk" {
  count = var.disk_storage_enabled ? 1 : 0

  device_name = "storage-disk"
  disk        = google_compute_disk.storage_disk[0].self_link
  instance    = google_compute_instance.instance.self_link
}

# Create an external IP for the instance
resource "google_compute_address" "external_ip" {
  address_type = "EXTERNAL"
  description  = "External IP for ${var.description}"
  /*
  labels = {
    gl_env_type           = lookup(var.labels, "gl_env_type", "undefined")
    gl_env_name           = lookup(var.labels, "gl_env_name", "undefined")
    gl_env_continent      = lookup(var.labels, "gl_env_continent", "undefined")
    gl_owner_email_handle = lookup(var.labels, "gl_owner_email_handle", "undefined")
    gl_owner_timezone     = lookup(var.labels, "gl_owner_timezone", "undefined")
    gl_entity             = lookup(var.labels, "gl_entity", "undefined")
    gl_dept               = lookup(var.labels, "gl_dept", "undefined")
    gl_dept_group         = lookup(var.labels, "gl_dept_group", "undefined")
    gl_resource_group     = lookup(var.labels, "gl_resource_group", "undefined")
    gl_resource_host      = lookup(var.labels, "gl_resource_host", "undefined")
    gl_resource_name      = "${lookup(var.labels, "gl_resource_name", "undefined")}-network-ip"
    gl_resource_type      = "network-ip"
  }
  */
  name   = "${var.labels.gl_resource_host}-network-ip"
  region = var.gcp_region
}

# Create a Google Compute Engine VM instance
resource "google_compute_instance" "instance" {
  description         = var.description
  deletion_protection = var.gcp_deletion_protection
  hostname            = local.instance_fqdn
  name                = var.short_name
  machine_type        = var.gcp_machine_type
  zone                = var.gcp_region_zone

  # Base disk for the OS
  boot_disk {
    initialize_params {
      type  = "pd-ssd"
      image = var.gcp_image
      size  = var.disk_boot_size
    }
    auto_delete = "true"
  }

  labels = {
    gl_env_type           = lookup(var.labels, "gl_env_type", "undefined")
    gl_env_name           = lookup(var.labels, "gl_env_name", "undefined")
    gl_env_continent      = lookup(var.labels, "gl_env_continent", "undefined")
    gl_owner_email_handle = lookup(var.labels, "gl_owner_email_handle", "undefined")
    gl_owner_timezone     = lookup(var.labels, "gl_owner_timezone", "undefined")
    gl_entity             = lookup(var.labels, "gl_entity", "undefined")
    gl_dept               = lookup(var.labels, "gl_dept", "undefined")
    gl_dept_group         = lookup(var.labels, "gl_dept_group", "undefined")
    gl_resource_group     = lookup(var.labels, "gl_resource_group", "undefined")
    gl_resource_host      = lookup(var.labels, "gl_resource_host", "undefined")
    gl_resource_name      = "${lookup(var.labels, "gl_resource_name", "undefined")}-compute-instance"
    gl_resource_type      = "compute-instance"
  }

  # This ignored_changes is required since we use a separate resource for attaching the disk
  lifecycle {
    ignore_changes = [attached_disk]
  }

  # Attach the primary network interface to the VM
  network_interface {
    subnetwork = var.gcp_subnetwork
    access_config {
      nat_ip = google_compute_address.external_ip.address
    }
  }

  # This sets a custom SSH key on the instance and prevents the OS Login and GCP
  # project-level SSH keys from working. This is commented out since we use
  # project-level SSH keys.
  # https://console.cloud.google.com/compute/metadata?project=my-project-name&authuser=1&supportedpurview=project
  #
  # metadata {
  #   sshKeys = "ubuntu:${file("keys/${var.ssh_public_key}.pub")}"
  # }

  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = var.gcp_preemptible ? "false" : "true"
    preemptible         = var.gcp_preemptible
  }

  # Tags in GCP are only used for network and firewall rules. Any metadata is
  # defined as a label (see above).
  tags = [
    "${var.labels.gl_resource_group}",
    "${var.labels.gl_resource_host}",
    "${var.network_firewall_rule_tag}"
  ]

}

# Create a DNS record
resource "google_dns_record_set" "dns_record" {
  count = var.dns_create_record ? 1 : 0

  managed_zone = var.dns_zone_name
  name         = "${local.instance_fqdn}."
  rrdatas      = [google_compute_address.external_ip.address]
  ttl          = var.dns_ttl
  type         = "A"
}
