variable "coreSynWrkSpcs" {
  type = map(object({
    wrkspcName       = string
    wrkspcRgName     = string
    wrkspcLocation   = string
    datalakeId       = string
    sqlAdminLogin    = string
    sqlAdminPassword = string
    mngdRgName       = string
    aadAdminConfigs = object({
      aadAdminLogin    = string
      aadAdminObjId    = string
      aadAdminTenantId = string
    })
  }))
}

variable "coreSynSqlPools" {
  type = map(object({
    poolName       = string
    synWrkSpcId    = string
    poolSku        = string
    poolCreateMode = string
  }))
}

variable "coreSynSqlSparkPools" {
  type = map(object({
    sprkPoolName           = string
    sprkSynWrkSpcId        = string
    sprkPoolNodeSizeFamily = string
    sprkPoolNodeSize       = string
    sprkMaxNodeCount       = string
    sprkMinNodeCount       = string
    sprkDelayInMinutes     = string
  }))
}