output "nic_outputs" {
  value = { for k, v in azurerm_network_interface.main : k => { id = v.id } }
}
