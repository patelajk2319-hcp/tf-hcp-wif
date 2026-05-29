output "nonprod_sa_email" {
  description = "Email of the HCP Terraform agent SA for nonprod runs"
  value       = google_service_account.nonprod.email
}

output "prod_sa_email" {
  description = "Email of the HCP Terraform agent SA for prod runs"
  value       = google_service_account.prod.email
}
