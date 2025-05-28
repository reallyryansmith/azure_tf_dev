resource_group_name  = "dev-network-rg"
location             = "East US"
vnet_name            = "dev-vnet"
vnet_address_space   = ["10.0.0.0/16"]
route_table_name     = "dev-rt"
blackhole_prefix     = "10.0.3.0/24"

subnets = {
  web = "10.0.1.0/24"
  app = "10.0.2.0/24"
}

vm_definitions = {
  web-vm = "web"
  app-vm = "app"
}