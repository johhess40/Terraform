################################################################################
###This module deploys a log analytics workspace and links to storage account###
################################################################################
terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.logtarget]
    }
  }
}

resource "azurerm_log_analytics_workspace" "burlloganalytics" {
  provider            = azurerm.logtarget
  name                = var.logWrkSpaceName
  location            = var.logWrkSpaceLocation
  resource_group_name = var.logWrkSpaceRgName
  sku                 = var.logWrkSpaceSku
  retention_in_days   = var.logRetentionDays
  tags                = var.logWrkSpaceTags
}

resource "azurerm_log_analytics_linked_storage_account" "burlloganalyticslinkstrg" {
  provider              = azurerm.logtarget
  data_source_type      = var.logAnalyticsDataSrcType
  resource_group_name   = azurerm_log_analytics_workspace.burlloganalytics.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.burlloganalytics.id
  // List of string
  storage_account_ids = var.logAnalyticsStrAccntIds
  depends_on          = [azurerm_log_analytics_workspace.burlloganalytics]
}
