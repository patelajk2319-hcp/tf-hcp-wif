output "dev_workspace_id" {
  description = "HCP Terraform workspace ID for dev"
  value       = tfe_workspace.dev.id
}

output "test_workspace_id" {
  description = "HCP Terraform workspace ID for test"
  value       = tfe_workspace.test.id
}

output "qa_workspace_id" {
  description = "HCP Terraform workspace ID for qa"
  value       = tfe_workspace.qa.id
}

output "prod_workspace_id" {
  description = "HCP Terraform workspace ID for prod"
  value       = tfe_workspace.prod.id
}

output "nonprod_project_id" {
  description = "HCP Terraform project ID for nonprod"
  value       = tfe_project.nonprod.id
}

output "prod_project_id" {
  description = "HCP Terraform project ID for prod"
  value       = tfe_project.prod.id
}
