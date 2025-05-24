resource_group_name  = "prod-network-rg"
location             = "East US 2"
vnet_name            = "prod-vnet"
vnet_address_space   = ["10.10.0.0/16"]
route_table_name     = "prod-rt"
blackhole_prefix     = "10.10.3.0/24"

subnets = {
  web = "10.10.1.0/24"
  app = "10.10.2.0/24"
}

vm_definitions = {
  web-vm = "web"
  app-vm = "app"
}

ssh_public_key_path = "~/.ssh/id_ed25519.pub"
