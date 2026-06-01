variable "wif_gcp_project_id" {
  description = "GCP project ID hosting the WIF pools (e.g. hcp-tf-wif)"
  type        = string
}

variable "tfc_organization_id" {
  description = "HCP Terraform organisation ID — used to restrict pool trust to this org only"
  type        = string
}
