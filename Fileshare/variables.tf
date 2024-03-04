
variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "netapp_address_spaces" {
  default     = ["10.0.2.0/24"]
  description = "NetApp subnet address space"
}

variable "prefix" {
  default     = "sco"
  description = "Prefix"
}

variable "virtual_network_name" {
  default     = "sco-virtual-network"
  
}