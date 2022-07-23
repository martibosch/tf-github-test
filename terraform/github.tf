/**
 * # Github Repository
 *
 * The Terraform configuration needs to update Github Action Variable 
 * This way we can manage secret and inventory automatically
 */
data "github_user" "self" {
  username = ""
}

resource "github_repository" "repo" {
  name = "tf-github-test"
  auto_init = false
}

# Github branches
resource "github_branch" "staging" {
  repository = github_repository.repo.name
  branch     = "staging"
}

resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
}

/**
 * Github environment
 *
 */
resource "github_repository_environment" "digitalocean_environment" {
  repository       = github_repository.repo.name
  environment      = "digitalocean"
  # reviewers {
  #   users = [data.github_user.deployment_approver.id]
  #   # teams = [] an entire team can be approver
  # }
  deployment_branch_policy {
    protected_branches     = true #the main branch protection definition is below
    custom_branch_policies = false
  }
}

resource "github_actions_environment_secret" "tf_api_token" {
  repository       = github_repository.repo.name
  environment      = github_repository_environment.digitalocean_environment.environment
  secret_name      = "tf_api_token"
  encrypted_value  = base64encode("foo")
}

/**
 * Github branch permissions
 *
 */
resource "github_branch_protection" "main" {
  repository_id     = github_repository.repo.node_id
  pattern          = "main"
  # enforce_admins   = true
  # Configure the check api
  required_status_checks {
    strict   = false
    contexts = ["plan"]
  }
}
