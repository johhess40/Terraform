/*
NOTE: This module deploys connection monitor
*/
terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.conmontarget]
    }
  }
}

resource "azurerm_network_connection_monitor" "theconmon" {
  provider           = azurerm.conmontarget
  name               = var.conMonName
  network_watcher_id = var.conMonNetWatchId
  location           = var.conMonLocation


  dynamic "endpoint" {
    /*below variable becomes map(object)*/
    for_each = var.conMonEndpoints
    content {
      name               = endpoint.value["endpointName"]
      target_resource_id = endpoint.value["endpointTrgtResId"]
    }
  }


  dynamic "endpoint" {
    /*below variable becomes map(object)*/
    for_each = var.conMonOnPremEndpoints
    content {
      name    = endpoint.value["onPremEndpointName"]
      address = endpoint.value["onPremEndpointIp"]
    }
  }

  dynamic "test_configuration" {
    /*below variable becomes map(object)*/
    for_each = var.conMonTcpTestConfigs
    content {
      name                      = test_configuration.value["conMonTestTcpConfigName"]
      protocol                  = test_configuration.value["conMonTestTcpConfigProtocol"]
      test_frequency_in_seconds = test_configuration.value["conMonTestTcpConfigFreqSeconds"]

      tcp_configuration {
        port                = test_configuration.value["conMonTestTcpConfigPort"]
        trace_route_enabled = true
      }
    }
  }

  dynamic "test_configuration" {
    /*below variable becomes map(object)*/
    for_each = var.conMonIcmpTestConfigs
    content {
      name                      = test_configuration.value["conMonTestIcmpConfigName"]
      protocol                  = test_configuration.value["conMonTestIcmpConfigProtocol"]
      test_frequency_in_seconds = test_configuration.value["conMonTestIcmpConfigFreqSeconds"]

      icmp_configuration {
        trace_route_enabled = true
      }
    }
  }

  dynamic "test_group" {
    /*below variable becomes map(object)*/
    for_each = var.conMonTestGroups
    content {
      name = test_group.value["conMonTestGroupName"]
      /* List of string */
      destination_endpoints = test_group.value["conMonDestEndpoints"]
      /* List of string */
      source_endpoints = test_group.value["conMonSrcEndpoints"]
      /* List of string */
      test_configuration_names = test_group.value["conMonTestConfigNames"]
      enabled                  = test_group.value["conMonEnabled"]
    }
  }

  notes = var.conMonNotes

  // List of string
  output_workspace_resource_ids = var.conMonOutWrkSpcIds
}