variable "guardrailpolicyDefManagementGroupName" {
  type = string
}
variable "guardrailpolicySetDefs" {
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
      paramParams = map(any)
    }))
  }))
}

variable "guardrailcustompolicyAssignments" {
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
