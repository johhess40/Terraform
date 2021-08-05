/*
NOTE: This module is used to deploy Azure Purview service
      -Azure Purview is a unified data governance service that helps you manage
       and govern your on-premises, multi-cloud, and software-as-a-service data.
      -Azure Purview is a regional resource. so it does not move or store customer
       data outside of the region it is deployed in.
*/

resource "azurerm_purview_account" "example" {
  for_each            = var.purviewAccounts
  name                = each.value["puviewName"]
  resource_group_name = each.value["purviewRgName"]
  location            = each.value["purviewLocation"]
  sku_name            = each.value["purviewSku"]
}