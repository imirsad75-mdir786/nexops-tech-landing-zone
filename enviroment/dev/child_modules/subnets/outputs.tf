output "subnet_outputs" {
  value = { for k, v in azurerm_subnet.main : k => { id = v.id } }
}