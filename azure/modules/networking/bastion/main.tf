###############################################################
###This module deploys a bastion host for connection to VM's###
###############################################################
terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.bastiontarget]
    }
  }
}
resource "azurerm_public_ip" "bastionpub" {
  provider            = azurerm.bastiontarget
  name                = var.bastionIpName
  location            = var.bastionIpLocation
  resource_group_name = var.bastionIpRgName
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "burlbastion" {
  provider            = azurerm.bastiontarget
  name                = var.bastionName
  location            = var.bastionLocation
  resource_group_name = var.bastionRgName

  ip_configuration {
    name                 = "${var.bastionName}-config"
    subnet_id            = var.bastionSubId
    public_ip_address_id = azurerm_public_ip.bastionpub.id
  }
}