# ── HCP Terraform projects ────────────────────────────────────────────────────
# One project per env tier — groups workspaces so the WIF variable set can be applied once at project
# scope rather than per workspace.

resource "tfe_project" "nonprod" {
  name         = "${var.app_name}-nonprod"
  organization = var.tfc_organization
}

resource "tfe_project" "prod" {
  name         = "${var.app_name}-prod"
  organization = var.tfc_organization
}

# ── Workspaces ────────────────────────────────────────────────────────────────
# One workspace per environment. Dev/test/qa share the nonprod project and agent pool;
# prod is isolated in its own project — keeping prod credentials and blast radius separate.

resource "tfe_workspace" "dev" {
  name              = "${var.app_name}-dev"
  organization      = var.tfc_organization
  project_id        = tfe_project.nonprod.id
  terraform_version = "~> 1.9"
  auto_apply        = false
  tag_names         = [var.app_name, "dev", "gke-agent"]

  vcs_repo {
    identifier     = "${var.github_organization}/${var.github_repo_name}"
    oauth_token_id = var.oauth_token_id
    branch         = "main"
  }
}

resource "tfe_workspace" "test" {
  name              = "${var.app_name}-test"
  organization      = var.tfc_organization
  project_id        = tfe_project.nonprod.id
  terraform_version = "~> 1.9"
  auto_apply        = false
  tag_names         = [var.app_name, "test", "gke-agent"]

  vcs_repo {
    identifier     = "${var.github_organization}/${var.github_repo_name}"
    oauth_token_id = var.oauth_token_id
    branch         = "main"
  }
}

resource "tfe_workspace" "qa" {
  name              = "${var.app_name}-qa"
  organization      = var.tfc_organization
  project_id        = tfe_project.nonprod.id
  terraform_version = "~> 1.9"
  auto_apply        = false
  tag_names         = [var.app_name, "qa", "gke-agent"]

  vcs_repo {
    identifier     = "${var.github_organization}/${var.github_repo_name}"
    oauth_token_id = var.oauth_token_id
    branch         = "main"
  }
}

resource "tfe_workspace" "prod" {
  name              = "${var.app_name}-prod"
  organization      = var.tfc_organization
  project_id        = tfe_project.prod.id
  terraform_version = "~> 1.9"
  auto_apply        = false
  tag_names         = [var.app_name, "prod", "gke-agent"]

  vcs_repo {
    identifier     = "${var.github_organization}/${var.github_repo_name}"
    oauth_token_id = var.oauth_token_id
    branch         = "main"
  }
}

# ── Agent execution mode ──────────────────────────────────────────────────────
# Routes each workspace to the correct HCP Terraform agent pool — required for WIF to work,

resource "tfe_workspace_settings" "dev" {
  workspace_id   = tfe_workspace.dev.id
  execution_mode = "agent"
  agent_pool_id  = data.tfe_agent_pool.nonprod.id
}

resource "tfe_workspace_settings" "test" {
  workspace_id   = tfe_workspace.test.id
  execution_mode = "agent"
  agent_pool_id  = data.tfe_agent_pool.nonprod.id
}

resource "tfe_workspace_settings" "qa" {
  workspace_id   = tfe_workspace.qa.id
  execution_mode = "agent"
  agent_pool_id  = data.tfe_agent_pool.nonprod.id
}

resource "tfe_workspace_settings" "prod" {
  workspace_id   = tfe_workspace.prod.id
  execution_mode = "agent"
  agent_pool_id  = data.tfe_agent_pool.prod.id
}

# ── Nonprod WIF variable set ──────────────────────────────────────────────────
# The four env vars the HCP Terraform GCP provider needs to authenticate via WIF.
# Applied at HCP Terraform project scope so every workspace inherits them without per-workspace config.

resource "tfe_variable_set" "nonprod" {
  name         = "GCP-${var.app_name}-nonprod"
  description  = "WIF credentials for ${var.app_name} nonprod workspaces"
  organization = var.tfc_organization
}

# Tells the HCP Terraform GCP provider to use WIF instead of static credentials.
resource "tfe_variable" "nonprod_provider_auth" {
  variable_set_id = tfe_variable_set.nonprod.id
  key             = "TFC_GCP_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  sensitive       = false
}

