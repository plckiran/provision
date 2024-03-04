resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "${random_pet.prefix.id}-rg"
}


# Create virtual network
resource "azurerm_virtual_network" "vm" {
  name                = "${random_pet.prefix.id}-vnet"
  address_space       = "${var.vmnet_address_spaces}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


resource "random_pet" "prefix" {
  prefix = var.prefix
  length = 1
}
