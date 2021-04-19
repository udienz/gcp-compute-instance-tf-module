# GCP Terraform Module for Compute Instance with DNS Record

This Terraform module is designed to be used for creating a compute instance with associated DNS record.

## Table of Contents

* [Version Compatibility](#version-compatibility)
* [Usage Instructions](#usage-instructions)
    * [Prerequisites](INSTALL.md#prerequisites)
    * [Step-by-Step Instructions](INSTALL.md#step-by-step-instructions)
    * [Variables, Outputs, and Additional Customization](INSTALL.md#variables-outputs-and-additional-customization)
    * [Experiment Example](#experiment-example)
    * [Placeholders Example](#placeholders-example)
    <!--* [GitLab Demo Systems Example](#gitlab-demo-systems-example)-->
    <!--* [GitLab Sandbox Cloud Example](#gitlab-sandbox-cloud-example)-->
* [Variables](#variables)
* [Outputs](#outputs)
* [Authors and Maintainers](#authors-and-maintainers)

## Version Compatibility

* Minimum Terraform v0.13
* Tested with Terraform v0.13, v0.14, v0.15
* See the [hashicorp/terraform CHANGELOG](https://github.com/hashicorp/terraform/blob/master/CHANGELOG.md) for future breaking and deprecation changes

## Usage Instructions

See [INSTALL.md](INSTALL.md) for step-by-step instructions for using this Terraform module.

### Experiment Example

This example includes a basic configuration to get you started with using this module for the first time or a proof-of-concept use case.
* [examples/experiment/main.tf](examples/experiment/main.tf)
* [examples/experiment/outputs.tf](examples/experiment/outputs.tf)
* [examples/experiment/terraform.tfvars.json](examples/experiment/terraform.tfvars.json)
* [examples/experiment/variables.tf](examples/experiment/variables.tf)

### Placeholders Example

This example includes bracket placeholders for you to easily copy and paste into your own environment configuration and start using this module for any use case.
* [examples/placeholders/main.tf](examples/placeholders/main.tf)
* [examples/placeholders/outputs.tf](examples/placeholders/outputs.tf)
* [examples/placeholders/variables.tf](examples/placeholders/variables.tf)

<!--
### GitLab Demo Systems Example

This example includes the best practice configuration that is used by the GitLab Demo Systems team for our infrastructure. You can use this to learn from, however the variables and configuration are customized for our environment and are not designed to be used outside of the demo systems environment. You should use the `Placeholders` example for implementing this module in your environment.
* [examples/gitlab-demo-systems/main.tf](examples/gitlab-demo-systems/main.tf)
* [examples/gitlab-demo-systems/outputs.tf](examples/gitlab-demo-systems/outputs.tf)
* [examples/gitlab-demo-systems/variables.tf](examples/gitlab-demo-systems/variables.tf)

### GitLab Sandbox Cloud Example

This example includes the best practice configuration for GitLab team members that are using the GitLab Sandbox Cloud with their own GCP project. This has been customized with the GitLab infrastructure standards labels configuration. You should use the `Placeholders` example for implementing this module in your environment.
* [examples/gitlab-sandbox-cloud/main.tf](examples/gitlab-sandbox-cloud/main.tf)
* [examples/gitlab-sandbox-cloud/outputs.tf](examples/gitlab-sandbox-cloud/outputs.tf)
* [examples/gitlab-sandbox-cloud/variables.tf](examples/gitlab-sandbox-cloud/variables.tf)
-->

## Variables

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
        <code>gcp_deletion_protection</code>
    </td>
    <td>Enable this to prevent Terraform from accidentally destroying the instance with terraform destroy command.</a></td>
    <td>No</td>
    <td><code>false</code> <small>(default)</small></td>
</tr>
<tr>
    <td>
        <code>gcp_dns_zone_name</code>
    </td>
    <td>The name of the <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone">DNS managed zone</a> that the instance hostname should be added as an A record for. This is not the FQDN of the domain.</td>
    <td>No</td>
    <td><code>gitlab-sandbox-root-zone</code></td>
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
    <td><code>e2-standard-2</code></td>
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
        <code>"gl_env_name"           = "cool-product-app-server"</code><br />
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

## Outputs

The outputs are returned as a map with sub arrays that use dot notation. You can see how each output is defined in [outputs.tf](outputs.tf).

```hcl
# Get a map with all values for the module
module.{{name}}_instance

# Get individual values
module.{{name}}_instance.disk_boot.size
module.{{name}}_instance.disk_storage.enabled
module.{{name}}_instance.disk_storage.size
module.{{name}}_instance.dns.create_record
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

## Authors and Maintainers

* Jeff Martin / @jeffersonmartin / jmartin@gitlab.com
