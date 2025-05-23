# variables.tf

variable "subnets" {
  description = "Map of subnet names to CIDR blocks"
  type        = map(string)
}

variable "vm_definitions" {
  description = "Map of VM names to subnet keys"
  type        = map(string)
}

