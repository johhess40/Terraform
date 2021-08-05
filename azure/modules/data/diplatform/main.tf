/*
NOTE: This module deploys the data analytics core platform:
      -This is built off of the current deployment of DPi30 Resources
TODO: Validate resources for data analytics core
*/

provider "azurerm" {
  features {}

  alias           = "ingestion"
  subscription_id = var.ingestTarget
}

/*
NOTE: Calling sub modules for key vaults
*/
module "data_vaults" {
  providers = {
    azurerm.kvtarget = azurerm.ingestion
  }
  source = "./keyvault"
  // Pass in a map of objects
  dataKeyVaults = var.dataKeyVaults
}

/*
NOTE: Calling sub modules for data lakes
*/
module "data_lakes" {
  providers = {
    azurerm.datalaketarget = azurerm.ingestion
  }
  source = "./datalake"
  // Pass in a map of objects
  coreDataLakes = var.datalakeComponents.coreDataLakes
}

/*
NOTE: Calling sub modules for blob storage
*/
module "data_blobs" {
  providers = {
    azurerm.blobtarget = azurerm.ingestion
  }
  source        = "./genstorage"
  stgAccnts     = var.daStg.stgAccnts
}

module "data_df" {
  providers = {
    azurerm.datafactarget = azurerm.ingestion
  }
  source             = "./datafactory"
  dataFacs           = var.daDf.dataFacs
  azureRuntimes      = var.daDf.azureRuntimes
  selfHostedRuntimes = var.daDf.selfHostedRuntimes
  linkedBlobStorage  = var.daDf.linkedBlobStorage
  linkedKeyVault     = var.daDf.linkedKeyVault
  linkedDataLake     = var.daDf.linkedDataLake
  // snwFlake           = var.daDf.snwFlake

  depends_on = [
    module.data_vaults,
    module.data_lakes,
    module.data_blobs,
  ]
}

/*
NOTE: Deployment of Private DNS Zones and endpoints for data analytics platform
*/
module "core_data_networking" {
  providers = {
    azurerm.endpointtarget = azurerm.ingestion
  }
  source   = "./privateendpoints"
  for_each = var.coreDataNetworking
  // Pass in an object with a map of objects
  corePrivDnsZones = each.value["corePrivDnsZones"]
  coreDataARecords = each.value["coreDataARecords"]
  coreDataPeps     = each.value["coreDataPeps"]

  depends_on = [
    module.data_vaults,
    module.data_lakes,
    module.data_blobs,
    module.data_df
  ]
}

