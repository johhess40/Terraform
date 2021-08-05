variable "stgAccnts" {
  type = map(object({
    accntName     = string
    rgName        = string
    accntLocation = string
    accntTier     = string
    replType      = string
    defAction     = string
    subIds        = list(string)
  }))
}
