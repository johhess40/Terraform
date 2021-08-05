/*
NOTE: This module is intended to be used with Private Endpoints/Private DNS
      -Private Endpoints will allow for Azure resources to communicate but limit public access
      -Private DNS allows for resolution between on prem and private endpoints
      -By assigning private IP's to Azure resources we can restrict access between resources based 
       on IP address as well!!!!
*/

terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.endpointtarget]
    }
  }
}


resource "azurerm_private_endpoint" "coredatapeps" {
  provider            = azurerm.endpointtarget
  name                = var.coreDataPeps.pepName
  location            = var.coreDataPeps.pepLocation
  resource_group_name = var.coreDataPeps.pepRgName
  subnet_id           = var.coreDataPeps.pepSubnetId

  private_service_connection {
    name                           = var.coreDataPeps.pepConnection.serviceName
    private_connection_resource_id = var.coreDataPeps.pepConnection.connectionResId
    subresource_names              = [var.coreDataPeps.pepConnection.subResNames]
    is_manual_connection           = var.coreDataPeps.pepConnection.manualConn
  }
}

resource "azurerm_private_dns_zone" "datacoredns" {
  provider            = azurerm.endpointtarget
  name                = var.corePrivDnsZones.privZoneName
  resource_group_name = var.corePrivDnsZones.privZoneRgName
  soa_record {
    email        = var.corePrivDnsZones.soaRecord.soaEmail
    expire_time  = var.corePrivDnsZones.soaRecord.soaExpireTime
    minimum_ttl  = var.corePrivDnsZones.soaRecord.soaMinTtl
    refresh_time = var.corePrivDnsZones.soaRecord.soaRefreshTime
    retry_time   = var.corePrivDnsZones.soaRecord.soaRetryTime
    ttl          = var.corePrivDnsZones.soaRecord.soaTtl
  }

  depends_on = [
    azurerm_private_endpoint.coredatapeps
  ]
}

resource "azurerm_private_dns_a_record" "coredatarecordsa" {
  provider            = azurerm.endpointtarget
  name                = var.coreDataARecords.aRcrdName
  zone_name           = var.coreDataARecords.aRcrdZoneName
  resource_group_name = var.coreDataARecords.aRcrdRgName
  ttl                 = var.coreDataARecords.aRcrdTtl
  //List of string below
  records = [
    azurerm_private_endpoint.coredatapeps.private_service_connection.0.private_ip_address
  ]

  depends_on = [
    azurerm_private_endpoint.coredatapeps,
    azurerm_private_dns_zone.datacoredns
  ]
}
