resource "azurerm_linux_virtual_machine" "main" {
  for_each = var.virtual_machines

  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = false
  network_interface_ids           = each.value.network_interface_ids

  os_disk {
    caching              = each.value.os_disk_caching
    storage_account_type = each.value.os_disk_type
  }

  source_image_reference {
    publisher = each.value.image_publisher
    offer     = each.value.image_offer
    sku       = each.value.image_sku
    version   = each.value.image_version
  }
}
