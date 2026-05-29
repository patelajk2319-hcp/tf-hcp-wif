# Agent pools are managed in the hcp-terraform-agents-gke repo — looked up by name.
data "tfe_agent_pool" "nonprod" {
  name         = var.nonprod_agent_pool_name
  organization = var.tfc_organization
}

data "tfe_agent_pool" "prod" {
  name         = var.prod_agent_pool_name
  organization = var.tfc_organization
}

data "tfe_team" "nonprod" {
  name         = "team-non-prod"
  organization = var.tfc_organization
}

data "tfe_team" "prod" {
  name         = "team-prod"
  organization = var.tfc_organization
}
