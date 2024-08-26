# This is to create Vms in app environment (dev,test,prod)

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "vm-${element(var.envs, count.index)}-${count.index + 1}"
  location            = azurerm_resource_group.petGroup.location
  resource_group_name = azurerm_resource_group.petGroup.name
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]
  size           = "Standard_DS1_v2"
  admin_username = "adminuser"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.ssh_public_key)
  }

  tags = {
    environment = "staging"
  }
}

#postgress

# resource "azurerm_resource_group" "example" {
#   name     = "example-resources"
#   location = "West Europe"
# }

# resource "azurerm_network_security_group" "nsg_db" {
#   name                = "nsg-postgres"
#   count               =  length(azurerm_network_interface.nic)
#   location            = azurerm_resource_group.petGroup.location
#   resource_group_name = azurerm_resource_group.petGroup.!

#   security_rule {
#     name                       = "AllowPostgresAccess"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "5432"
#      source_address_prefixes= element(azurerm_network_interface.nic.ip_configuration[0].*.private_ip_address, count.index)
#     # wsource_address_prefixes    =[for nic in azurerm_network_interface.nic : nic.ip_configuration[0].private_ip_address]

#     destination_address_prefix = "*"
#   }
# }


# psql -h postgress-dev-1 -U psqladmin -W

# psqladmin@postgress-dev-1
