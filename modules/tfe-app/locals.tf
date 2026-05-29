locals {
  nonprod_pool_resource_name = "projects/${var.wif_gcp_project_id}/locations/global/workloadIdentityPools/${var.nonprod_wif_pool_name}"
  prod_pool_resource_name    = "projects/${var.wif_gcp_project_id}/locations/global/workloadIdentityPools/${var.prod_wif_pool_name}"

  nonprod_wif_provider_resource_name = "${local.nonprod_pool_resource_name}/providers/${var.nonprod_wif_provider_name}"
  prod_wif_provider_resource_name    = "${local.prod_pool_resource_name}/providers/${var.prod_wif_provider_name}"

  nonprod_workload_identity_audience = "//iam.googleapis.com/${local.nonprod_pool_resource_name}"
  prod_workload_identity_audience    = "//iam.googleapis.com/${local.prod_pool_resource_name}"
}
