# GCP Terraform Module for Compute Instance with DNS Record

## Table of Contents

* [Prerequisites for GitLab Sandbox Cloud Users](#prerequisites-for-gitlab-sandbox-cloud-users)
* [Prerequisites for Open Source Users](#prerequisties-for-open-source-users)
* [Step-by-Step Instructions](#step-by-step-instructions)
* [Variables, Outputs, and Additional Customization](#variables-outputs-and-additional-customization)

## Prerequisites for GitLab Sandbox Cloud Users

#### Access the GitOps Terraform repository

1. Navigate to the [GitLab Sandbox Cloud](https://gitlabsandbox.cloud) Web UI and create a new Cloud Account (GCP project) or select your existing Cloud Account. 

    > Each user only has one individual GCP project (Cloud Account), however multiple Terraform configurations ("Cloud Account Environments") are supported in the same GCP project to allow you to provision infrastructure for different purposes. 

    > We also have group GCP projects that allow team members to collaborate with the same shared infrastructure. Each group GCP project is just like an individual GCP project and supports multiple Terraform configurations that are independent from your individual GCP project.

2. In the GitLab Sandbox Cloud Web UI, select the `Getting Started` Cloud Account Environment or another Environment that you have created. If this is the first resource in a new Environment, you can create a new Cloud Account Environment (fresh Terraform configuration scaffolding) now before proceeding to the next step. 

3. Click the `Access GitOps Repository` link and use the provided credentials to sign in.

    > This is a self-manged GitLab Omnibus instance that has security hardening designed for Terraform CI pipelines. Each Cloud Account (GCP project) has a GitLab Group and each Cloud Account Environment (Terraform configuration) has a GitLab Project in that Group. 

4. If you are not automatically redirected to the project due to authentication redirecting you to the dashboard, navigate to the `gcp` `>` `{username}-{id}` `>` `{environment}-{id}` GitLab project.

#### Create an Issue and MR for the changes

5. Create a new Issue titled `Add {Compute Instance Name} to Terraform configuration`. [GitLab Docs](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#accessing-the-new-issue-form)

6. Create a **Merge Request** from the issue. [GitLab Docs](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-new-branch-from-an-issue)

7. Open the **Web IDE** for the Merge Request. [GitLab Docs](https://docs.gitlab.com/ee/user/project/web_ide/#open-the-web-ide)

    > For simplicity, these instructions use the Web IDE, however you can [configure your own SSH key](https://docs.gitlab.com/ee/ssh/#add-an-ssh-key-to-your-gitlab-account) and [clone the repository](https://docs.gitlab.com/ee/gitlab-basics/start-using-git.html#clone-with-ssh) to your machine to work with locally. 
    
    > Remember that all Terraform commands are run automatically by GitLab CI jobs (occurs automatically after commits and merges) and you should not type any `terraform [command]` on your local machine in your Terminal.

#### Add the module to the Terraform configuration

8. Navigate to and open the `main.tf` file in the Web IDE.

9. Scroll down to the `Add your Terraform modules and/or resources below this line` section.

10. In a separate browser tab, open the [gcp-compute-instance-tf-module:examples/experiment/main.tf](https://gitlab.com/gitlab-com/sandbox-cloud/terraform-modules/gcp/gcp-compute-instance-tf-module/-/blob/main/examples/sandbox-cloud/main.tf) file.

11. Copy and paste the contents of the example `main.tf` file into the Web IDE.

12. You can change any of the most of the variables that are strings (rendered in red in the Web IDE). You can see the [README.md#variables](https://gitlab.com/gitlab-com/sandbox-cloud/terraform-modules/gcp/gcp-compute-instance-tf-module/-/blob/main/README.md#variables) to learn more about expected values.

13. Navigate to and open the `outputs.tf` file in the Web IDE.

14. Scroll down to the `Add your Terraform modules and/or resources below this line` section.

15. In a separate browser tab, open the [gcp-compute-instance-tf-module:examples/experiment/outputs.tf](https://gitlab.com/gitlab-com/sandbox-cloud/terraform-modules/gcp/gcp-compute-instance-tf-module/-/blob/main/examples/sandbox-cloud/outputs.tf) file.

16. Copy and paste the contents of the example `outputs.tf` file into the Web IDE.

17. Click the blue `Commit` button in the left sidebar to save your changes. You can leave the commit message at the default value or change it to something descriptive if you prefer.

####

18. Navigate to the Merge 

When you create a Cloud Account, a "Getting Started" Cloud Account Environment is created that provides a Terraform configuration to help you get started easily. You can create additional Cloud Account Environments

1. Create a Git repository for your Terraform project, or use an existing repository with your Terraform configuration. **For security reasons, it is imperative that your [GitLab](https://docs.gitlab.com/ee/public_access/public_access.html#how-to-change-project-visibility) or [GitHub](https://docs.github.com/en/github/administering-a-repository/setting-repository-visibility) project is a `private` project (not `public` or `internal`) to avoid leaking your infrastructure credentials.**

1. Create a <a target="_blank" href="https://cloud.google.com/resource-manager/docs/creating-managing-projects">GCP project</a> or use an existing GCP project. You will need to decide which <a target="_blank" href="https://cloud.google.com/compute/docs/regions-zones">region and zone</a> you will use. The examples in this module use `us-east1` and `us-east1-c`.

1. In order to make requests against the GCP API, you need to authenticate to prove that it's you making the request. The preferred method of provisioning resources with Terraform is to use a GCP service account, which is a "robot account" that can be granted a limited set of IAM permissions. Use the [Terraform provider instructions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials) for creating a service account using the Google Cloud Console or `gcloud` CLI tool.

    > You can use the `GOOGLE_APPLICATION_CREDENTIALS` environment variable, however if you're working with multiple GCP projects you may find it easier to work use a key file in each of your repositories. In our examples, we use the `keys/gcp-service-account.json` file however you can name it whatever you would like (ex. my-project-name-a1b2c3d4.json).

    > It is important that you do not commit the service account `.json` file to your Git repository since this compromises your credentials. You should add the `/keys` directory to your `.gitignore` file. See the `.gitignore.example` file in this module for example configuration.

1. Create a <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network">VPC network</a> and <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork">subnetwork</a>. It is likely that the <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_network">VPC already exists</a> and you can use an <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork">existing subnet</a> using the data source instead of declaring a new resource in your Terraform configuration.

1. If you would like a DNS record to be created for the instance in GCP Cloud DNS, you will need to get the <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone">existing GCP Cloud DNS zone</a> or create a new DNS managed zone for a domain name that you own. If you are using AWS Route53 or another DNS service or this is for experimentation purposes only, you can set `dns_create_record` variable to `false` in the instance module block after copying the example from `main.tf`.

    ```
    module "{{name}}_instance" {
      # ...
      dns_create_record = "false"
      # ...
    }
    ```

1. Determine the instance name that uses alphanumeric characters and hyphens. (Example `app1`)


## Prerequisites for Open Source Users

1. Create a Git repository for your Terraform project, or use an existing repository with your Terraform configuration. **For security reasons, it is imperative that your [GitLab](https://docs.gitlab.com/ee/public_access/public_access.html#how-to-change-project-visibility) or [GitHub](https://docs.github.com/en/github/administering-a-repository/setting-repository-visibility) project is a `private` project (not `public` or `internal`) to avoid leaking your infrastructure credentials.**

1. Create a <a target="_blank" href="https://cloud.google.com/resource-manager/docs/creating-managing-projects">GCP project</a> or use an existing GCP project. You will need to decide which <a target="_blank" href="https://cloud.google.com/compute/docs/regions-zones">region and zone</a> you will use. The examples in this module use `us-east1` and `us-east1-c`.

1. In order to make requests against the GCP API, you need to authenticate to prove that it's you making the request. The preferred method of provisioning resources with Terraform is to use a GCP service account, which is a "robot account" that can be granted a limited set of IAM permissions. Use the [Terraform provider instructions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials) for creating a service account using the Google Cloud Console or `gcloud` CLI tool.

    > You can use the `GOOGLE_APPLICATION_CREDENTIALS` environment variable, however if you're working with multiple GCP projects you may find it easier to work use a key file in each of your repositories. In our examples, we use the `keys/gcp-service-account.json` file however you can name it whatever you would like (ex. my-project-name-a1b2c3d4.json).

    > It is important that you do not commit the service account `.json` file to your Git repository since this compromises your credentials. You should add the `/keys` directory to your `.gitignore` file. See the `.gitignore.example` file in this module for example configuration.

1. Create a <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network">VPC network</a> and <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork">subnetwork</a>. It is likely that the <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_network">VPC already exists</a> and you can use an <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork">existing subnet</a> using the data source instead of declaring a new resource in your Terraform configuration.

1. If you would like a DNS record to be created for the instance in GCP Cloud DNS, you will need to get the <a target="_blank" href="https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone">existing GCP Cloud DNS zone</a> or create a new DNS managed zone for a domain name that you own. If you are using AWS Route53 or another DNS service or this is for experimentation purposes only, you can set `dns_create_record` variable to `false` in the instance module block after copying the example from `main.tf`.

    ```
    module "{{name}}_instance" {
      # ...
      dns_create_record = "false"
      # ...
    }
    ```

1. Determine the instance name that uses alphanumeric characters and hyphens. (Example `app1`)


## Step-by-Step Instructions

**Reminder:** All double bracket `{{strings}}` should be replaced based on your desired configuration while preserving the hyphen or underscores syntax in each example.

1. Review the contents of `main.tf` in the appropriate [examples/ directory](examples/) to understand what is getting created. You can make changes as needed after you copy the example into your Terraform project.

1. Open your text editor and navigate to your new or existing Terraform project (also referred to as your "environment configuration").

1. Copy and paste the contents of `examples/{{example-name}}/main.tf` to the `main.tf` file in your Terraform project. You can add to the bottom of the file or create the file if it does not exist.

    > If the `provider "google" {}` and `provider "google-beta" {}` blocks already exist in your `main.tf` file, you do not need to add them twice.

1. Copy and paste the contents of `examples/{{example-name}}/outputs.tf` to the `outputs.tf` file in your Terraform project. You can add to the bottom of the file or create the file if it does not exist.

1. Copy and paste the contents of `examples/{{example-name}}/variables.tf` to the `variables.tf` file in your Terraform project. You can add to the bottom of the file or create the file if it does not exist.

1. Copy and paste the `examples/{{example-name}}/.gitignore.example` file to your Terraform project. If you do not have a `.gitignore` file, you can simply remove the `.example` extension. If you have a `.gitignore` file, take a few moments to add the lines from `.gitignore.example` to your existing file.

    > It is your discretion whether your `.tfvars` files are committed to your source code, however we have included them in the `.gitignore` as a security precaution.

1. Copy and paste the contents of `examples/{{example-name}}/terraform.tfvars.json` to the `terraform.tfvars.json` file in your Terraform project.

    > If you have an existing `terraform.tfvars` file or another `.tfvars` file, you can create the key/value pairs in your existing file using the appropriate syntax.

1. Update the values in `terraform.tfvars.json` to match your environment configuration. You can see a description of each of the variables in the `variables.tf` file.

    > The GCP project can be either the slug of the project or the 12-digit project ID. See the GCP documentation for [identifying projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects#identifying_projects) to learn more.

    ```
    {
        "gcp_dns_zone_name": "my-dns-zone-name",
        "gcp_project": "my-project-name-a1b2c3d4",
        "gcp_region": "us-east1",
        "gcp_region_zone": "us-east1-c"
    }
    ```

1. Create a new file named `gcp-service-account.json` in the `keys/` directory with your service account credentials JSON keyfile.

    ```
    {
      "type": "service_account",
      "project_id": "demosys-saas",
      "private_key_id": "NULL",
      "private_key": "-----BEGIN PRIVATE KEY-----\nNULL\n-----END PRIVATE KEY-----\n",
      "client_email": "NULL-compute@developer.gserviceaccount.com",
      "client_id": "NULL",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/NULL-compute%40developer.gserviceaccount.com"
    }
    ```

    > If you are using `gcloud` or `GOOGLE_APPLICATION_CREDENTIALS` environment variable, comment out or remove `credentials = file("./keys/gcp-service-account.json")` in the `provider "google" {}` and `provider "google-beta" {}` blocks in `main.tf`.

    ```
    # [terraform-project]/main.tf

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
    ```

1. Open your Terminal and navigate to the directory where your Terraform environment configuration resides.

    ```
    cd ~/Sites/terraform-project
    ```

1. Run `terraform init` to initialize your Terraform configuration and create a Terraform state file.

    ```
    terraform init
    ```

    > If there are any problems with authenticating with the Google API, you will see the errors during this step. These are generic Terraform errors and are not specific to this module usually. You should be able to perform a Google search to get help with the error message that you're seeing.

    ```
    Initializing modules...
    Downloading git::https://gitlab.com/gitlab-com/demo-systems/terraform-modules/gcp/gce/gcp-compute-instance-tf-module.git for experiment_instance...
    - experiment_instance in .terraform/modules/experiment_instance

    Initializing the backend...

    Initializing provider plugins...
    - Finding hashicorp/google-beta versions matching ">= 3.47.0"...
    - Finding hashicorp/google versions matching ">= 3.47.0"...
    - Installing hashicorp/google-beta v3.64.0...
    - Installed hashicorp/google-beta v3.64.0 (signed by HashiCorp)
    - Installing hashicorp/google v3.64.0...
    - Installed hashicorp/google v3.64.0 (signed by HashiCorp)

    Terraform has created a lock file .terraform.lock.hcl to record the provider
    selections it made above. Include this file in your version control repository
    so that Terraform can guarantee to make the same selections by default when
    you run "terraform init" in the future.

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ```

1. Run `terraform plan` to see how your Terraform configuration will make changes to your infrastructure.

    ```
    terraform plan
    ```

    ```
    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
      + create

    Terraform will perform the following actions:

      # module.experiment_instance.google_compute_address.external_ip will be created
      + resource "google_compute_address" "external_ip" {
          # ...
        }

      # module.experiment_instance.google_compute_instance.instance will be created
      + resource "google_compute_instance" "instance" {

        }

    Plan: 2 to add, 0 to change, 0 to destroy.
    ```

1. Run `terraform apply` to deploy the resources that were shown in the plan output. If you are using an existing Terraform project, it is strongly recommended to use targeting with `terraform apply -target=module.{{my_instance_name}}` to only make changes to the specific module(s) or resource(s) that you're working with.

    ```
    terraform apply -target=module.experiment_instance
    ```

    ```
    Do you want to perform these actions?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.

      Enter a value: yes

    module.experiment_instance.google_compute_address.external_ip: Creating...
    module.experiment_instance.google_compute_address.external_ip: Still creating... [10s elapsed]
    module.experiment_instance.google_compute_address.external_ip: Creation complete after 12s [id=projects/demosys-sandbox/regions/us-east1/addresses/app1-network-ip]
    module.experiment_instance.google_compute_instance.instance: Creating...
    module.experiment_instance.google_compute_instance.instance: Still creating... [10s elapsed]
    module.experiment_instance.google_compute_instance.instance: Creation complete after 13s [id=projects/demosys-sandbox/zones/us-east1-c/instances/terraform-module-experiment-instance]

    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

    Outputs:

    experiment_instance = {
      "disk_boot" = {
        "size" = "10"
      }
      "disk_storage" = {
        "enabled" = false
        "size" = "100"
      }
      "dns" = {
        "create_record" = false
        "instance_fqdn" = "null"
        "ttl" = "null"
        "zone_fqdn" = "null"
        "zone_name" = "null"
      }
      "gcp" = {
        "deletion_protection" = false
        "image" = "ubuntu-1804-lts"
        "machine_type" = "e2-standard-2"
        "project" = "demosys-sandbox"
        "region" = "us-east1"
        "region_zone" = "us-east1-c"
      }
      "instance" = {
        "description" = "Instance for Terraform module experiment"
        "hostname" = ""
        "id" = "projects/demosys-sandbox/zones/us-east1-c/instances/terraform-module-experiment-instance"
        "name" = "terraform-module-experiment-instance"
        "self_link" = "https://www.googleapis.com/compute/v1/projects/demosys-sandbox/zones/us-east1-c/instances/terraform-module-experiment-instance"
      }
      "labels" = {
        "gl_dept" = "sales-cs"
        "gl_dept_group" = "sales-cs-sa-us-west"
        "gl_entity" = "allocate"
        "gl_env_continent" = "america"
        "gl_env_name" = "cool-product-app-server"
        "gl_env_type" = "experiment"
        "gl_owner_email_handle" = "jmartin"
        "gl_owner_timezone" = "america-los_angeles"
        "gl_realm" = "sandbox"
        "gl_resource_group" = "app"
        "gl_resource_host" = "app1"
      }
      "network" = {
        "external_ip" = "34.74.247.177"
        "internal_ip" = "10.142.0.7"
        "subnetwork" = "https://www.googleapis.com/compute/v1/projects/demosys-sandbox/regions/us-east1/subnetworks/default"
        "tags" = [
          "app1"
          "firewall-ssh-web"
        ]
      }
    }
    experiment_instance_external_ip = "34.74.247.177"
    ```

1. If this was an experiment and you're ready to clean up your work, run `terraform destroy -target=module.{{my_instance_name}}` to destroy the resources that were created. If you are using an existing Terraform project, it is imperative that you use targeting with `terraform destroy` to only make changes to the specific module(s) or resource(s) that you're working with. **If you do not specify a target, all of your Terraform-managed infrastructure will be permanently destroyed and data loss will occur.**

    ```
    terraform destroy -target=module.{{my_instance_name}}
    ```

    ```
    module.experiment_instance.google_compute_address.external_ip: Refreshing state... [id=projects/demosys-sandbox/regions/us-east1/addresses/app1-network-ip]
    module.experiment_instance.google_compute_instance.instance: Refreshing state... [id=projects/demosys-sandbox/zones/us-east1-c/instances/terraform-module-experiment-instance]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
      - destroy

    Terraform will perform the following actions:

      # module.experiment_instance.google_compute_address.external_ip will be destroyed
      - resource "google_compute_address" "external_ip" {
          # ...
        }

      # module.experiment_instance.google_compute_instance.instance will be destroyed
      - resource "google_compute_instance" "instance" {
          # ...
        }

    Plan: 0 to add, 0 to change, 2 to destroy.

    Do you really want to destroy all resources?
      Terraform will destroy all your managed infrastructure, as shown above.
      There is no undo. Only 'yes' will be accepted to confirm.

      Enter a value: yes

    module.experiment_instance.google_compute_instance.instance: Destroying... [id=projects/demosys-sandbox/zones/us-east1-c/instances/terraform-module-experiment-instance]
    module.experiment_instance.google_compute_instance.instance: Still destroying... [id=projects/demosys-sandbox/zones/us-east1...s/terraform-module-experiment-instance, 10s elapsed]
    module.experiment_instance.google_compute_instance.instance: Still destroying... [id=projects/demosys-sandbox/zones/us-east1...s/terraform-module-experiment-instance, 20s elapsed]
    module.experiment_instance.google_compute_instance.instance: Still destroying... [id=projects/demosys-sandbox/zones/us-east1...s/terraform-module-experiment-instance, 30s elapsed]
    module.experiment_instance.google_compute_instance.instance: Still destroying... [id=projects/demosys-sandbox/zones/us-east1...s/terraform-module-experiment-instance, 40s elapsed]
    module.experiment_instance.google_compute_instance.instance: Still destroying... [id=projects/demosys-sandbox/zones/us-east1...s/terraform-module-experiment-instance, 50s elapsed]
    module.experiment_instance.google_compute_instance.instance: Destruction complete after 53s
    module.experiment_instance.google_compute_address.external_ip: Destroying... [id=projects/demosys-sandbox/regions/us-east1/addresses/app1-network-ip]
    module.experiment_instance.google_compute_address.external_ip: Still destroying... [id=projects/demosys-sandbox/regions/us-east1/addresses/app1-network-ip, 10s elapsed]
    module.experiment_instance.google_compute_address.external_ip: Destruction complete after 11s

    Destroy complete! Resources: 2 destroyed.  
    ```

## Variables, Outputs, and Additional Customization

See the [README.md](README.md) for more information on [variables](README.md#variables) and [outputs](README.md#outputs). You can review the [main.tf](main.tf) file to see all of the resources that are being created with this module, and the respective variables that can be configured to customize them.
