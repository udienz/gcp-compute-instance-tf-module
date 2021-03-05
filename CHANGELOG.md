# Compute Instance Terraform Module Changelog

## 0.4.0

This release updates the Git source path to this Terraform module since the GitLab.com project source path.

* [#10](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/10) - Update paths to project after GitLab group change
  * **Breaking Change:** The URL path to this module has changed.
    * Old Path: `gitlab-com/sandbox-cloud/tf-modules/gcp/gce/gcp-compute-instance-tf-module`
    * New Path: `gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module`
  * **Breaking Change:** Update `README` example usage `module source` to new path.
  * Update `CHANGELOG` links to issues to use new path

## 0.3.0

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

## 0.2.1

This release fixes regressions from the v0.2.0 release.

* [#5](https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/5) - Fix regression with legacy description variable in external IP address configuration
    Fix Error: `Reference to undeclared input variable` for `var.description` in `google_compute_address.external_ip`

## 0.2.0

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

## 0.1.0

* Initial release with tested resources
