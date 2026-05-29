module "wif_pool_nonprod" {
  source = "../modules/tfe-wif-pool"

  wif_gcp_project_id  = local.wif_gcp_project_id
  pool_env            = "nonprod"
  tfc_organization_id = var.tfc_organization_id
}

module "wif_pool_prod" {
  source = "../modules/tfe-wif-pool"

  wif_gcp_project_id  = local.wif_gcp_project_id
  pool_env            = "prod"
  tfc_organization_id = var.tfc_organization_id
}
