resource "github_actions_secret" "tfc_organization" {
  repository      = var.repo_name
  secret_name     = "TFC_ORGANIZATION"
  plaintext_value = var.tfc_organization
}

resource "github_actions_secret" "dev_workspace_id" {
  repository      = var.repo_name
  secret_name     = "TFC_WORKSPACE_ID_DEV"
  plaintext_value = var.dev_workspace_id
}

resource "github_actions_secret" "test_workspace_id" {
  repository      = var.repo_name
  secret_name     = "TFC_WORKSPACE_ID_TEST"
  plaintext_value = var.test_workspace_id
}

resource "github_actions_secret" "qa_workspace_id" {
  repository      = var.repo_name
  secret_name     = "TFC_WORKSPACE_ID_QA"
  plaintext_value = var.qa_workspace_id
}

resource "github_actions_secret" "prod_workspace_id" {
  repository      = var.repo_name
  secret_name     = "TFC_WORKSPACE_ID_PROD"
  plaintext_value = var.prod_workspace_id
}
