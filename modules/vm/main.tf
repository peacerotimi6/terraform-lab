##############################################
# Exercise:
# Complete this module to create:
# 1. Public IP
# 2. Network Interface
# 3. Linux Virtual Machine
##############################################


############################
# 1. CREATE PUBLIC IP
############################


resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku = "Standard"
}

# STUDENTS WRITE THIS RESOURCE


############################
# 2. CREATE NETWORK INTERFACE
############################

resource "azurerm_network_interface" "vm_network_interface" {
  name                = "vm_network_interface"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

# STUDENTS WRITE THIS RESOURCE


############################
# 3. CREATE LINUX VIRTUAL MACHINE - SIMPLE CONFIG
############################

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "velo-module-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_E8-2ds_v4"

 admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.vm_network_interface.id
  ]
  
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

   os_disk {
     caching              = "ReadWrite"
     storage_account_type = "Standard_LRS"
    }
    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16_04-lts-gen2"
        version   = "latest"
    }
}



resource "tls_private_key" "vm_ssh_key" {
 algorithm = "RSA"
 rsa_bits  = 4096
}


resource "local_file" "private_key" {
 content  = tls_private_key.vm_ssh_key.private_key_pem
 filename = "vm_key"
 file_permission = "0600"
}

