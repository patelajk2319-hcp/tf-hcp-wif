variable "app_name" {
  description = "Application name — used as the repository name and resource prefix"
  type        = string
}

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
  description = "Repository visibility: internal (recommended for GHEC), private, or public"
  type        = string
  default     = "internal"

  validation {
    condition     = contains(["internal", "private", "public"], var.repo_visibility)
    error_message = "repo_visibility must be internal, private, or public."
  }
}

variable "default_branch" {
  description = "Name of the default branch"
  type        = string
  default     = "main"
}

variable "nonprod_team_slug" {
  description = "GitHub team slug granted write access for nonprod (developers)"
  type        = string
}

variable "prod_team_slug" {
  description = "GitHub team slug granted write access for prod (release managers)"
  type        = string
}

# Workspace IDs from modules/tfe-app — stored as Actions secrets so the HCP Terraform
# VCS-driven run trigger knows which workspace to target per branch/environment.
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

variable "tfc_organization" {
  description = "HCP Terraform organisation name — stored as an Actions secret for CI workflows"
  type        = string
}
