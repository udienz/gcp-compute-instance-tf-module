## GCP Terraform Module for Compute Instance with DNS Record

This Terraform module is designed to be used for creating a compute instance with associated DNS record.

### Version Compatibility

* Minimum Terraform v0.12
* Tested and stable with v0.13

### Prerequisites

1. Create a Terraform Git repository or use an existing repository.

2. Create a <a target="_blank" href="https://cloud.google.com/resource-manager/docs/creating-managing-projects">GCP project</a> and decide which <a target="_blank" href="https://cloud.google.com/compute/docs/regions-zones">region and zone</a> you will use.

3. Add new variables in your Terraform repository that can be reused throughout your configuration. You can choose to <a target="_blank" href="https://www.terraform.io/docs/configuration/variables.html">add default values to each variable or use environment variables<a/>.

4. Add the `google` and `google-beta` <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs">provider</a> to your environment configuration near the top of the file. Use `gcloud` or a service account for adding your credentials to your local environment.

> It is important that you do not commit the service account `.json` file to your Git repository since this compromises your credentials.

5. Create a <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network">VPC network</a> and <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork">subnetwork</a>. It is likely that the <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_network">VPC already exists</a> and you can use an <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork">existing subnet</a> using the data source instead of declaring a new resource in your Terraform configuration.

6. Get the <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone">existing GCP Cloud DNS zone</a>.

7. Determine the instance name that uses alphanumeric characters and hyphens. (Example `app1`)

### Example Usage

> All double bracket `{{strings}}` should be replaced based on your desired configuration while preserving the hyphen or underscores syntax in each example.

```hcl
# [my-project]/main.tf

# Define the Google Cloud Provider
provider "google" {
  credentials = file("./keys/gcp-service-account.json")
  project     = var.gcp_project
  version     = "~>3.47"
}

# Define the Google Cloud Provider with beta features
provider "google-beta" {
  credentials = file("./keys/gcp-service-account.json")
  project     = var.gcp_project
  version     = "~>3.47"
}

# Get the existing network subnet
data "google_compute_subnetwork" "{{my_subnet_name}}" {
  name   = "{{my-subnet-name}}"
  region = var.gcp_region
}

# Get the existing DNS zone
data "google_dns_managed_zone" "dns_zone" {
  name = "{{my-dns-zone-name}}"
}

# Provision a compute instance
module "{{name}}_instance" {
  source = "git::https://gitlab.com/gitlab-com/sandbox-cloud/tf-modules/gcp/gce/gcp-compute-instance-tf-module.git"

  # Required variables
  dns_zone_fqdn        = data.google_dns_managed_zone.dns_zone.fqdn
  dns_zone_name        = data.google_dns_managed_zone.dns_zone.name
  gcp_machine_type     = "n1-standard-2"
  gcp_project          = var.gcp_project
  gcp_region           = var.gcp_region
  gcp_region_zone      = var.gcp_region_zone
  gcp_subnetwork       = data.google_compute_subnetwork.{{my_subnet_name}}.self_link
  instance_description = "App server for a cool purpose"
  instance_name        = "app1"

  # Optional variables with default values
  disk_boot_size            = "10"
  disk_storage_enabled      = "false"
  disk_storage_size         = "100"
  dns_create_record         = "true"
  dns_ttl                   = "300"
  gcp_deletion_protection   = "false"
  gcp_image                 = "ubuntu-1804-lts"
  network_firewall_rule_tag = "firewall-ssh-web"

  # Labels for metadata and cost analytics
  # The labels in this module are part of GitLab's internal infrastructure
  # standards that are used for owner identification and cost allocation.
  # https://about.gitlab.com/handbook/infrastructure-standards/labels-tags/
  labels = {
    "gl_env_type"           = "experiment"
    "gl_env_name"           = "Cool Product - App Server"
    "gl_env_continent"      = "america"
    "gl_owner_email_handle" = "jmartin"
    "gl_owner_timezone"     = "america-los_angeles"
    "gl_entity"             = "allocate"
    "gl_realm"              = "sandbox"
    "gl_dept"               = "sales-cs"
    "gl_dept_group"         = "sales-cs-sa-us-west"
    "gl_resource_group"     = "app"
    "gl_resource_host"      = "app1"
  }
}
```

```hcl
# [my-project]/variables.tf

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
```

