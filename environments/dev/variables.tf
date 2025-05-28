variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "route_table_name" {
  type = string
}

variable "blackhole_prefix" {
  type = string
}

variable "subnets" {
  type = map(string)
}

variable "vm_definitions" {
  type = map(string)
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

