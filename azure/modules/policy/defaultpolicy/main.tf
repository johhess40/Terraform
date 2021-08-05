/*
NOTE: This module deploys policies via policy sets.....
    - These will initially be applied at management group levels
    - Custom policies have not yet been incorporated
*/

resource "azurerm_policy_set_definition" "policyset" {
  for_each              = var.policyDefs
  name                  = each.value["policySetDefName"]
  policy_type           = each.value["policyType"]
  display_name          = each.value["policySetDisplayName"]
  description           = each.value["policySetDescription"]
  management_group_name = each.value["managementGroupName"]

  metadata = jsonencode({
    category = each.value["policySetCategory"],
    version  = each.value["policySetVersion"],
    source   = each.value["policySetSource"]
  })

  dynamic "policy_definition_reference" {
    for_each = each.value["policyDefRefs"]
    content {
      policy_definition_id = policy_definition_reference.value["policyId"]
      reference_id         = policy_definition_reference.value["displayName"]
      parameter_values = jsonencode({
        (policy_definition_reference.value["paramName"]) = {
          "value" = (policy_definition_reference.value["paramValue"].theValue)
        }
      })
    }
  }
}

resource "azurerm_policy_assignment" "assignment" {
  for_each             = var.policyAssignments
  name                 = each.value["assignmentName"]
  scope                = each.value["assignmentScope"]
  policy_definition_id = each.value["policySetDefId"]
  description          = each.value["assignmentDescription"]
  display_name         = each.value["assignmentDisplayName"]
  location             = each.value["assignmentLocation"]
  enforcement_mode     = true

  metadata = jsonencode({
    category = each.value["policyAssignmentCategory"],
    version  = each.value["policyAssignmentVersion"],
    source   = each.value["policyAssignmentSource"]
  })

  depends_on = [
    azurerm_policy_set_definition.policyset
  ]
}