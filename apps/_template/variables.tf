variable "github_organization" {
  description = "GitHub Enterprise Cloud organisation name"
  type        = string
}

variable "repo_description" {
  description = "Short description for the GitHub repository"
  type        = string
  default     = ""
}

variable "repo_visibility" {
  description = "Repository visibility: internal, private, or public"
  type        = string
  default     = "internal"
}

variable "nonprod_team_slug" {
  description = "GitHub team slug granted push (write) access — typically your developers team"
  type        = string
}

variable "prod_team_slug" {
  description = "GitHub team slug granted maintain access — typically your release-managers team"
  type        = string
}

variable "wif_gcp_project_id" {
  description = "GCP project ID hosting the WIF pools (hcp-tf-wif)"
  type        = string
}

variable "nonprod_wif_pool_name" {
  description = "User-defined name of the WIF pool for nonprod (e.g. hcp-tf-wif-nonprod)"
  type        = string
}

variable "prod_wif_pool_name" {
  description = "User-defined name of the WIF pool for prod (e.g. hcp-tf-wif-prod)"
  type        = string
}

variable "nonprod_wif_provider_name" {
  description = "User-defined name of the WIF OIDC provider for nonprod (e.g. hcp-terraform-oidc-nonprod)"
  type        = string
}

variable "prod_wif_provider_name" {
  description = "User-defined name of the WIF OIDC provider for prod (e.g. hcp-terraform-oidc-prod)"
  type        = string
}

variable "tfc_organization" {
  description = "HCP Terraform organisation name"
  type        = string
}

variable "nonprod_agent_pool_name" {
  description = "HCP Terraform agent pool name for nonprod runs — must match the AgentPool CRD name in the GKE repo"
  type        = string
}

variable "prod_agent_pool_name" {
  description = "HCP Terraform agent pool name for prod runs — must match the AgentPool CRD name in the GKE repo"
  type        = string
}

variable "dev_project_id" {
  description = "GCP project ID for the REPLACE_ME_APPNAME dev environment"
  type        = string
}

variable "test_project_id" {
  description = "GCP project ID for the REPLACE_ME_APPNAME test environment"
  type        = string
}

variable "qa_project_id" {
  description = "GCP project ID for the REPLACE_ME_APPNAME qa environment"
  type        = string
}

variable "prod_project_id" {
  description = "GCP project ID for the REPLACE_ME_APPNAME prod environment"
  type        = string
}

variable "nonprod_roles" {
  description = "IAM roles to grant the nonprod SA on each non-prod project (dev, test, qa)"
  type        = list(string)
  default = [
    "roles/storage.admin",
    "roles/cloudsql.admin",
    "roles/compute.admin",
  ]
}

variable "prod_roles" {
  description = "IAM roles to grant the prod SA on the prod project"
  type        = list(string)
  default = [
    "roles/storage.admin",
    "roles/cloudsql.admin",
    "roles/compute.admin",
  ]
}
