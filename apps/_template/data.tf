# The GitHub VCS OAuth client is registered once per HCP Terraform organisation
# (under Settings > VCS Providers). All app workspaces reference the same client.
data "tfe_oauth_client" "github" {
  organization     = var.tfc_organization
  service_provider = "github_enterprise"
}
