variable "corePrivDnsZones" {
  type = object({
    privZoneName   = string
    privZoneRgName = string
    soaRecord = object({
      soaEmail       = string
      soaExpireTime  = string
      soaMinTtl      = string
      soaRefreshTime = string
      soaRetryTime   = string
      soaTtl         = string
    })
  })
}

variable "coreDataARecords" {
  type = object({
    aRcrdName     = string
    aRcrdZoneName = string
    aRcrdRgName   = string
    aRcrdTtl      = string
  })
}

variable "coreDataPeps" {
  type = object({
    pepName     = string
    pepLocation = string
    pepRgName   = string
    pepSubnetId = string
    pepConnection = object({
      serviceName     = string
      connectionResId = string
      subResNames     = string
      manualConn      = string
    })
  })
}