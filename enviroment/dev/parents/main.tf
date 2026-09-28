# 1. RESOURCE GROUP MODULE
module "resource_group" {
  source          = "../child_modules/resource_group"
  resource_groups = var.resource_groups
}

# 2. VIRTUAL NETWORK MODULE
module "virtual_network" {
  source           = "../child_modules/virtual_network"
  virtual_networks = var.virtual_networks

  # Explicit Dependency!!
  depends_on = [module.resource_group]
}

# 3. SUBNETS MODULE
module "subnets" {
  source  = "../child_modules/subnets"
  subnets = var.subnets

  # Explicit Dependency:
  depends_on = [module.virtual_network]
}

# 4. PUBLIC IP MODULE
module "public_ip" {
  source    = "../child_modules/public_ip"
  public_ip = var.public_ip_addresses

  depends_on = [module.resource_group]
}

# 5. NSG (Network Security Group) MODULE
module "nsg" {
  source = "../child_modules/nsg"
  nsgs   = var.nsgs

  depends_on = [module.resource_group]
}

# 6. NETWORK INTERFACE (NIC) MODULE
module "network_interface" {
  source = "../child_modules/nic"

  # यहाँ पैरेंट लेवल पर ही .tfvars के डेटा में लाइव सबनेट ID को इंजेक्ट किया जा रहा है
  network_interfaces = {
    for k, v in var.network_interfaces : k => {
      name                = v.name
      location            = v.location
      resource_group_name = v.resource_group_name
      
      subnet_id           = module.subnets.subnet_outputs[v.subnet_key].id
    }
  }

  depends_on = [module.subnets]
}


# 7. VIRTUAL MACHINE MODULE
module "virtual_machine" {
  source = "../child_modules/virtual_machine"

  virtual_machines = {
    for k, v in var.virtual_machines : k => {
      # ये चीज़ें सीधे .tfvars से आ रही हैं
      name                  = v.name
      location              = v.location
      resource_group_name   = v.resource_group_name
      admin_username        = v.admin_username
      admin_password        = v.admin_password
      network_interface_ids = [module.network_interface.nic_outputs[v.nic_key].id]

      # 🔥 असली फिक्स: यहाँ lookup() लगाना ज़रूरी है ताकि अगर .tfvars में ये न हों, तो पैरेंट डिफ़ॉल्ट वैल्यू आगे भेजे
      size            = lookup(v, "size", "Standard_B1s")
      os_disk_caching = lookup(v, "os_disk_caching", "ReadWrite")
      os_disk_type    = lookup(v, "os_disk_type", "Standard_LRS")
      image_publisher = lookup(v, "image_publisher", "Canonical")
      image_offer     = lookup(v, "image_offer", "0001-com-ubuntu-server-jammy")
      image_sku       = lookup(v, "image_sku", "22_04-lts")
      image_version   = lookup(v, "image_version", "latest")
    }
  }

  depends_on = [module.network_interface]
}
