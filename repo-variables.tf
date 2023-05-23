# ---------------------------------------------------------------------------------------------------------------------
# Action Variables
# ---------------------------------------------------------------------------------------------------------------------
locals {
  repo_variables = { for name, value in var.repo_variables : name => { variable = value } }
}

resource "github_actions_variable" "repository_variable" {
  for_each = local.repo_variables

  repository    = github_repository.repository.name
  variable_name = each.key
  value         = try(each.value.variable, null)
}
