data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}
# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  location            = azurerm_resource_group.petGroup.location
  resource_group_name = azurerm_resource_group.petGroup.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${chomp(data.http.myip.response_body)}/32"
    destination_address_prefix = "*"
  }
}

# Network Security Group Association for apps env
resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  count                   = length(var.public_subnet_cidrs)
  subnet_id               = azurerm_subnet.internal[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Network Security Group Association for mangement env
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_mangement" {
  count                   = length(var.mangement_subnet_cidr)
  subnet_id               = azurerm_subnet.mangement.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}