locals {
  terraform_sa_project_id = "hcp-tf-sa"

  nonprod_pool_resource_name = "projects/${var.wif_gcp_project_id}/locations/global/workloadIdentityPools/${var.nonprod_wif_pool_name}"
  prod_pool_resource_name    = "projects/${var.wif_gcp_project_id}/locations/global/workloadIdentityPools/${var.prod_wif_pool_name}"
}
