###################################################
###This module is used to create storage acounts###
###################################################
terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.strgaccnttarget]
    }
  }
}

resource "azurerm_storage_account" "strg" {
  provider                 = azurerm.strgaccnttarget
  for_each                 = var.stgaccounts
  name                     = each.value["accntname"]
  resource_group_name      = each.value["rgname"]
  location                 = each.value["location"]
  account_tier             = each.value["tier"]
  account_replication_type = each.value["repl_type"]
}

resource "azurerm_storage_container" "strgcntnrs" {
  provider = azurerm.strgaccnttarget
  //Use variables you can iterate over
  for_each              = var.containers
  name                  = each.value["name"]
  storage_account_name  = each.value["stg_accnt_name"]
  container_access_type = each.value["access_type"]

  depends_on = [
    azurerm_storage_account.strg
  ]
}