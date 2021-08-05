variable "policyDefs" {
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
      policyId    = string
      displayName = string
      paramName   = string
      paramValue = object({
        theValue = any
      })
    }))
  }))
}

variable "policyAssignments" {
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