variable "dataKeyVaults" {
  type = map(object({
    kvName                 = string
    kvLocation             = string
    kvRgName               = string
    kvDiskEncryptEnabled   = string
    kvTenantId             = string
    kvSoftRetentionDays    = string
    kvSku                  = string
    kvPurgeProtectEnabled  = string
    kvEnabledForDeployment = string
    kvEnableRbac           = string
    netAcls = object({
      netBypass     = string
      defaultAction = string
      subIds        = list(string)
    })
  }))
}
