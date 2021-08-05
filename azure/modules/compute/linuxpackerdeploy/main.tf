/*
This module deploys Linux VM's from custom images
built using Packer/Ansible
*/
terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.vmtarget]
    }
  }
}

resource "azurerm_network_interface" "vmnic" {
  provider            = azurerm.vmtarget
  name                = var.linuxNicName
  location            = var.linuxVmNicLocation
  resource_group_name = var.linuxVmNicRgName

  ip_configuration {
    name                          = "${var.linuxNicName}-config-01"
    subnet_id                     = var.linuxVmSubnetId
    private_ip_address_allocation = "Static"
    private_ip_address            = var.linuxVmNicPrivIp
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  provider                        = azurerm.vmtarget
  name                            = var.linuxVmName
  resource_group_name             = azurerm_network_interface.vmnic.resource_group_name
  location                        = azurerm_network_interface.vmnic.location
  size                            = var.linuxVmSize
  admin_username                  = var.linuxVmAdminUsername
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vmnic.id,
  ]

  admin_password = var.linuxVmAdminPassword

  os_disk {
    caching              = var.linuxOsDiskCaching
    storage_account_type = var.linuxOsDiskStrgType
  }

  source_image_id = var.srcImgId
}

resource "azurerm_virtual_machine_extension" "linuxvmextend" {
  /*This is going to loop through a map of objects that define what extensions
  we need enabled on linux virtual machines...*/
  provider                   = azurerm.vmtarget
  for_each                   = var.linuxVmExtensions
  name                       = each.value["extensionName"]
  virtual_machine_id         = azurerm_linux_virtual_machine.linuxvm.id
  publisher                  = each.value["extensionPublisher"]
  type                       = each.value["extensionType"]
  type_handler_version       = each.value["typeHandlerVersion"]
  auto_upgrade_minor_version = each.value["autoUpgradeMinVersion"]

  depends_on = [
    azurerm_linux_virtual_machine.linuxvm
  ]
}