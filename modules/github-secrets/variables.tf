variable "repo_name" {
  description = "GitHub repository name to write secrets into"
  type        = string
}

variable "tfc_organization" {
  description = "HCP Terraform organisation name"
  type        = string
}

variable "dev_workspace_id" {
  description = "HCP Terraform workspace ID for dev"
  type        = string
}

variable "test_workspace_id" {
  description = "HCP Terraform workspace ID for test"
  type        = string
}

variable "qa_workspace_id" {
  description = "HCP Terraform workspace ID for qa"
  type        = string
}

variable "prod_workspace_id" {
  description = "HCP Terraform workspace ID for prod"
  type        = string
}
