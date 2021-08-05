variable "conMonName" {
  type = string
}
variable "conMonNetWatchId" {
  type = string
}
variable "conMonLocation" {
  type = string
}
variable "conMonNotes" {
  type = string
}
variable "conMonOutWrkSpcIds" {
  type = list(string)
}
variable "conMonEndpoints" {
  type = map(object({
    endpointName      = string
    endpointTrgtResId = string
  }))
  description = "This variable is used to define all of the different endpoints"
}
variable "conMonOnPremEndpoints" {
  type = map(object({
    onPremEndpointName = string
    onPremEndpointIp   = string
  }))
  description = "This variable is used to define all of the different on prem endpoints"
}
variable "conMonTcpTestConfigs" {
  type = map(object({
    conMonTestTcpConfigName        = string
    conMonTestTcpConfigProtocol    = string
    conMonTestTcpConfigFreqSeconds = number
    conMonTestTcpConfigPort        = number
  }))
  description = "This variable is used to define the parameters for our connection tests"
}
variable "conMonIcmpTestConfigs" {
  type = map(object({
    conMonTestIcmpConfigName        = string
    conMonTestIcmpConfigProtocol    = string
    conMonTestIcmpConfigFreqSeconds = number
  }))
  description = "This variable is used to define the parameters for our connection tests"
}
variable "conMonTestGroups" {
  type = map(object({
    conMonTestGroupName   = string
    conMonDestEndpoints   = list(string)
    conMonSrcEndpoints    = list(string)
    conMonTestConfigNames = list(string)
    conMonEnabled         = string
  }))
}