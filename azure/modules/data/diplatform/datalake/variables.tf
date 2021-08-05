variable "coreDataLakes" {
  type = map(object({
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
}
