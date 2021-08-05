variable "sndboxRg" {
  type = object({
    name     = string
    location = string
    tags = object({
      Environment = string
      Owner       = string
      CostCenter  = string
      CostContact = string
    })
  })
}

variable "sandboxDataFacs" {
  type = map(object({
    dataFacName        = string
    identityType       = string
    vstsAccountName    = string
    vstsBranchName     = string
    vstsProjectName    = string
    vstsRepositoryName = string
    vstsRootFolder     = string
    vstsTenantId       = string
  }))
}

variable "sandboxAzureRuntimes" {
  type = map(object({
    runtimeName        = string
    runtimeDatafacName = string
    runtimeDescription = string
    runtimeComputeType = string
    runtimeCoreCount   = string
    runtimeTtl         = string
  }))
}

variable "sandboxDataLakes" {
  type = map(object({
    lakeName      = string
    lakeAccntTier = string
    lakeReplType  = string
  }))
}

variable "dl2FileSystems" {
  type = map(object({
    fsName           = string
    fsStorageAccntId = string
    fsAces = map(object({
      aceScope = string
      aceType  = string
      acePerms = string
      aceId    = string
    }))
  }))
}

variable "sandboxDl2LinkedServices" {
  type = map(object({
    lnkServName     = string
    lnkServDfName   = string
    lnkServDlUrl    = string
    lnkServTenantId = string
    lnkServIrName   = string
  }))
}