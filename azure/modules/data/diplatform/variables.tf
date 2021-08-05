variable "ingestTarget" {
  type = string
}

variable "dataKeyVaults" {
  type = map(object({
    kvName                 = string
    kvLocation             = string
    kvRgName               = string
    kvDiskEncryptEnabled   = string
    kvTenantId             = string
    kvSoftRetentionDays    = string
    kvPurgeProtectEnabled  = string
    kvSku                  = string
    kvEnabledForDeployment = string
    kvEnableRbac           = string
    netAcls = object({
      netBypass     = string
      defaultAction = string
      subIds        = list(string)
    })
  }))
}
variable "datalakeComponents" {
  type = object({
    coreDataLakes = map(object({
      lakeName      = string
      lakeRgName    = string
      lakeLocation  = string
      lakeAccntTier = string
      lakeReplType  = string
      netRules = object({
        defaultAction = string
        subIds        = list(string)
      })
    }))
  })
}

variable "daStg" {
  type = object({
    stgAccnts = map(object({
      accntName     = string
      rgName        = string
      accntLocation = string
      accntTier     = string
      replType      = string
      defAction     = string
      subIds        = list(string)
    }))
  })
}

variable "daDf" {
  type = object({
    dataFacs = map(object({
      dataFacName        = string
      dataFacLocation    = string
      dataFacRgName      = string
      identityType       = string
      vstsAccountName    = string
      vstsBranchName     = string
      vstsProjectName    = string
      vstsRepositoryName = string
      vstsRootFolder     = string
      vstsTenantId       = string
    }))
    azureRuntimes = map(object({
      runtimeName        = string
      runtimeLocation    = string
      runtimeRgName      = string
      runtimeDatafacName = string
      runtimeDescription = string
      runtimeComputeType = string
      runtimeCoreCount   = string
      runtimeTtl         = string
    }))
    selfHostedRuntimes = map(object({
      shRuntimeName   = string
      shRuntimeRgName = string
      shDataFacName   = string
    }))
    linkedBlobStorage = map(object({
      linkedBlobName               = string
      linkedBlobRgName             = string
      linkedBlobDatafacName        = string
      linkedBlobIntegrationRuntime = string
      linkedBlobServEndpnt         = string
    }))
    linkedKeyVault = map(object({
      linkedKvName               = string
      linkedKvRgName             = string
      linkedKvDataFacName        = string
      linkedKvKeyVaultId         = string
      linkedKvDescription        = string
      linkedKvIntegrationRuntime = string
    }))
    linkedDataLake = map(object({
      linkedDataLakeName         = string
      linkedDataLakeRgName       = string
      linkedDataLakeDfName       = string
      linkedDataLakeUseMngdId    = string
      linkedDataLakeTenantId     = string
      linkedDataLakeUrl          = string
      linkedDlIntegrationRuntime = string
    }))
  })
}

variable "coreDataNetworking" {
  type = map(object({
    corePrivDnsZones = object({
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
    coreDataARecords = object({
      aRcrdName     = string
      aRcrdZoneName = string
      aRcrdRgName   = string
      aRcrdTtl      = string
    })
    coreDataPeps = object({
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
  }))
}
