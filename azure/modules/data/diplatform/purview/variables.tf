variable "purviewAccounts" {
  type = map(object({
    purviewName     = string
    purviewRgName   = string
    purviewLocation = string
    purviewSku      = string
  }))
}