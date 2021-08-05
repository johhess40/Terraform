variable "logWrkSpaceName" {
  type = string
}
variable "logWrkSpaceLocation" {
  type = string
}
variable "logWrkSpaceRgName" {
  type = string
}
variable "logWrkSpaceSku" {
  type = string
}
variable "logRetentionDays" {
  type = number
}
variable "logAnalyticsDataSrcType" {
  type = string
}
variable "logAnalyticsStrAccntIds" {
  type = list(string)
}
variable "logWrkSpaceTags" {
  type = object({})
}