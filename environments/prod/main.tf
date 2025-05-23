module "networking" {
  source              = "../../modules/networking"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  route_table_name    = var.route_table_name
  blackhole_prefix    = var.blackhole_prefix
  subnets             = var.subnets
  vm_definitions      = var.vm_definitions
}