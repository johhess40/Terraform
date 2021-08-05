/*
NOTE: Deployment of Databricks enabled for private subnet only
*/

terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.databrickstarget]
    }
  }
}


resource "azurerm_databricks_workspace" "corebricks" {
  for_each            = var.coreDatabricks
  name                = each.value["brickName"]
  resource_group_name = each.value["brickRgName"]
  location            = each.value["brickLocation"]
  sku                 = each.value["brickSku"]

  managed_resource_group_name = each.value["brickMngdRgName"]
  custom_parameters {
    no_public_ip        = each.value["brickParams"].pubIpAllowed
    private_subnet_name = each.value["brickParams"].privSubnetName
    virtual_network_id  = each.value["brickParams"].vnetId

  }

}