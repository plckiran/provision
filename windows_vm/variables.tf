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


variable "image_reference_sku" {
  default   = "2019-datacenter-azure-edition"
  description = "Image version/sku"
}

variable "vmnet_subnet_address_spaces" {
  default     = ["10.0.10.0/24"]
  description = "vmnet subnet address space"
}

variable "vm_admin_username" {
  default     = "azureuser"
  description = "azure vm admin user"
}
variable "security_rule_name" {
  default = "RDP"
  description = "Virtual machine security rule name"  
}

variable "security_rule_direction" {
  default = "Inbound"
}

variable "security_rule_priority" {
  default = 1000
  description = " vm security rule priority"
}

variable "security_rule_access" {
  default = "Allow"
}

variable "security_rule_protocol" {
  default = "*"
}

variable "security_rule_destination_port_range" {
  default = "3389"      
}
         