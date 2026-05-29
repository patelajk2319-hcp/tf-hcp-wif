# Enables the APIs needed for WIF token exchange (sts, iamcredentials) and SA management (iam, cloudresourcemanager).

resource "google_project_service" "required_apis" {
  for_each = toset([
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sts.googleapis.com",
    "iamcredentials.googleapis.com",
  ])

  project            = var.wif_gcp_project_id
  service            = each.value
  disable_on_destroy = false
}

# The WIF pool is the trust boundary between GCP and HCP Terraform — only identities from this pool
# can exchange tokens. One pool per env limits the blast radius if a pool is ever compromised.

resource "google_iam_workload_identity_pool" "pool" {
  project                   = var.wif_gcp_project_id
  workload_identity_pool_id = "hcp-tf-wif-${var.pool_env}"
  display_name              = "HCP Terraform WIF Pool (${var.pool_env})"
  description               = "Shared WIF pool for all ${var.pool_env} HCP Terraform projects"
  disabled                  = false

  depends_on = [google_project_service.required_apis]
}

# The OIDC provider validates the JWT issued by HCP Terraform and maps its claims to GCP attributes.
# Those attributes are what the attribute_condition and SA impersonation bindings are evaluated against.
resource "google_iam_workload_identity_pool_provider" "this" {
  project                            = google_iam_workload_identity_pool.pool.project
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "hcp-terraform-oidc-${var.pool_env}"
  display_name                       = "HCP Terraform OIDC (${var.pool_env})"
  disabled                           = false

  # JWT claims (right) mapped to GCP attributes (left) — attributes are used in the condition and SA bindings below.
  attribute_mapping = {
    "google.subject"                      = "assertion.sub"                       # unique run identity
    "attribute.terraform_organization_id" = "assertion.terraform_organization_id" # used in attribute_condition to restrict to our org
    "attribute.terraform_project_id"      = "assertion.terraform_project_id"      # HCP Terraform project UUID
    "attribute.terraform_project_name"    = "assertion.terraform_project_name"    # used in SA impersonation bindings to scope per app
    "attribute.terraform_workspace_id"    = "assertion.terraform_workspace_id"    # available for workspace-scoped bindings if needed
    "attribute.terraform_run_phase"       = "assertion.terraform_run_phase"       # plan or apply — can restrict SA to apply-only runs
  }

  # First line of defence — rejects any token NOT from our HCP Terraform org before SA impersonation is even attempted.
  attribute_condition = "attribute.terraform_organization_id == \"${var.tfc_organization_id}\""

  oidc {
    issuer_uri = "https://app.terraform.io"
  }

  depends_on = [google_iam_workload_identity_pool.pool]
}

# Prevents anyone from creating static SA keys in this project — all auth must go through WIF.
resource "google_project_organization_policy" "disable_sa_keys" {
  project    = var.wif_gcp_project_id
  constraint = "iam.disableServiceAccountKeyCreation"

  boolean_policy {
    enforced = true
  }
}

# Audit logs for IAM — records every SA impersonation request so it's clear which run accessed which SA.
resource "google_project_iam_audit_config" "iam_audit" {
  project = var.wif_gcp_project_id
  service = "iam.googleapis.com"

  audit_log_config { log_type = "DATA_READ" }
  audit_log_config { log_type = "DATA_WRITE" }
  audit_log_config { log_type = "ADMIN_READ" }
}

# Audit logs for STS — records every WIF token exchange, giving a full picture of when and by whom credentials were requested.
resource "google_project_iam_audit_config" "sts_audit" {
  project = var.wif_gcp_project_id
  service = "sts.googleapis.com"

  audit_log_config { log_type = "DATA_READ" }
  audit_log_config { log_type = "DATA_WRITE" }
}
