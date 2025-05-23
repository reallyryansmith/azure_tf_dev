resource "azurerm_route_table" "rt_table_lab" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "blackhole" {
  name                   = "blackhole"
  resource_group_name    = var.resource_group_name
  route_table_name       = var.route_table_name
  address_prefix         = var.blackhole_prefix
  next_hop_type          = "None"
}

# Attach the route table to the "app" subnet
resource "azurerm_subnet_route_table_association" "rt_table_assign_app" {
  subnet_id      = azurerm_subnet.subnets["app"].id
  route_table_id = azurerm_route_table.rt_table_lab.id
}