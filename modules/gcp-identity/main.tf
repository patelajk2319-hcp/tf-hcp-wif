resource "google_project_service" "terraform_sa_project_apis" {
  for_each = toset([
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ])

  project            = var.terraform_sa_project_id
  service            = each.value
  disable_on_destroy = false
}

# ── HCP Terraform agent service accounts ──────────────────────────────────────
# One SA per env — impersonated by the HCP Terraform agent via WIF to authenticate the GCP provider.
# Separate SAs per env ensure nonprod runs cannot access prod resources.

resource "google_service_account" "nonprod" {
  project      = var.terraform_sa_project_id
  account_id   = "${var.app_name}-agent-sa-nonprod"
  display_name = "${var.app_name} Terraform SA - NonProd"
  description  = "Used by the HCP Terraform agent to run Terraform for ${var.app_name} nonprod workspaces"
}

resource "google_service_account" "prod" {
  project      = var.terraform_sa_project_id
  account_id   = "${var.app_name}-agent-sa-prod"
  display_name = "${var.app_name} Terraform SA - Prod"
  description  = "Used by the HCP Terraform agent to run Terraform for ${var.app_name} prod workspaces"
}

# Grants the WIF pool permission to impersonate this SA — scoped to the HCP Terraform project name
# so every workspace in that project can authenticate without individual workspace bindings.
resource "google_service_account_iam_member" "nonprod" {
  service_account_id = google_service_account.nonprod.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${local.nonprod_pool_resource_name}/attribute.terraform_project_name/${var.app_name}-nonprod"
}

resource "google_service_account_iam_member" "prod" {
  service_account_id = google_service_account.prod.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${local.prod_pool_resource_name}/attribute.terraform_project_name/${var.app_name}-prod"
}

# ── Target project IAM ────────────────────────────────────────────────────────
# Grants each SA only the roles it needs in its own env — nonprod SA gets access to dev/test/qa,
# prod SA gets access to prod only. No cross-env access is granted.

resource "google_project_iam_member" "dev" {
  for_each = toset(var.nonprod_roles)

  project = var.dev_project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.nonprod.email}"
}

resource "google_project_iam_member" "test" {
  for_each = toset(var.nonprod_roles)

  project = var.test_project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.nonprod.email}"
}

resource "google_project_iam_member" "qa" {
  for_each = toset(var.nonprod_roles)

  project = var.qa_project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.nonprod.email}"
}

resource "google_project_iam_member" "prod" {
  for_each = toset(var.prod_roles)

  project = var.prod_project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.prod.email}"
}
