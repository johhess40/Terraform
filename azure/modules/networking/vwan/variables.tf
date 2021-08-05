variable "vwanConfigs" {
  type = object({
    vwanName         = string
    vwanRgName       = string
    vwanLocation     = string
    vwanAllowTraffic = string
    vwanType         = string
    vwanTags = object({
      Location = string
      Owner    = string
      Type     = string
    })
  })
}

variable "virthubConfigs" {
  type = map(object({
    virthubName       = string
    virthubRgName     = string
    virthubLocation   = string
    virthubAddrPrefix = string
  }))
}

variable "virthubConnections" {
  type = map(object({
    virthubConnName    = string
    virthubId          = string
    virthubRemoteNetId = string
  }))
}

variable "vwanVpnGatewayConfigs" {
  type = map(object({
    vpnGatewayName      = string
    vpnGatewayLocation  = string
    vpnGatewayRgName    = string
    vpnGatewayVirtHubId = string
  }))
}

variable "vwanVpnSiteConfigs" {
  type = map(object({
    vpnSiteName     = string
    vpnSiteRgName   = string
    vpnSiteLocation = string
    vpnSiteCidrs    = list(string)
    siteLinks = map(object({
      siteLinkName      = string
      siteLinkIpAddress = string
    }))
  }))
}

variable "vwanVpnConnections" {
  type = map(object({
    vpnConnName         = string
    vpnConnGtwyId       = string
    vpnConnRemoteSiteId = string
    gtwyConnLinks = map(object({
      vpnLinkName = string
      siteLinkId  = string
      shrdKey     = string
      ipsecPolicies = map(object({
        dhGroup         = string
        ikeEncryption   = string
        ikeIntegrity    = string
        ipsecEncryption = string
        ipsecIntegrity  = string
        pfsGroup        = string
        saDatasize      = string
        saLifetime      = string
      }))
    }))
  }))
}

variable "fwHubConfigs" {
  type = map(object({
    fwName        = string
    fwLocation    = string
    fwRgName      = string
    fwSkuTier     = string
    fwSkuName     = string
    fwVirtHubId   = string
    fwPubIpCount  = string
    fwThrtIntMode = string

  }))
}


