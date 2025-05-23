variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
}

variable "blackhole_prefix" {
  description = "CIDR block to blackhole in route table"
  type        = string
}

variable "subnets" {
  description = "Map of subnet names to CIDR blocks"
  type        = map(string)
}

variable "vm_definitions" {
  description = "Map of VM names to subnet keys"
  type        = map(string)
}