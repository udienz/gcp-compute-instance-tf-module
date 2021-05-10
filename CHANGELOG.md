# Compute Instance Terraform Module Changelog

## 0.5.0 (Unreleased)

* [#19](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/19) - Add init script to format and mount data disk

## 0.4.0 (2021-04-20)

This release includes several major changes to make the Terraform module ready for production testing and general usage by the wider community outside of the GitLab Demo Systems.

* Tests now performed with Terraform v0.13, v0.14, and v0.15.
* [#10](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/10) - Update paths to project after GitLab group change
  * **Breaking Change:** The URL path to this module has changed.
    * Old Path: `gitlab-com/sandbox-cloud/tf-modules/gcp/gce/gcp-compute-instance-tf-module`
    * New Path: `gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module`
  * **Breaking Change:** Update `README` example usage `module source` to new path.
  * Update `CHANGELOG` links to issues to use new path
* [#11](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/11) - Update DNS zone data source into module rather than in environment configuration
  * **Breaking Change:** Renamed `dns_zone_name` variable to `gcp_dns_zone_name`. No changes to output key `dns.zone_name`.
  * **Breaking Change:** Removed `dns_zone_fqdn` variable. Output key still exists at `dns.zone_fqdn`.
* [#12](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/12) - Update example usage GCP machine type from `n1-standard-2` to `e2-standard-2`.
* [#13](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/12) - Refactor README example usage into examples/ directory structure to align with Terraform module best practices
* [#14](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/14) - Update README to add clarity on Terraform GCP provider authentication with environment variables and key files
* [#15](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/15) - Fix README with example usage label for `gl_env_name` to use alphadash syntax
* [#16](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/16) - Fix example usage outputs that is not a valid attribute of returned resource object
* [#17](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/17) - Remove GitLab infrastructure standards labels map from statically defined variables
  * **Breaking Change:** Removed `network_firewall_rule_tag` string variable and replaced with `gcp_network_tags` list.
    * The instance name is no longer automatically added as a label. It can be added to the `gcp_network_tags` list at your discretion.
    * The `firewall-ssh-web` rule that was automatically applied to previous instances is no longer applied and is now considered a legacy implementation.
    * The `network.firewall_rule_tag` output has been replaced with `network.tags` list (array).
  * **Breaking Change:** Removed `gl_*` GitLab infrastructure standards metadata labels to allow any label schema. This allows the module to be used outside of GitLab.
    * The `google_compute_disk.storage_disk` resource now uses `${var.instance_name}-storage-disk` label instead of `${var.gl_label.resource_host}-storage-disk`.
    * The `google_compute_address.external_ip` resource now uses `${var.instance_name}-network-ip` label instead of `${var.gl_label.resource_host}-network-ip`.

## 0.3.0 (2020-12-10)

This release increases the minimum Terraform version to v0.13 and removes the single version constraint to allow for v0.14+ usage.

* [#7](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/7) - Update `README` to add HCL syntax highlighting in code blocks
    * Update `README` to add hcl syntax highlighting to code blocks.
    * Update `README` to change placeholder strings to use `{{string}}` syntax.
    * Update `README` to fix outputs example to use dot notation based on array maps defined in `outputs.tf`.
* [#8](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/8) - Update Terraform minimum version to v0.13
    * **Breaking Change:** Updated required_version to >= 0.13.
    * Update `main.tf` to add `terraform { ... }` block.
    * Update `main.tf` to add `required_providers` block.
    * Remove `versions.tf` and move `required_version` to `main.tf`. This fixes the bug with the `~> v0.12` constraint.
    * Update `main.tf` to fix typo in `required_providers` with `aws` provider name instead of `google`
    * Update `main.tf` to add `google_beta` to `required_providers` block.
    * Update `README` to increase minimum Terraform version
    * Update `README` to refactor `provider` and `required_providers` block with new v0.13 syntax

## 0.2.1 (2020-11-14)

This release fixes regressions from the v0.2.0 release.

* [#5](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/5) - Fix regression with legacy description variable in external IP address configuration
    Fix Error: `Reference to undeclared input variable` for `var.description` in `google_compute_address.external_ip`

## 0.2.0 (2020-11-14)

This release renames some variables and refactors the output maps. The README also has been updated with fixes.

* [#1](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/1) - Remove deprecated interpolation-only expressions from labels map
    * Fixes deprecation warning message when running terraform plan regarding interpolation-only expressions.
* [#2](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/2) - Refactor outputs map to move second level maps to top-level maps
    * **Breaking Change:** Rename description input variable to instance_description.
    * **Breaking Change:** Rename short_name input variable to instance_name.
    * **Breaking Change:** Refactor outputs map array with new architecture. See outputs.tf and related issue for details.
* [#3](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/3) - Fix typo in `README` with non-Git module source in example usage
    * Updates the README example usage to change the module source from a local modules directory to the the remote Git source.
    * Changes 4-space indentation to 2-space in the example usage code block
* [#4](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/4) - Update `LICENSE.md` to change copyright owner from the project path to `GitLab Inc.`.

## 0.1.0 (2020-11-11)

* Initial release with tested resources
