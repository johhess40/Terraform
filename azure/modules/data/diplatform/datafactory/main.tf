/*
NOTE: This module deploys the data factory platform:
      -This is built off of the current deployment of DPi30 Resources
      -ARM Templates may be involved......
TODO: Validate resources for data factory
*/

/*
NOTE: Deploys Data Factory with proper configurations
      -Right now is configured to use Azure DevOps
      -Block is included for GitHub as well
*/

terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.datafactarget]
    }
  }
}



resource "azurerm_data_factory" "datafacs" {
  provider            = azurerm.datafactarget
  for_each            = var.dataFacs
  name                = each.value["dataFacName"]
  location            = each.value["dataFacLocation"]
  resource_group_name = each.value["dataFacRgName"]

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
}

/*
NOTE: Deploys Azure hosted integration runtime
*/
resource "azurerm_data_factory_integration_runtime_azure" "azureruntimes" {
  provider            = azurerm.datafactarget
  for_each            = var.azureRuntimes
  name                = each.value["runtimeName"]
  data_factory_name   = each.value["runtimeDatafacName"]
  resource_group_name = each.value["runtimeRgName"]
  location            = each.value["runtimeLocation"]
  description         = each.value["runtimeDescription"]
  compute_type        = each.value["runtimeComputeType"]
  core_count          = each.value["runtimeCoreCount"]
  time_to_live_min    = each.value["runtimeTtl"]

  depends_on = [
    azurerm_data_factory.datafacs
  ]
}

/*
NOTE: Deploys on prem self hosted runtime
*/

resource "azurerm_data_factory_integration_runtime_self_hosted" "selfruntimes" {
  provider            = azurerm.datafactarget
  for_each            = var.selfHostedRuntimes
  name                = each.value["shRuntimeName"]
  resource_group_name = each.value["shRuntimeRgName"]
  data_factory_name   = each.value["shDataFacName"]

  depends_on = [
    azurerm_data_factory.datafacs
  ]
}

/*
NOTE: These resources deploy linked services for the Data Factory
*/



resource "azurerm_data_factory_linked_service_key_vault" "linkedkvs" {
  provider                 = azurerm.datafactarget
  for_each                 = var.linkedKeyVault
  name                     = each.value["linkedKvName"]
  resource_group_name      = each.value["linkedKvRgName"]
  data_factory_name        = each.value["linkedKvDataFacName"]
  key_vault_id             = each.value["linkedKvKeyVaultId"]
  description              = each.value["linkedKvDescription"]
  integration_runtime_name = each.value["linkedKvIntegrationRuntime"]

  depends_on = [
    azurerm_data_factory_integration_runtime_azure.azureruntimes,
    azurerm_data_factory_integration_runtime_self_hosted.selfruntimes,
    azurerm_data_factory.datafacs
  ]
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "linkedblobs" {
  provider                 = azurerm.datafactarget
  for_each                 = var.linkedBlobStorage
  name                     = each.value["linkedBlobName"]
  resource_group_name      = each.value["linkedBlobRgName"]
  data_factory_name        = each.value["linkedBlobDatafacName"]
  use_managed_identity     = true
  integration_runtime_name = each.value["linkedBlobIntegrationRuntime"]
  service_endpoint         = each.value["linkedBlobServEndpnt"]

  depends_on = [
    azurerm_data_factory_integration_runtime_azure.azureruntimes,
    azurerm_data_factory_integration_runtime_self_hosted.selfruntimes,
    azurerm_data_factory_linked_service_key_vault.linkedkvs,
    azurerm_data_factory.datafacs
  ]
}
// resource "azurerm_data_factory_linked_service_synapse" "linkedsynapses" {
//  provider = azurerm.datafactarget
//   for_each            = var.linkedSynapse
//   name                = each.value["linkedSynapseName"]
//   resource_group_name = each.value["linkedSynapseRgName"]
//   data_factory_name   = each.value["linkedSynapseDfName"]

//   connection_string = each.value["linkedSynapseConnString"]
//   key_vault_password {
//     linked_service_name = each.value["linkedSynapseKvServName"]
//     secret_name         = each.value["linkedSynapseKvSecret"]
//   }

//   depends_on = [
//     azurerm_data_factory_integration_runtime_azure.azureruntime,
//     azurerm_data_factory.datafac
//   ]
// }

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "dllinks" {
  provider                 = azurerm.datafactarget
  for_each                 = var.linkedDataLake
  name                     = each.value["linkedDataLakeName"]
  resource_group_name      = each.value["linkedDataLakeRgName"]
  data_factory_name        = each.value["linkedDataLakeDfName"]
  integration_runtime_name = each.value["linkedDlIntegrationRuntime"]
  use_managed_identity     = each.value["linkedDataLakeUseMngdId"]
  tenant                   = each.value["linkedDataLakeTenantId"]
  url                      = each.value["linkedDataLakeUrl"]

  depends_on = [
    azurerm_data_factory_integration_runtime_azure.azureruntimes,
    azurerm_data_factory_integration_runtime_self_hosted.selfruntimes,
    azurerm_data_factory_linked_service_key_vault.linkedkvs,
    azurerm_data_factory.datafacs
  ]
}

// resource "azurerm_data_factory_linked_service_snowflake" "snowflake" {
//  provider = azurerm.datafactarget
//   name                = var.snwFlake.snwName
//   resource_group_name = var.snwFlake.rgName
//   data_factory_name   = var.snwFlake.dfName

//   connection_string = var.snwFlake.connectionString
//   key_vault_password {
//     linked_service_name = var.snwFlake.kvLnkServiceName
//     secret_name         = var.snwFlake.kvSecretName
//   }

//   depends_on = [
//     azurerm_data_factory_integration_runtime_azure.azureruntime,
//     azurerm_data_factory_integration_runtime_self_hosted.selfruntimes,
//     azurerm_data_factory_linked_service_key_vault.linkedkvs,
//     azurerm_data_factory.datafacs
//   ]
// }

// resource "azurerm_resource_group_template_deployment" "oraclelinkservs" {
//  provider = azurerm.datafactarget
//   for_each            = var.oracleLinkedServices
//   name                = each.value["oracleLinkedServiceDeployName"]
//   resource_group_name = each.value["oracleLinkedServiceDeployRgName"]
//   deployment_mode     = each.value["oracleLinkedServiceDeployMode"]
//   parameters_content = jsonencode({
//     (each.value["FacName"]) = {
//       "value" = (each.value["FacNameValue"])
//     }
//     (each.value["linkServName"]) = {
//       "value" = (each.value["linkServNameValue"])
//     }
//     (each.value["connString"]) = {
//       "value" = (each.value["connStringValue"])
//     }
//     (each.value["irRefName"]) = {
//       "value" = (each.value["irRefNameValue"])
//     }
//   })
//   template_content = file(each.value["templateFilePath"])
//   // ./oracleLinkedServices/<file name here>
// }


