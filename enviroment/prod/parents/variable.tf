variable "resource_groups" {
  type        = map(any)
  description = "Resource Groups ka nested map"
}

variable "virtual_networks" {
  type        = map(any)
  description = "Virtual Networks ka nested map"
}

variable "subnets" {
  type        = map(any)
  description = "Subnets ka nested map"
}

variable "public_ip_addresses" {
  type        = map(any)
  description = "Public IPs ka nested map"
}

variable "nsgs" {
  type        = map(any)
  description = "Network Security Groups ka nested map"
}

variable "network_interfaces" {
  type        = map(any)
  description = "Network Interfaces (NIC) ka nested map"
}

variable "virtual_machines" {
  type        = map(any)
  description = "Virtual Machines ka nested map"
}
