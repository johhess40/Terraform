##########################################################################
###This module deploys an Event Hub Namespace and associated Event Hubs###
##########################################################################
terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.eventhubtarget]
    }
  }
}

/*
NOTE: The namespace is a logcial container for Event Hubs!!!!
        -Multiple event hubs can share one namespace
        -Sku is important as certain skus have more capabilities
        -All events streamed to an event hub have a set retention period
*/

resource "azurerm_eventhub_namespace" "eventhubnmspc" {
  provider            = azurerm.eventhubtarget
  name                = var.eventHubNmSpc["eventHubNmSpcName"]
  location            = var.eventHubNmSpc["eventHubNmSpcLocation"]
  resource_group_name = var.eventHubNmSpc["eventHubNmSpcRgName"]
  sku                 = var.eventHubNmSpc["eventHubNmSpcSku"]
  capacity            = var.eventHubNmSpc["eventHubNmSpcCapacity"]

  tags = var.eventHubNmSpc["eventHubNmSpcTags"]
}

/* 
NOTE: It is necessary to export Activity Logs to Event Hub directly
        -Not doing this will require addtional configuration in KQL queries
        -Logrythm can ingest this data using the "Open Collector"?????
*/
resource "azurerm_storage_account" "eventhubstrg" {
  provider                 = azurerm.eventhubtarget
  for_each                 = var.eventHubStrg
  name                     = each.value["eventStrgName"]
  resource_group_name      = each.value["eventStrgRgName"]
  location                 = each.value["eventStrgLocation"]
  account_tier             = each.value["eventStrgTier"]
  account_replication_type = each.value["eventStrgRepl"]

  tags = each.value["eventStrgTags"]
}

resource "azurerm_storage_container" "eventhubcontainer" {
  provider              = azurerm.eventhubtarget
  for_each              = var.eventHubContainers
  name                  = each.value["eventCntnrName"]
  storage_account_name  = each.value["eventCntnrAccntName"]
  container_access_type = each.value["eventCntnrAccess"]

  depends_on = [
    azurerm_storage_account.eventhubstrg
  ]
}

resource "azurerm_eventhub" "eventhubs" {
  for_each            = var.eventHubs
  provider            = azurerm.eventhubtarget
  name                = each.value["eventHubName"]
  namespace_name      = azurerm_eventhub_namespace.eventhubnmspc.name
  resource_group_name = each.value["eventHubRgName"]
  partition_count     = each.value["eventHubPartCount"]
  message_retention   = each.value["eventHubMessageRetention"]

  dynamic "capture_description" {
    for_each = each.value["eventHubDestinations"]
    content {
      enabled             = true
      encoding            = "Avro"
      skip_empty_archives = true
      destination {
        name                = capture_description.value["destinationName"]
        archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
        blob_container_name = capture_description.value["blobContainerName"]
        storage_account_id  = capture_description.value["strgAccntId"]
      }
    }
  }

  depends_on = [
    azurerm_eventhub_namespace.eventhubnmspc,
    azurerm_storage_account.eventhubstrg
  ]
}
resource "azurerm_eventhub_namespace_authorization_rule" "authrules" {
  provider            = azurerm.eventhubtarget
  for_each            = var.eventhubNmspcAuthRules
  name                = each.value["ehRuleName"]
  namespace_name      = each.value["ehRuleNmspcName"]
  resource_group_name = each.value["ehRgName"]
  listen              = each.value["ehListen"]
  send                = each.value["ehSend"]
  manage              = each.value["ehManage"]
}

resource "azurerm_eventhub_authorization_rule" "eventhubauthrules" {
  provider            = azurerm.eventhubtarget
  for_each            = var.eventhubAuthRules
  name                = each.value["ehRuleName"]
  namespace_name      = each.value["ehRuleNmspcName"]
  eventhub_name       = each.value["ehEventHubName"]
  resource_group_name = each.value["ehRgName"]
  listen              = each.value["ehListen"]
  send                = each.value["ehSend"]
  manage              = each.value["ehManage"]
}


