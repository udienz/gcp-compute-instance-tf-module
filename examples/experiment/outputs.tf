# [terraform-project]/outputs.tf

# This will return a map with all of the outputs for the module
output "experiment_instance" {
  value = module.experiment_instance
}

# If you need a specific key as an output, you can use the dot notation shown above to access the map value.
output "experiment_instance_external_ip" {
  value = module.experiment_instance.network.external_ip
}
