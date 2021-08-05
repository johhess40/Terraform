

/*
NOTE: Deploying KV to be used with Data Ingestion and Data Analytics core infrastructure
      -This key vault should have private endpoints and not be accessible over the internet
*/

terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.kvtarget]
    }
  }
}


resource "azurerm_key_vault" "corekeyvaults" {
  provider                    = azurerm.kvtarget
  for_each                    = var.dataKeyVaults
  name                        = each.value["kvName"]
  location                    = each.value["kvLocation"]
  resource_group_name         = each.value["kvRgName"]
  enabled_for_disk_encryption = each.value["kvDiskEncryptEnabled"]
  tenant_id                   = each.value["kvTenantId"]
  soft_delete_retention_days  = each.value["kvSoftRetentionDays"]
  purge_protection_enabled    = each.value["kvPurgeProtectEnabled"]
  sku_name                    = each.value["kvSku"]
  enabled_for_deployment      = each.value["kvEnabledForDeployment"]
  enable_rbac_authorization   = each.value["kvEnableRbac"]
  network_acls {
    //NOTE: This value can either be None or AzureServices
    bypass = each.value["netAcls"].netBypass
    //NOTE: This value must be either Allow or Deny
    default_action = each.value["netAcls"].defaultAction
    //NOTE: Subnets that should be allowed to hit the KV from private endpoints
    virtual_network_subnet_ids = each.value["netAcls"].subIds
  }
}