
variable "eventHubNmSpc" {
  type = object({
    eventHubNmSpcName     = string
    eventHubNmSpcLocation = string
    eventHubNmSpcRgName   = string
    eventHubNmSpcSku      = string
    eventHubNmSpcCapacity = string
    eventHubNmSpcTags = object({
      Owner       = string
      Environment = string
      Target      = string
    })
  })
}

variable "eventHubStrg" {
  type = map(object({
    eventStrgName     = string
    eventStrgRgName   = string
    eventStrgLocation = string
    eventStrgTier     = string
    eventStrgRepl     = string
    eventStrgTags = object({
      Owner       = string
      Environment = string
      Tier        = string
      Replication = string
    })
  }))
}

variable "eventHubContainers" {
  type = map(object({
    eventCntnrName      = string
    eventCntnrAccess    = string
    eventCntnrAccntName = string
  }))
}

variable "eventHubs" {
  type = map(object({
    eventHubName             = string
    eventHubPartCount        = string
    eventHubMessageRetention = string
    eventHubRgName           = string
    eventHubDestinations = map(object({
      destinationName   = string
      blobContainerName = string
      strgAccntId       = string
    }))
  }))
}

variable "eventhubNmspcAuthRules" {
  type = map(object({
    ehRuleName      = string
    ehRuleNmspcName = string
    ehRgName        = string
    ehListen        = string
    ehSend          = string
    ehManage        = string
  }))
}

variable "eventhubAuthRules" {
  type = map(object({
    ehRuleName      = string
    ehRuleNmspcName = string
    ehEventHubName  = string
    ehRgName        = string
    ehListen        = string
    ehSend          = string
    ehManage        = string
  }))
}