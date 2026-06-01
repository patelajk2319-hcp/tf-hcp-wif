variable "app_name" {
  description = "Application name — used as a prefix for workspace and variable set names"
  type        = string
}

variable "tfc_organization" {
  description = "HCP Terraform organisation name"
  type        = string
}

# Agent pool names must match the AgentPool CRD names in the hcp-terraform-agents-gke repo.
variable "nonprod_agent_pool_name" {
  description = "HCP Terraform agent pool name for nonprod runs"
  type        = string
}

variable "prod_agent_pool_name" {
  description = "HCP Terraform agent pool name for prod runs"
  type        = string
}

variable "wif_gcp_project_id" {
  description = "GCP project ID hosting the WIF pools"
  type        = string
}

variable "nonprod_wif_pool_name" {
  description = "User-defined name of the nonprod WIF pool (e.g. hcp-tf-wif-nonprod)"
  type        = string
}

variable "prod_wif_pool_name" {
  description = "User-defined name of the prod WIF pool (e.g. hcp-tf-wif-prod)"
  type        = string
}

variable "nonprod_wif_provider_name" {
  description = "User-defined name of the nonprod WIF OIDC provider (e.g. hcp-terraform-oidc-nonprod)"
  type        = string
}

variable "prod_wif_provider_name" {
  description = "User-defined name of the prod WIF OIDC provider (e.g. hcp-terraform-oidc-prod)"
  type        = string
}

variable "github_organization" {
  description = "GitHub Enterprise Cloud organisation name — used to build the VCS repo identifier"
  type        = string
}

variable "github_repo_name" {
  description = "GitHub repository name for this app — passed in from modules/github outputs"
  type        = string
}

variable "oauth_token_id" {
  description = "HCP Terraform OAuth token ID for the GitHub VCS connection"
  type        = string
}

# Passed in from modules/gcp-identity outputs.
variable "nonprod_sa_email" {
  description = "Email of the HCP Terraform agent SA for nonprod runs"
  type        = string
}

variable "prod_sa_email" {
  description = "Email of the HCP Terraform agent SA for prod runs"
  type        = string
}
