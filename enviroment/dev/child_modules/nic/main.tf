resource "azurerm_network_interface" "main" {
  for_each = var.network_interfaces

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    # ⚡ अगर .tfvars में नहीं लिखोगे, तो अपने आप "internal" मान लेगा
    name                          = lookup(each.value, "ip_config_name", "internal")
    
    # 🔥 पुराना 'module.subnets...' हटाकर सिर्फ यह लिखना है:
    subnet_id                     = each.value.subnet_id
    
    # ⚡ अगर .tfvars में नहीं लिखोगे, तो अपने आप "Dynamic" मान लेगा
    private_ip_address_allocation = lookup(each.value, "private_ip_allocation", "Dynamic")
  }
}
