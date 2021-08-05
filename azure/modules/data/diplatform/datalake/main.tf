/*
NOTE: Deploying Data Lake Storage for Data Analytics
      -This is done by specifying the Hierchical Namespace
*/

terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.datalaketarget]
    }
  }
}


resource "azurerm_storage_account" "coredatalakes" {
  provider                 = azurerm.datalaketarget
  for_each                 = var.coreDataLakes
  name                     = each.value["lakeName"]
  resource_group_name      = each.value["lakeRgName"]
  location                 = each.value["lakeLocation"]
  account_tier             = each.value["lakeAccntTier"]
  account_replication_type = each.value["lakeReplType"]
  is_hns_enabled           = true

  network_rules {
    //This block is necessary for allowing cross tenant access to resources such as Snowflake
    default_action = each.value["netRules"].defaultAction
    //TODO: Attempt to add subnet ID's from Snowflake here
    virtual_network_subnet_ids = each.value["netRules"].subIds
  }

}