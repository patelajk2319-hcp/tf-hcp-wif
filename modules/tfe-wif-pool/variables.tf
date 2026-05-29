variable "wif_gcp_project_id" {
  description = "GCP project ID hosting both WIF pools (hcp-tf-wif)"
  type        = string
}

variable "pool_env" {
  description = "Pool environment — prod or nonprod"
  type        = string
  validation {
    condition     = contains(["prod", "nonprod"], var.pool_env)
    error_message = "pool_env must be one of: prod, nonprod"
  }
}

variable "tfc_organization_id" {
  description = "HCP Terraform organisation ID — restricts pool trust to this org only"
  type        = string
}
