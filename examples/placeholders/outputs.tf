# [terraform-project]/outputs.tf

# This will return a map with all of the outputs for the module
output "example_instance" {
  value = module.example_instance
}

# If you need a specific key as an output, you can use the dot notation shown above to access the map value.
output "example_instance_external_ip" {
  value = module.example_instance.network.external_ip
}
