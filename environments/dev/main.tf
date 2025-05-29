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

module "lb_web_cluster" {
  source              = "../../modules/lb_web_cluster"
  location            = module.networking.location
  resource_group_name = module.networking.resource_group_name
  subnet_id           = module.networking.web_subnet_id
  vm_names            = ["vm1", "vm2", "vm3"]
  ssh_public_key_path = var.ssh_public_key_path
  depends_on = [module.networking]
}

