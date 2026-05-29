# Creates GCP agent SAs, WIF impersonation bindings, and target project IAM.
module "gcp_identity" {
  source = "../../modules/gcp-identity"

  app_name              = "REPLACE_ME_APPNAME"
  wif_gcp_project_id    = var.wif_gcp_project_id
  nonprod_wif_pool_name = var.nonprod_wif_pool_name
  prod_wif_pool_name    = var.prod_wif_pool_name

  dev_project_id  = var.dev_project_id
  test_project_id = var.test_project_id
  qa_project_id   = var.qa_project_id
  prod_project_id = var.prod_project_id

  nonprod_roles = var.nonprod_roles
  prod_roles    = var.prod_roles
}

# Creates HCP Terraform projects, workspaces, agent bindings, and WIF variable sets.
module "tfe_app" {
  source = "../../modules/tfe-app"

  app_name                  = "REPLACE_ME_APPNAME"
  tfc_organization          = var.tfc_organization
  wif_gcp_project_id        = var.wif_gcp_project_id
  nonprod_wif_pool_name     = var.nonprod_wif_pool_name
  prod_wif_pool_name        = var.prod_wif_pool_name
  nonprod_wif_provider_name = var.nonprod_wif_provider_name
  prod_wif_provider_name    = var.prod_wif_provider_name

  nonprod_agent_pool_name = var.nonprod_agent_pool_name
  prod_agent_pool_name    = var.prod_agent_pool_name

  # SA emails flow from gcp_identity — tfe-app has no GCP provider dependency.
  nonprod_sa_email = module.gcp_identity.nonprod_sa_email
  prod_sa_email    = module.gcp_identity.prod_sa_email

  depends_on = [module.gcp_identity]
}
