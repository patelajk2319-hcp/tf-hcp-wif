provider "google" {}

provider "tfe" {
  organization = var.tfc_organization
}

# Token is read from GITHUB_TOKEN env var — set this in the HCP Terraform variable set
# or supply it via TF_VAR_github_token for local runs.
provider "github" {
  owner = var.github_organization
}