```hcl
# [my-project]/outputs.tf

# This will return a map with all of the outputs for the module
output "{{name}}_instance" {
    value = module.{{name}}_instance
}

# If you need a specific key as an output, you can use the dot notation shown above to access the map value.
output "{{name}}_instance_external_ip" {
    value = module.{{name}}_instance.network_external_ip
}
```

### Variables

We use top-level variables where possible instead of maps to allow easier handling of default values with partially defined maps, and reduce complexity for developers who are just getting started with Terraform syntax.

<table>
<thead>
<tr>
    <th style="width: 25%;">Variable Key</th>
    <th style="width: 40%;">Description</th>
    <th style="width: 10%;">Required</th>
    <th style="width: 25%;">Example Value</th>
</tr>
</thead>
<tbody>
<tr>
    <td>
        <code>disk_boot_size</code>
    </td>
    <td>The size in GB of the OS boot volume.</a></td>
    <td>No</td>
    <td><code>10</code> <small>(default)</small></td>
</tr>
<tr>
    <td>
        <code>disk_storage_enabled</code>
    </td>
    <td>True to attach storage disk. False to only have boot disk.</a></td>
    <td>No</td>
    <td><code>false</code> <small>(default)</small></td>
</tr>
<tr>
    <td>
        <code>disk_storage_size</code>
    </td>
    <td>The size in GB of the storage volume.</a></td>
    <td>No</td>
    <td><code>100</code> <small>(default)</small></td>
</tr>
<tr>
    <td>
        <code>dns_create_record</code>
    </td>
    <td>True to create a DNS record. False to only return an IP address.</a></td>
    <td>No</td>
    <td><code>true</code> <small>(default)</small></td>
</tr>
<tr>
    <td>
        <code>dns_ttl</code>
    </td>
    <td>TTL of DNS Record for instance.</a></td>
    <td>No</td>
    <td><code>300</code> <small>(default)</small></td>
</tr>
<tr>
    <td>
        <code>dns_zone_fqdn</code>
    </td>
    <td>The FQDN of the <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone">DNS managed zone</a> (with or without trailing period) that the instance hostname should be added as an A record for.</td>
    <td><strong>Yes</strong></td>
    <td><code>gitlabsandbox.cloud</code></td>
</tr>
<tr>
    <td>
        <code>dns_zone_name</code>
    </td>
    <td>The name of the <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone">DNS managed zone</a> that the instance hostname should be added as an A record for. This is not the FQDN of the domain.</td>
    <td><strong>Yes</strong></td>
    <td><code>gitlab-sandbox-root-zone</code></td>
</tr>
<tr>
    <td>
        <code>gcp_deletion_protection</code>
    </td>
    <td>Enable this to prevent Terraform from accidentally destroying the instance with terraform destroy command.</a></td>
    <td>No</td>
    <td><code>false</code> <small>(default)</small></td>
</tr>
<tr>
    <td>
        <code>gcp_image</code>
    </td>
    <td>The <a target="_blank" href="https://cloud.google.com/compute/docs/images">GCP image</a> name.</a></td>
    <td>No</td>
    <td><code>ubuntu-1804-lts</code> <small>(default)</small></td>
</tr>
<tr>
    <td>
        <code>gcp_machine_type</code>
    </td>
    <td>The <a target="_blank" href="https://cloud.google.com/compute/docs/machine-types">GCP machine type</a>.</td>
    <td><strong>Yes</strong></td>
    <td><code>n1-standard-2</code></td>
</tr>
<tr>
    <td>
        <code>gcp_preemptible</code>
    </td>
    <td>Enable this to allow this instance to terminate for <a target="_blank" href="https://cloud.google.com/compute/docs/instances/preemptible">preemtible reasons</a>. This can cause configuration and data loss.</a></td>
    <td>No</td>
    <td><code>false</code> <small>(default)</small></td>
</tr>
<tr>
    <td>
        <code>gcp_project</code>
    </td>
    <td>The <a target="_blank" href="https://cloud.google.com/resource-manager/docs/creating-managing-projects">GCP project ID</a> (may be a alphanumeric slug).</td>
    <td><strong>Yes</strong></td>
    <td>
        <code>123456789012</code><br /><br />
        <code>my-project-name</code>
    </td>
</tr>
<tr>
    <td>
        <code>gcp_region</code>
    </td>
    <td>The <a target="_blank" href="https://cloud.google.com/compute/docs/regions-zones">GCP region</a> that the resources will be deployed in.</td>
    <td><strong>Yes</strong></td>
    <td><code>us-east1</code></td>
