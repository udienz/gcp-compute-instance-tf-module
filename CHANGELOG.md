# Compute Instance Terraform Module Changelog


## 0.2.0

This release renames some variables and refactors the output maps. The README also has been updated with fixes.

* [#1](https://gitlab.com/gitlab-com/sandbox-cloud/tf-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/1) - Remove deprecated interpolation-only expressions from labels map
    * Fixes deprecation warning message when running terraform plan regarding interpolation-only expressions.
* [#2](https://gitlab.com/gitlab-com/sandbox-cloud/tf-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/2) - Refactor outputs map to move second level maps to top-level maps
    * **Breaking Change:** Rename description input variable to instance_description.
    * **Breaking Change:** Rename short_name input variable to instance_name.
    * **Breaking Change:** Refactor outputs map array with new architecture. See outputs.tf and related issue for details.
* [#3](https://gitlab.com/gitlab-com/sandbox-cloud/tf-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/3) - Fix typo in `README` with non-Git module source in example usage
    * Updates the README example usage to change the module source from a local modules directory to the the remote Git source.
    * Changes 4-space indentation to 2-space in the example usage code block
* [#4](https://gitlab.com/gitlab-com/sandbox-cloud/tf-modules/gcp/gce/gcp-compute-instance-tf-module/-/issues/4) - Update `LICENSE.md` to change copyright owner from the project path to `GitLab Inc.`.

## 0.1.0

* Initial release with tested resources
