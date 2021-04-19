# [terraform-project]/outputs.tf

# This will return a map with all of the outputs for the module
output "{{name}}_instance" {
    value = module.{{name}}_instance
}

# If you need a specific key as an output, you can use the dot notation shown above to access the map value.
output "{{name}}_instance_external_ip" {
    value = module.{{name}}_instance.network.external_ip
}
