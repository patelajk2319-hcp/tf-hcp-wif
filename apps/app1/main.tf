# Creates GCP agent SAs, WIF impersonation bindings, and target project IAM.
module "gcp_identity" {
  source = "../../modules/gcp-identity"

  app_name                = "app1"
  terraform_sa_project_id = var.terraform_sa_project_id
  wif_gcp_project_id      = var.wif_gcp_project_id
  nonprod_wif_pool_name   = var.nonprod_wif_pool_name
  prod_wif_pool_name      = var.prod_wif_pool_name

  dev_project_id  = var.dev_project_id
  test_project_id = var.test_project_id
  qa_project_id   = var.qa_project_id
  prod_project_id = var.prod_project_id

  nonprod_roles = var.nonprod_roles
  prod_roles    = var.prod_roles
}

# Creates the GitHub repository, branch protection, and team access.
# Must exist before tfe_app so workspaces can reference the VCS repo.
module "github" {
  source = "../../modules/github"

  app_name          = "app1"
  nonprod_team_slug = var.nonprod_team_slug
  prod_team_slug      = var.prod_team_slug
}

# Creates HCP Terraform projects, workspaces, agent bindings, WIF variable sets,
# and links each workspace to the GitHub repository via VCS.
module "tfe_app" {
  source = "../../modules/tfe-app"

  app_name                  = "app1"
  tfc_organization          = var.tfc_organization
  wif_gcp_project_id        = var.wif_gcp_project_id
  nonprod_wif_pool_name     = var.nonprod_wif_pool_name
  prod_wif_pool_name        = var.prod_wif_pool_name
  nonprod_wif_provider_name = var.nonprod_wif_provider_name
  prod_wif_provider_name    = var.prod_wif_provider_name

  nonprod_agent_pool_name = var.nonprod_agent_pool_name
  prod_agent_pool_name    = var.prod_agent_pool_name

  github_organization = var.github_organization
  github_repo_name    = module.github.repo_name
  oauth_token_id      = data.tfe_oauth_client.github.oauth_token_id

  nonprod_sa_email = module.gcp_identity.nonprod_sa_email
  prod_sa_email    = module.gcp_identity.prod_sa_email

  depends_on = [module.gcp_identity, module.github]
}

# Writes HCP Terraform workspace IDs as Actions secrets so CI workflows know
# which workspace to target. Runs after tfe_app so the IDs are available.
module "github_secrets" {
  source = "../../modules/github-secrets"

  repo_name        = module.github.repo_name
  tfc_organization = var.tfc_organization

  dev_workspace_id  = module.tfe_app.dev_workspace_id
  test_workspace_id = module.tfe_app.test_workspace_id
  qa_workspace_id   = module.tfe_app.qa_workspace_id
  prod_workspace_id = module.tfe_app.prod_workspace_id
}