# Full resource name of the WIF OIDC provider — GCP STS validates the run token against this.
# e.g. projects/123456789/locations/global/workloadIdentityPools/hcp-tf-wif-nonprod/providers/hcp-terraform-oidc-nonprod
resource "tfe_variable" "nonprod_workload_provider" {
  variable_set_id = tfe_variable_set.nonprod.id
  key             = "TFC_GCP_WORKLOAD_PROVIDER_NAME"
  value           = local.nonprod_wif_provider_resource_name
  category        = "env"
  sensitive       = false
}

# The GCP SA the agent impersonates after WIF token exchange to run Terraform.
# e.g. app1-agent-sa-nonprod@hcp-tf-sa.iam.gserviceaccount.com
resource "tfe_variable" "nonprod_service_account" {
  variable_set_id = tfe_variable_set.nonprod.id
  key             = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
  value           = var.nonprod_sa_email
  category        = "env"
  sensitive       = false
}

# Self-hosted agents require an explicit audience — without this, the JWT audience won't match the WIF pool and GCP STS will reject the token exchange.
# e.g. //iam.googleapis.com/projects/123456789/locations/global/workloadIdentityPools/hcp-tf-wif-nonprod
resource "tfe_variable" "nonprod_workload_identity_audience" {
  variable_set_id = tfe_variable_set.nonprod.id
  key             = "TFC_WORKLOAD_IDENTITY_AUDIENCE"
  value           = local.nonprod_workload_identity_audience
  category        = "env"
  sensitive       = false
}

resource "tfe_project_variable_set" "nonprod" {
  variable_set_id = tfe_variable_set.nonprod.id
  project_id      = tfe_project.nonprod.id
}

resource "tfe_team_project_access" "nonprod" {
  team_id    = data.tfe_team.nonprod.id
  project_id = tfe_project.nonprod.id
  access     = "admin"
}

# ── Prod WIF variable set ─────────────────────────────────────────────────────

resource "tfe_variable_set" "prod" {
  name         = "GCP-${var.app_name}-prod"
  description  = "WIF credentials for ${var.app_name} prod workspaces"
  organization = var.tfc_organization
}

# Tells the HCP Terraform GCP provider to use WIF instead of static credentials.
resource "tfe_variable" "prod_provider_auth" {
  variable_set_id = tfe_variable_set.prod.id
  key             = "TFC_GCP_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  sensitive       = false
}

# Full resource name of the WIF OIDC provider — GCP STS validates the run token against this.
# e.g. projects/123456789/locations/global/workloadIdentityPools/hcp-tf-wif-prod/providers/hcp-terraform-oidc-prod
resource "tfe_variable" "prod_workload_provider" {
  variable_set_id = tfe_variable_set.prod.id
  key             = "TFC_GCP_WORKLOAD_PROVIDER_NAME"
  value           = local.prod_wif_provider_resource_name
  category        = "env"
  sensitive       = false
}

# The GCP SA the agent impersonates after WIF token exchange to run Terraform.
# e.g. app1-agent-sa-prod@hcp-tf-sa.iam.gserviceaccount.com
resource "tfe_variable" "prod_service_account" {
  variable_set_id = tfe_variable_set.prod.id
  key             = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
  value           = var.prod_sa_email
  category        = "env"
  sensitive       = false
}

# Self-hosted agents require an explicit audience — without this, the JWT audience won't match the WIF pool and GCP STS will reject the token exchange.
# e.g. //iam.googleapis.com/projects/123456789/locations/global/workloadIdentityPools/hcp-tf-wif-prod
resource "tfe_variable" "prod_workload_identity_audience" {
  variable_set_id = tfe_variable_set.prod.id
  key             = "TFC_WORKLOAD_IDENTITY_AUDIENCE"
  value           = local.prod_workload_identity_audience
  category        = "env"
  sensitive       = false
}

resource "tfe_project_variable_set" "prod" {
  variable_set_id = tfe_variable_set.prod.id
  project_id      = tfe_project.prod.id
}

resource "tfe_team_project_access" "prod" {
  team_id    = data.tfe_team.prod.id
  project_id = tfe_project.prod.id
  access     = "admin"
}
