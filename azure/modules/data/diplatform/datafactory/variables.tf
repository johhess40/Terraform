variable "dataFacs" {
  type = map(object({
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
}

variable "azureRuntimes" {
  type = map(object({
    runtimeName        = string
    runtimeLocation    = string
    runtimeRgName      = string
    runtimeDatafacName = string
    runtimeDescription = string
    runtimeComputeType = string
    runtimeCoreCount   = string
    runtimeTtl         = string
  }))
}

variable "selfHostedRuntimes" {
  type = map(object({
    shRuntimeName   = string
    shRuntimeRgName = string
    shDataFacName   = string
  }))
}

variable "linkedBlobStorage" {
  type = map(object({
    linkedBlobName               = string
    linkedBlobRgName             = string
    linkedBlobDatafacName        = string
    linkedBlobIntegrationRuntime = string
    linkedBlobServEndpnt         = string
  }))
}

variable "linkedKeyVault" {
  type = map(object({
    linkedKvName               = string
    linkedKvRgName             = string
    linkedKvDataFacName        = string
    linkedKvKeyVaultId         = string
    linkedKvDescription        = string
    linkedKvIntegrationRuntime = string
  }))
}

variable "linkedDataLake" {
  type = map(object({
    linkedDataLakeName         = string
    linkedDataLakeRgName       = string
    linkedDataLakeDfName       = string
    linkedDataLakeUseMngdId    = string
    linkedDataLakeTenantId     = string
    linkedDataLakeUrl          = string
    linkedDlIntegrationRuntime = string
  }))
}





