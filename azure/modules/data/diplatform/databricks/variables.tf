variable "coreDatabricks" {
  type = map(object({
    brickName       = string
    brickRgName     = string
    brickLocation   = string
    brickSku        = string
    brickMngdRgName = string
    brickParams = object({
      pubIpAllowed   = string
      privSubnetName = string
      vnetId         = string
    })
  }))
}