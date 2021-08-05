/*
NOTE: This module deploys Azure Virtual WAN for S2S
      -Virtual Hubs will include S2S gateway
      -Address spaces need to be ironed out before
*/
terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.vwantarget]
    }
  }
}

resource "azurerm_virtual_wan" "wan" {
  // This should be an object
  provider                       = azurerm.vwantarget
  name                           = var.vwanConfigs.vwanName
  resource_group_name            = var.vwanConfigs.vwanRgName
  location                       = var.vwanConfigs.vwanLocation
  allow_branch_to_branch_traffic = var.vwanConfigs.vwanAllowTraffic
  type                           = var.vwanConfigs.vwanType
  tags                           = var.vwanConfigs.vwanTags
}

resource "azurerm_virtual_hub" "virtualhubs" {
  // This should be a map of objects
  provider            = azurerm.vwantarget
  for_each            = var.virthubConfigs
  name                = each.value["virthubName"]
  resource_group_name = each.value["virthubRgName"]
  location            = each.value["virthubLocation"]
  virtual_wan_id      = azurerm_virtual_wan.wan.id
  address_prefix      = each.value["virthubAddrPrefix"]

  depends_on = [
    azurerm_virtual_wan.wan
  ]
}

resource "azurerm_virtual_hub_connection" "virthubconnections" {
  // This should be a map of objects
  provider                  = azurerm.vwantarget
  for_each                  = var.virthubConnections
  name                      = each.value["virthubConnName"]
  virtual_hub_id            = each.value["virthubId"]
  remote_virtual_network_id = each.value["virthubRemoteNetId"]

  depends_on = [
    azurerm_virtual_wan.wan,
    azurerm_virtual_hub.virtualhubs
  ]
}

resource "azurerm_vpn_gateway" "gateways" {
  // This should be a map of objects
  provider            = azurerm.vwantarget
  for_each            = var.vwanVpnGatewayConfigs
  name                = each.value["vpnGatewayName"]
  location            = each.value["vpnGatewayLocation"]
  resource_group_name = each.value["vpnGatewayRgName"]
  virtual_hub_id      = each.value["vpnGatewayVirtHubId"]

  depends_on = [
    azurerm_virtual_wan.wan,
    azurerm_virtual_hub.virtualhubs
  ]
}

resource "azurerm_vpn_site" "sites" {
  // This should be a map of objects
  provider            = azurerm.vwantarget
  for_each            = var.vwanVpnSiteConfigs
  name                = each.value["vpnSiteName"]
  resource_group_name = each.value["vpnSiteRgName"]
  location            = each.value["vpnSiteLocation"]
  virtual_wan_id      = azurerm_virtual_wan.wan.id
  address_cidrs       = each.value["vpnSiteCidrs"]


  dynamic "link" {
    // This should be a map of objects
    for_each = each.value["siteLinks"]
    content {
      name       = link.value["siteLinkName"]
      ip_address = link.value["siteLinkIpAddress"]
    }
  }

  depends_on = [
    azurerm_virtual_wan.wan,
    azurerm_virtual_hub.virtualhubs,
    azurerm_vpn_gateway.gateways
  ]

}

resource "azurerm_vpn_gateway_connection" "connections" {
  provider           = azurerm.vwantarget
  for_each           = var.vwanVpnConnections
  name               = each.value["vpnConnName"]
  vpn_gateway_id     = each.value["vpnConnGtwyId"]
  remote_vpn_site_id = each.value["vpnConnRemoteSiteId"]

  dynamic "vpn_link" {
    for_each = each.value["gtwyConnLinks"]
    content {
      name             = vpn_link.value["vpnLinkName"]
      vpn_site_link_id = vpn_link.value["siteLinkId"]
      shared_key       = vpn_link.value["shrdKey"]
      dynamic "ipsec_policy" {
        for_each = vpn_link.value["ipsecPolicies"]
        content {
          dh_group                 = ipsec_policy.value["dhGroup"]
          ike_encryption_algorithm = ipsec_policy.value["ikeEncryption"]
          ike_integrity_algorithm  = ipsec_policy.value["ikeIntegrity"]
          encryption_algorithm     = ipsec_policy.value["ipsecEncryption"]
          integrity_algorithm      = ipsec_policy.value["ipsecIntegrity"]
          pfs_group                = ipsec_policy.value["pfsGroup"]
          sa_data_size_kb          = ipsec_policy.value["saDatasize"]
          sa_lifetime_sec          = ipsec_policy.value["saLifetime"]
        }
      }
    }
  }
  depends_on = [
    azurerm_virtual_wan.wan,
    azurerm_virtual_hub.virtualhubs,
    azurerm_vpn_gateway.gateways,
    azurerm_vpn_site.sites
  ]
}



##########################################################################################
#Deploying Firewall to create a secured hub!!!###
##########################################################################################

##################################################
###Need to add additional rules, policies, etc.###
##################################################

resource "azurerm_firewall" "burl_firewall" {
  provider            = azurerm.vwantarget
  for_each            = var.fwHubConfigs
  name                = each.value["fwName"]
  location            = each.value["fwLocation"]
  resource_group_name = each.value["fwRgName"]
  sku_tier            = each.value["fwSkuTier"]
  sku_name            = each.value["fwSkuName"]
  threat_intel_mode   = each.value["fwThrtIntMode"]
  virtual_hub {
    virtual_hub_id  = each.value["fwVirtHubId"]
    public_ip_count = each.value["fwPubIpCount"]
  }


  depends_on = [
    azurerm_virtual_wan.burlwan,
    azurerm_virtual_hub.burlvirtualhubs
  ]
}