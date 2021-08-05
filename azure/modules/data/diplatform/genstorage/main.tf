###################################################
###This module is used to create storage acounts###
###################################################

terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.blobtarget]
    }
  }
}


resource "azurerm_storage_account" "dastorage" {
  provider                 = azurerm.blobtarget
  for_each                 = var.stgAccnts
  name                     = each.value["accntName"]
  resource_group_name      = each.value["rgName"]
  location                 = each.value["accntLocation"]
  account_tier             = each.value["accntTier"]
  account_replication_type = each.value["replType"]

  network_rules {
    default_action             = each.value["defAction"]
    virtual_network_subnet_ids = each.value["subIds"]
  }
}