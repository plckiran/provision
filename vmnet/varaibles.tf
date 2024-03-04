variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "vmnet_address_spaces" {
  default     = ["10.0.0.0/16"]
  description = "vmnet address space"
}

variable "prefix" {
  default     = "sco"
  description = "Prefix"
}