provider "azurerm" {
  features {}
}

# Resource Group

resource "azurerm_resource_group" "rg" {
  name     = "velo-tf-lab-rg"
  location = var.location
}

# Virtual Network

resource "azurerm_virtual_network" "vnet" {
  name                = "velo-tf-vnet"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet

resource "azurerm_subnet" "subnet" {
  name                 = "velo-tf-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

# Call the VM module

module "app_vm" {
  source = "./modules/vm"

  vm_name             = "velo-module-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
}