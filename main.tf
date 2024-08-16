
resource "azurerm_resource_group" "petGroup" {
  name     = "${var.prefix}-resources"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["192.168.0.0/26"]
  location            = azurerm_resource_group.petGroup.location
  resource_group_name = azurerm_resource_group.petGroup.name
}

resource "azurerm_subnet" "internal" {
  count      = length(var.public_subnet_cidrs)
  name                 = "${element(var.envs, count.index)}-subnet-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.petGroup.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [element(var.public_subnet_cidrs, count.index)]
}

# resource "aws_subnet" "public_subnets" {
#  count      = length(var.public_subnet_cidrs)
#  vpc_id     = aws_vpc.main.id
#  cidr_block = element(var.public_subnet_cidrs, count.index)
 
#  tags = {
#    Name = "Public Subnet ${count.index + 1}"
#  }
# }

# Public IPs
resource "azurerm_public_ip" "pip" {
  count                = var.vm_count
  name                 = "pip-${count.index + 1}"
  location             = azurerm_resource_group.petGroup.location
  resource_group_name  = azurerm_resource_group.petGroup.name
  allocation_method    = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  count               = length(azurerm_subnet.internal)
  name                = "${element(var.envs, count.index)}-nic-${count.index + 1}"
  location            = azurerm_resource_group.petGroup.location
  resource_group_name = azurerm_resource_group.petGroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = element(azurerm_subnet.internal.*.id, count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}



# resource "azurerm_network_interface" "main" {
#   name                = "${var.prefix}-nic"
#   location            = azurerm_resource_group.petGroup.location
#   resource_group_name = azurerm_resource_group.petGroup.name

#   ip_configuration {
#     name                          = "testconfiguration1"
#     subnet_id                     = azurerm_subnet.internal.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }



# give each vm a public ip
# Put ssh key in all vm
