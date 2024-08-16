resource "azurerm_subnet" "mangement" {

  name                 = "mangemnet_subnet"
  resource_group_name  = azurerm_resource_group.petGroup.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.mangement_subnet_cidr
}

resource "azurerm_public_ip" "pip_management" {
  count                = var.pipelne_vm_count
  name                 = "pip_management-${count.index + 1}"
  location             = azurerm_resource_group.petGroup.location
  resource_group_name  = azurerm_resource_group.petGroup.name
  allocation_method    = "Dynamic"
}

resource "azurerm_network_interface" "pipleine" {
  count               = var.pipelne_vm_count
  name                = "mangementinterface-pipline-${count.index + 1}"
  location            = azurerm_resource_group.petGroup.location
  resource_group_name = azurerm_resource_group.petGroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = element(azurerm_subnet.mangement.*.id, count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_management[count.index].id
  }
}
resource "azurerm_linux_virtual_machine" "vm_mangement" {
  count                = var.pipelne_vm_count
  name                 = "vm-${(var.env_mangement)}-${count.index + 1}"
  location             = azurerm_resource_group.petGroup.location
  resource_group_name  = azurerm_resource_group.petGroup.name
  network_interface_ids = [
    azurerm_network_interface.pipleine[count.index].id,
  ]
  size                 = "Standard_DS1_v2"
  admin_username       = "adminuser"

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
    environment = "mangement"
  }
}