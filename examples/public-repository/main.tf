# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A PUBLIC REPOSITORY WITH AN ATTACHED TEAM
#   - create a public repository
#   - create a team and invite members
#   - add the team to the repository and grant admin permissions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "repository" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.13.0"

  module_depends_on = [
    github_team.team
  ]

  name               = "my-public-repository"
  description        = "A description of the repository."
  homepage_url       = "https://github.com/mineiros-io"
  visibility         = "public"
  has_issues         = true
  has_projects       = false
  has_wiki           = true
  allow_merge_commit = true
  allow_rebase_merge = false
  allow_squash_merge = false
  allow_auto_merge   = true
  has_downloads      = false
  auto_init          = true
  gitignore_template = "Terraform"
  license_template   = "mit"
  topics             = ["terraform", "unit-test"]

  admin_team_ids = [
    github_team.team.team.id
  ]

  repo_variables = {
    MY_VAR = "42"
  }
  plaintext_secrets = {
    "MY_SECRET" = "secret"
  }
  environment = [{
    name       = "test"
    wait_timer = 10
    reviewers = {
      users = [data.github_user.current.id]
      teams = [github_team.team.id]
    }
    deployment_branch_policy = {
      protected_branches     = true
      custom_branch_policies = false
    }
    variables = {
      MY_ENV_VAR = "42"
    }
    plaintext_secrets = {
      "MY_ENV_SECRET" = "secret"
    }
    encrypted_secrets = {
      "MY_ENV_ENC_SECRET" = "MTIzNDU="
    }
  }]

  webhooks = [
    {
      active       = true
      events       = ["issues"]
      url          = "https://example.com/events"
      content_type = "application/json"
      insecure_ssl = false
      secret       = "sososecret"
    },
  ]

  admin_collaborators = ["terraform-test-user-1"]

  branch_protections = [
    {
      branch                          = "main"
      enforce_admins                  = true
      require_conversation_resolution = true
      require_signed_commits          = true

      required_status_checks = {
        strict   = true
        contexts = ["ci/travis"]
      }

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        dismissal_teams                 = [github_team.team.slug]
        require_code_owner_reviews      = true
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [github_team.team.slug]
      }
    }
  ]
}

# ------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES:
# ------------------------------------------------------------------------------
# You can provide your credentials via the
#   GITHUB_TOKEN and
#   GITHUB_OWNER, environment variables,
# representing your Access Token and the organization, respectively.
# ------------------------------------------------------------------------------
