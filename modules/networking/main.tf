resource "azurerm_resource_group" "rg_lab" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet_lab" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = "${each.key}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [each.value]
}