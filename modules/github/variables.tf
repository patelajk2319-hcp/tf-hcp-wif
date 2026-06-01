variable "app_name" {
  description = "Application name — used as the repository name and resource prefix"
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
