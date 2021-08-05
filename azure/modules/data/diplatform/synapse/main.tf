/*
NOTE: Deploying Synapse workspace and additional spark pools etc.
      -Data Lake Storage must exist beforehand
      -Specify managed resource group name to adhere to naming conventions
*/

terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.synapsetarget]
    }
  }
}


resource "azurerm_synapse_workspace" "coresynworkspaces" {
  for_each                             = var.coreSynWrkSpcs
  name                                 = each.value["wrkspcName"]
  resource_group_name                  = each.value["wrkspcRgName"]
  location                             = each.value["wrkspcLocation"]
  storage_data_lake_gen2_filesystem_id = each.value["datalakeId"]
  sql_administrator_login              = each.value["sqlAdminLogin"]
  sql_administrator_login_password     = each.value["sqlAdminPassword"]
  managed_resource_group_name          = each.value["mngdRgName"]

  aad_admin {
    login     = each.value["aadAdminConfigs"].aadAdminLogin
    object_id = each.value["aadAdminConfigs"].aadAdminObjId
    tenant_id = each.value["aadAdminConfigs"].aadAdminTenantId
  }
}

resource "azurerm_synapse_sql_pool" "coresynsqlpools" {
  for_each             = var.coreSynSqlPools
  name                 = each.value["poolName"]
  synapse_workspace_id = each.value["synWrkSpcId"]
  sku_name             = each.value["poolSku"]
  create_mode          = each.value["poolCreateMode"]
}

resource "azurerm_synapse_spark_pool" "coresynsqlsparkpools" {
  for_each             = var.coreSynSqlSparkPools
  name                 = each.value["sprkPoolName"]
  synapse_workspace_id = each.value["sprkSynWrkSpcId"]
  node_size_family     = each.value["sprkPoolNodeSizeFamily"]
  node_size            = each.value["sprkPoolNodeSize"]

  auto_scale {
    max_node_count = each.value["sprkMaxNodeCount"]
    min_node_count = each.value["sprkMinNodeCount"]
  }

  auto_pause {
    delay_in_minutes = each.value["sprkDelayInMinutes"]
  }
}