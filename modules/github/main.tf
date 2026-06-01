# ── Repository ────────────────────────────────────────────────────────────────

resource "github_repository" "this" {
  name        = var.app_name
  description = var.repo_description
  visibility  = var.repo_visibility

  # Merge strategy: squash-only keeps a linear history on the default branch.
  has_issues             = true
  has_projects           = false
  has_wiki               = false
  allow_merge_commit     = false
  allow_squash_merge     = true
  allow_rebase_merge     = false
  delete_branch_on_merge = true
  auto_init              = true

  lifecycle {
    # Prevent accidental destruction of the repo through Terraform.
    prevent_destroy = true
  }
}

# ── Branch protection — default branch ───────────────────────────────────────
# Requires PRs and passing status checks before merge; dismisses stale approvals
# when new commits are pushed so CI re-runs are mandatory.

resource "github_branch_protection" "default" {
  repository_id = github_repository.this.node_id
  pattern       = var.default_branch

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = 1
  }

  enforce_admins                  = true
  restricts_pushes                = false
  require_conversation_resolution = true
}

# ── Team access ───────────────────────────────────────────────────────────────

resource "github_team_repository" "nonprod" {
  team_id    = data.github_team.nonprod.id
  repository = github_repository.this.name
  permission = "push"
}

resource "github_team_repository" "prod" {
  team_id    = data.github_team.prod.id
  repository = github_repository.this.name
  # Maintain access for release/hotfix operations but not admin — keeps admin surface small.
  permission = "maintain"
}

# ── Actions secrets — HCP Terraform workspace IDs ────────────────────────────
# Stored as secrets (not plain vars) because workspace IDs are internal TFC resource
# identifiers that should not appear in public PR logs.

resource "github_actions_secret" "tfc_organization" {
  repository      = github_repository.this.name
  secret_name     = "TFC_ORGANIZATION"
  plaintext_value = var.tfc_organization
}

resource "github_actions_secret" "dev_workspace_id" {
  repository      = github_repository.this.name
  secret_name     = "TFC_WORKSPACE_ID_DEV"
  plaintext_value = var.dev_workspace_id
}

resource "github_actions_secret" "test_workspace_id" {
  repository      = github_repository.this.name
  secret_name     = "TFC_WORKSPACE_ID_TEST"
  plaintext_value = var.test_workspace_id
}

resource "github_actions_secret" "qa_workspace_id" {
  repository      = github_repository.this.name
  secret_name     = "TFC_WORKSPACE_ID_QA"
  plaintext_value = var.qa_workspace_id
}

resource "github_actions_secret" "prod_workspace_id" {
  repository      = github_repository.this.name
  secret_name     = "TFC_WORKSPACE_ID_PROD"
  plaintext_value = var.prod_workspace_id
}
