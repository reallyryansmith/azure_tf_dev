# Public IP for Load Balancer
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

# Load Balancer resource
resource "azurerm_lb" "lb" {
  name                = "basic-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }

  depends_on = [azurerm_public_ip.lb_public_ip]
}

# Backend address pool
resource "azurerm_lb_backend_address_pool" "lb_pool" {
  name            = "lb-backend-pool"
  loadbalancer_id = azurerm_lb.lb.id

  depends_on = [azurerm_lb.lb]
}

# Health probe
resource "azurerm_lb_probe" "http" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.lb.id
  port            = 80

  depends_on = [azurerm_lb.lb]
}

# Load Balancer rule
resource "azurerm_lb_rule" "http" {
  name                            = "http-rule"
  loadbalancer_id                 = azurerm_lb.lb.id
  protocol                        = "Tcp"
  frontend_port                   = 80
  backend_port                    = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.lb_pool.id]
  probe_id                        = azurerm_lb_probe.http.id

  depends_on = [azurerm_lb_backend_address_pool.lb_pool, azurerm_lb_probe.http]
}

# NAT rules for SSH
resource "azurerm_lb_nat_rule" "ssh" {
  for_each                        = toset(var.vm_names)
  name                            = "ssh-${each.key}"
  resource_group_name             = var.resource_group_name
  loadbalancer_id                 = azurerm_lb.lb.id
  protocol                        = "Tcp"
  frontend_port                   = 4000 + index(var.vm_names, each.key)
  backend_port                    = 22
  frontend_ip_configuration_name = "PublicIPAddress"

  depends_on = [azurerm_lb.lb]
}

# Availability Set for VMs
resource "azurerm_availability_set" "lb_avset" {
  name                         = "lb-vm-avset"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

# Network Interface for VMs
resource "azurerm_network_interface" "vm_nic" {
  for_each            = toset(var.vm_names)
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_lb_nat_rule.ssh]
}

# Associate NICs to Backend Pool
resource "azurerm_network_interface_backend_address_pool_association" "assoc" {
  for_each              = toset(var.vm_names)
  network_interface_id  = azurerm_network_interface.vm_nic[each.key].id
  ip_configuration_name = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_pool.id

  depends_on = [azurerm_network_interface.vm_nic, azurerm_lb_backend_address_pool.lb_pool]
}

# Associate NICs to NAT Rules
resource "azurerm_network_interface_nat_rule_association" "nat" {
  for_each              = toset(var.vm_names)
  network_interface_id  = azurerm_network_interface.vm_nic[each.key].id
  ip_configuration_name = "internal"
  nat_rule_id           = azurerm_lb_nat_rule.ssh[each.key].id

  depends_on = [azurerm_network_interface.vm_nic, azurerm_lb_nat_rule.ssh]
}

# Virtual Machines
resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = toset(var.vm_names)
  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]
  availability_set_id = azurerm_availability_set.lb_avset.id

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key_path)
  }

  custom_data = base64encode(<<EOF
#!/bin/bash
apt-get update
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx
echo "Hello from ${each.key}" > /var/www/html/index.html
EOF
  )

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.vm_nic,
    azurerm_availability_set.lb_avset,
    azurerm_network_interface_backend_address_pool_association.assoc,
    azurerm_network_interface_nat_rule_association.nat
  ]
}