</tr>
<tr>
    <td>
        <code>gcp_region_zone</code>
    </td>
    <td>The <a target="_blank" href="https://cloud.google.com/compute/docs/regions-zones">GCP region availability zone</a> that the resources will be deployed in. This must match the region.</td>
    <td><strong>Yes</strong></td>
    <td><code>us-east1-c</code></td>
</tr>
<tr>
    <td>
        <code>gcp_subnetwork</code>
    </td>
    <td>The object or self link for the <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork">subnetwork resource</a> or <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork">data object</a> in the parent modules.</td>
    <td><strong>Yes</strong></td>
    <td>
        <code>google_compute_subnetwork.app_subnetwork.self_link</code><br />
        <code>data.google_compute_subnetwork.app_subnetwork.self_link</code>
    </td>
</tr>
<tr>
    <td>
        <code>instance_description</code>
    </td>
    <td>Instance description.</td>
    <td><strong>Yes</strong></td>
    <td><code>App server for a cool purpose</code></td>
</tr>
<tr>
    <td>
        <code>instance_name</code><br />
    </td>
    <td>The short name (hostname) of the VM instance that will become an A record in the DNS zone that you specify.</a></td>
    <td><strong>Yes</strong></td>
    <td><code>app1</code></td>
</tr>
<tr>
    <td>
        <code>labels</code><br /><br />
        <br />
        <code>labels</code><br />
        <code>labels.gl_env_type</code>
    </td>
    <td>Labels to place on the instance and child resources. See <a target="_blank" href="https://about.gitlab.com/handbook/infrastructure-standards/labels-tags/">GitLab infrastructure standards</a>.</td>
    <td>No <small>(Recommended)</small></td>
    <td>
        <code>{</code><br />
        <code>"gl_env_type"           = "experiment"</code><br />
        <code>"gl_env_name"           = "Cool Product - App Server"</code><br />
        <code>"gl_env_continent"      = "america"</code><br />
        <code>"gl_owner_email_handle" = "jmartin"</code><br />
        <code>"gl_owner_timezone"     = "america-los_angeles"</code><br />
        <code>"gl_entity"             = "allocate"</code><br />
        <code>"gl_realm"              = "sandbox"</code><br />
        <code>"gl_dept"               = "sales-cs"</code><br />
        <code>"gl_dept_group"         = "sales-cs-sa-us-west"</code><br />
        <code>"gl_resource_group"     = "app"</code><br />
        <code>"gl_resource_host"      = "app1"</code><br />
        <code>}</code><br />
    </td>
</tr>
<tr>
    <td>
        <code>network_firewall_rule_tag</code>
    </td>
    <td>Tag for the existing <a target="_blank" href="https://cloud.google.com/vpc/docs/add-remove-network-tags">firewall rule</a> set that you want to apply for ingress traffic.</a></td>
    <td>No</td>
    <td><code>firewall-ssh-web</code> <small>(default)</small></td>
</tr>
</tbody>
</table>

### Outputs

The outputs are returned as a map with sub arrays that use dot notation. You can see how each output is defined in [outputs.tf](outputs.tf).

```hcl
# Get a map with all values for the module
module.{{name}}_instance

# Get individual values
module.{{name}}_instance.disk_boot.size
module.{{name}}_instance.disk_storage.enabled
module.{{name}}_instance.disk_storage.size
module.{{name}}_instance.dns.ttl
module.{{name}}_instance.dns.zone_fqdn
module.{{name}}_instance.dns.zone_name
module.{{name}}_instance.dns.instance_fqdn
module.{{name}}_instance.gcp.deletion_protection
module.{{name}}_instance.gcp.image
module.{{name}}_instance.gcp.machine_type
module.{{name}}_instance.gcp.project
module.{{name}}_instance.gcp.region
module.{{name}}_instance.gcp.region_zone
module.{{name}}_instance.instance.description
module.{{name}}_instance.instance.hostname
module.{{name}}_instance.instance.id
module.{{name}}_instance.instance.name
module.{{name}}_instance.instance.self_link
module.{{name}}_instance.labels
module.{{name}}_instance.network.external_ip
module.{{name}}_instance.network.firewall_rule_tag
module.{{name}}_instance.network.internal_ip
module.{{name}}_instance.network.subnetwork
```

### Authors and Maintainers

* Jeff Martin / @jeffersonmartin / jmartin@gitlab.com
