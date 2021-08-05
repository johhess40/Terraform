variable "policyDefManagementGroupName" {
  type = string
}
variable "custompolicySetDefs" {
  type = map(object({
    policySetDefName     = string
    policyType           = string
    policySetDisplayName = string
    policySetDescription = string
    policySetCategory    = string
    policySetVersion     = string
    policySetSource      = string
    managementGroupName  = string
    policyDefRefs = map(object({
      policyId                    = string
      displayName                 = string
      diagnosticsSettingNameToUse = string
      logAnalytics                = string
    }))
  }))
}

variable "ehcustompolicySetDefs" {
  type = map(object({
    policySetDefName     = string
    policyType           = string
    policySetDisplayName = string
    policySetDescription = string
    policySetCategory    = string
    policySetVersion     = string
    policySetSource      = string
    managementGroupName  = string
    policyDefRefs = map(object({
      policyId                    = string
      displayName                 = string
      diagnosticsSettingNameToUse = string
      eventHubName                = string
      eventHubAuthorizationRuleId = string
    }))
  }))
}

variable "custompolicyAssignments" {
  type = map(object({
    assignmentName           = string
    assignmentScope          = string
    policySetDefId           = string
    assignmentDescription    = string
    assignmentDisplayName    = string
    assignmentLocation       = string
    policyAssignmentCategory = string
    policyAssignmentVersion  = string
    policyAssignmentSource   = string
  }))
}

variable "policyRoleAssignments" {
  type = map(object({
    roleScope           = string
    roleDefinitionName  = string
    assignmentReference = string
  }))
}

