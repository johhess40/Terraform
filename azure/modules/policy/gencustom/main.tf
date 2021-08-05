/*
NOTE: This module deploys custom policies for burlington
      - These policies may be modified from builtin policies or created from scratch
      - Be mindful of the scope at which these policies are applied
      - 
*/

locals {
  policyFiles = fileset(path.module, "./customPolicies/*.json")
  policyData  = [for f in local.policyFiles : jsondecode(file("${path.module}/${f}"))]
}

resource "azurerm_policy_definition" "guardrailcustompolicy" {
  for_each              = { for f in local.policyData : f.properties["displayName"] => f }
  name                  = each.value["name"]
  policy_type           = each.value.properties["policyType"]
  mode                  = each.value.properties["mode"]
  display_name          = each.value.properties["displayName"]
  management_group_name = var.guardrailpolicyDefManagementGroupName
  metadata = jsonencode({
    category = each.value.properties["metadata"].category
  })
  policy_rule = jsonencode((each.value.properties["policyRule"]))
  parameters  = jsonencode((each.value.properties["parameters"]))
}

resource "azurerm_policy_set_definition" "guardrailcustompolicyset" {
  for_each              = var.guardrailpolicySetDefs
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
      parameter_values     = <<VALUE
      %{for params in policy_definition_reference.value["paramParams"]~}
      {
          "${params.paramName}": {
            "value": "${params.paramValue}"
            }
      }
      %{endfor~}
      VALUE
    }
  }

  depends_on = [
    azurerm_policy_definition.guardrailcustompolicy
  ]
}

resource "azurerm_policy_assignment" "guardrailcustomassignment" {
  for_each             = var.guardrailcustompolicyAssignments
  name                 = each.value["assignmentName"]
  scope                = each.value["assignmentScope"]
  policy_definition_id = each.value["policySetDefId"]
  description          = each.value["assignmentDescription"]
  display_name         = each.value["assignmentDisplayName"]
  location             = each.value["assignmentLocation"]
  identity {
    type = "SystemAssigned"
  }
  enforcement_mode = true


  metadata = jsonencode({
    category = each.value["policyAssignmentCategory"],
    version  = each.value["policyAssignmentVersion"],
    source   = each.value["policyAssignmentSource"]
  })

  depends_on = [
    azurerm_policy_set_definition.guardrailcustompolicyset
  ]
}

/*
NOTE: Adding role assignment so that remediation can actually be done
      -This is a known bug in Terraform which has yet to be fixed
*/

// resource "azurerm_role_assignment" "guardrailPolicyrole" {
//   for_each             = var.policyRoleAssignments
//   scope                = each.value["roleScope"]
//   role_definition_name = each.value["roleDefinitionName"]
//   // Insert whatever you name the object for the assignment in the square brackets below
//   principal_id = azurerm_policy_assignment.diagnosticcustomassignment[each.value["assignmentReference"]].identity[0].principal_id

//   depends_on = [
//     azurerm_policy_assignment.guardraildiagnosticcustomassignment
//   ]
// }