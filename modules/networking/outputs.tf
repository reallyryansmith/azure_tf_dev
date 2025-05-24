output "location" {
  value = azurerm_resource_group.rg_lab.location
}

output "resource_group_name" {
  value = azurerm_resource_group.rg_lab.name
}

output "web_subnet_id" {
  value = azurerm_subnet.subnets["web"].id
}

