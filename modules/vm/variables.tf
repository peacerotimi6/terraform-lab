variable "vm_name" {
  type        = string
  description = "Name of the VM"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet where NIC will be attached"
}

variable "admin_username" {
  type        = string
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for VM login"
}