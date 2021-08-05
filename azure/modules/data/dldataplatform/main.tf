/*
NOTE: This module deploys resources for business departments to do large CSV file testing
      -Consider this a pilot for Data Analytics platform
*/

terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.businessdatarget]
    }
  }
}

resource "azurerm_resource_group" "sandboxdarg" {
  provider = azurerm.businessdatarget
  name     = var.sndboxRg.name
  location = var.sndboxRg.location
  tags     = var.sndboxRg.tags
}

/*
NOTE: Deploys Data Factory with proper configurations
      -Right now is configured to use Azure DevOps
      -Block is included for GitHub as well
*/
resource "azurerm_data_factory" "sandydatafacs" {
  provider            = azurerm.businessdatarget
  for_each            = var.sandboxDataFacs
  name                = each.value["dataFacName"]
  location            = azurerm_resource_group.sandboxdarg.location
  resource_group_name = azurerm_resource_group.sandboxdarg.name

  identity {
    type = each.value["identityType"]
  }

  //   github_configuration {
  //       account_name = each.value["githubAccountName"]
  //       branch_name = each.value["githubBranchName"]
  //       git_url = each.value["githubUrl"]
  //       root_folder = each.value["gitRootFolder"]
  //   }

  vsts_configuration {
    account_name    = each.value["vstsAccountName"]
    branch_name     = each.value["vstsBranchName"]
    project_name    = each.value["vstsProjectName"]
    repository_name = each.value["vstsRepositoryName"]
    root_folder     = each.value["vstsRootFolder"]
    tenant_id       = each.value["vstsTenantId"]
  }

  depends_on = [
    azurerm_resource_group.sandboxdarg
  ]
}

/*
NOTE: Deploys Azure hosted integration runtime
*/
resource "azurerm_data_factory_integration_runtime_azure" "sandyazureruntimes" {
  provider            = azurerm.businessdatarget
  for_each            = var.sandboxAzureRuntimes
  name                = each.value["runtimeName"]
  data_factory_name   = each.value["runtimeDatafacName"]
  location            = azurerm_resource_group.sandboxdarg.location
  resource_group_name = azurerm_resource_group.sandboxdarg.name
  description         = each.value["runtimeDescription"]
  compute_type        = each.value["runtimeComputeType"]
  core_count          = each.value["runtimeCoreCount"]
  time_to_live_min    = each.value["runtimeTtl"]

  depends_on = [
    azurerm_data_factory.sandydatafacs
  ]
}

/*
NOTE: Deploying Data Lake Storage for Data Analytics
      -This is done by specifying the Hierchical Namespace
*/
resource "azurerm_storage_account" "sandydatalakes" {
  provider                 = azurerm.businessdatarget
  for_each                 = var.sandboxDataLakes
  name                     = each.value["lakeName"]
  location                 = azurerm_resource_group.sandboxdarg.location
  resource_group_name      = azurerm_resource_group.sandboxdarg.name
  account_tier             = each.value["lakeAccntTier"]
  account_replication_type = each.value["lakeReplType"]
  is_hns_enabled           = true

  // network_rules {
  //   //This block is necessary for allowing cross tenant access to resources such as Snowflake
  //   default_action = each.value["netRules"].defaultAction
  //   //TODO: Attempt to add subnet ID's from Snowflake here
  //   virtual_network_subnet_ids = each.value["netRules"].subIds
  // }

  depends_on = [
    azurerm_data_factory.sandydatafacs
  ]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "filesystems" {
  provider           = azurerm.businessdatarget
  for_each           = var.dl2FileSystems
  name               = each.value["fsName"]
  storage_account_id = each.value["fsStorageAccntId"]

  dynamic "ace" {
    for_each = each.value["fsAces"]
    content {
      scope       = ace.value["aceScope"]
      type        = ace.value["aceType"]
      permissions = ace.value["acePerms"]
      id          = ace.value["aceId"]
    }
  }
  depends_on = [
    azurerm_data_factory.sandydatafacs,
    azurerm_storage_account.sandydatalakes
  ]

  lifecycle {
    ignore_changes = [
      ace
    ]
  }
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "gen2links" {
  provider                 = azurerm.businessdatarget
  for_each                 = var.sandboxDl2LinkedServices
  name                     = each.value["lnkServName"]
  resource_group_name      = azurerm_resource_group.sandboxdarg.name
  integration_runtime_name = each.value["lnkServIrName"]
  data_factory_name        = each.value["lnkServDfName"]
  use_managed_identity     = true
  tenant                   = each.value["lnkServTenantId"]
  //URL of the data lake gen 2 endpoint for Azure
  url = each.value["lnkServDlUrl"]

  depends_on = [
    azurerm_data_factory.sandydatafacs,
    azurerm_data_factory_integration_runtime_azure.sandyazureruntimes,
    azurerm_storage_account.sandydatalakes
  ]
}

