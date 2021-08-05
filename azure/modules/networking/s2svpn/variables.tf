variable "vpnGwPipName" {
  type        = string
  description = "The name of the public IP address for the VPN GW"
}
variable "location" {
  type        = string
  description = "The location to deploy resources"
}
variable "rgName" {
  type        = string
  description = "The resource group to deploy resources"
}
variable "tags" {
  type = object({
    Environment  = string
    Location     = string
    Owner        = string
    Tool         = string
    resourceType = string
    Sku          = string
  })
  description = "The tags to be assigned to the resource"
}
variable "vpnGwName" {
  type        = string
  description = "The name of the VPN GW"
}
variable "vpnGwSku" {
  type        = string
  description = "The SKU of the VPN GW"
}
variable "gatewaySubnetID" {
  type        = string
  description = "The ID of the target gateway subnet"
}
variable "localGwNameAlpha" {
  type        = string
  description = "The name of the local network gateway"
}
variable "allocationMethod" {
  type        = string
  description = "Allocation method for vpn gateway"
}
variable "remoteGwAddressAlpha" {
  type        = string
  description = "The IP address of the remote site"
}
variable "remoteAddressSpaceAlpha" {
  type        = list(string)
  description = "The address space at the remote site"
}
variable "vpnGwConnNameAlpha" {
  type        = string
  description = "The name of the connection object"
}
variable "vpnGwPipSku" {
  type        = string
  description = "Sku for Pip"
}
variable "vpnPreSharedKeyAlpha" {
  type        = string
  description = "The Pre-shared key for the VPN"
  sensitive   = true
}

variable "dhGroup" {
  type      = string
  sensitive = true
}
variable "ikeEncryption" {
  type      = string
  sensitive = true
}
variable "ikeIntegrity" {
  type      = string
  sensitive = true
}
variable "ipsecEncryption" {
  type      = string
  sensitive = true
}
variable "ipsecIntegrity" {
  type      = string
  sensitive = true
}
variable "pfsGroup" {
  type      = string
  sensitive = true
}

variable "saDatasize" {
  type      = string
  sensitive = true
}

variable "saLifetime" {
  type      = string
  sensitive = true
}

variable "dpdTimeout" {
  type      = string
  sensitive = true
}