####################################################
###Module for deployment of VPN Gateway resources###
####################################################
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      configuration_aliases = [
        azurerm.gatewaytarget
      ]
    }
  }
}

resource "azurerm_public_ip" "vpngw_pip" {
  // provider            = azurerm.gatewaytarget
  name                = var.vpnGwPipName
  location            = var.location
  resource_group_name = var.rgName
  allocation_method   = var.allocationMethod
  sku                 = var.vpnGwPipSku
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "vpngws" {
  // provider            = azurerm.gatewaytarget
  name                = var.vpnGwName
  location            = var.location
  resource_group_name = var.rgName

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = var.vpnGwSku
  generation    = "Generation2"

  ip_configuration {
    name                          = "${var.vpnGwPipName}-config"
    public_ip_address_id          = azurerm_public_ip.vpngw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gatewaySubnetID
  }
  tags = var.tags

  timeouts {
    create = "60m"
    delete = "60m"
  }
}

resource "azurerm_local_network_gateway" "localgwys" {
  // provider            = azurerm.gatewaytarget
  name                = var.localGwNameAlpha
  location            = var.location
  resource_group_name = var.rgName
  gateway_address     = var.remoteGwAddressAlpha
  address_space       = var.remoteAddressSpaceAlpha
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway_connection" "connections" {
  provider            = azurerm.gatewaytarget
  name                = var.vpnGwConnNameAlpha
  location            = var.location
  resource_group_name = var.rgName

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.localGWAlpha.id
  dpd_timeout_seconds        = var.dpdTimeout

  shared_key = var.vpnPreSharedKeyAlpha
  tags       = var.tags

  ipsec_policy {
    dh_group         = var.dhGroup
    ike_encryption   = var.ikeEncryption
    ike_integrity    = var.ikeIntegrity
    ipsec_encryption = var.ipsecEncryption
    ipsec_integrity  = var.ipsecIntegrity
    pfs_group        = var.pfsGroup
    sa_datasize      = var.saDatasize
    sa_lifetime      = var.saLifetime
  }
}
