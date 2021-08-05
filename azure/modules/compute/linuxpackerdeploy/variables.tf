variable "linuxNicName" {
  type = string
}
variable "linuxVmNicRgName" {
  type = string
}
variable "linuxVmNicLocation" {
  type = string
}
variable "linuxVmSubnetId" {
  type = string
}
variable "linuxVmName" {
  type = string
}
variable "linuxVmSize" {
  type = string
}
variable "linuxVmAdminUsername" {
  type = string
}
variable "linuxVmAdminPassword" {
  type = string
}
variable "srcImgId" {
  type = string
}
variable "linuxOsDiskStrgType" {
  type = string
}
variable "linuxOsDiskCaching" {
  type = string
}
variable "linuxVmNicPrivIp" {
  type = string
}
variable "linuxVmExtensions" {
  type = map(object({
    extensionName         = string
    extensionPublisher    = string
    extensionType         = string
    typeHandlerVersion    = string
    autoUpgradeMinVersion = string
  }))
}