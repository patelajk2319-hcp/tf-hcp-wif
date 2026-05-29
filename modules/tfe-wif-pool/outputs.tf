output "pool_name" {
  description = "Full resource name of the WIF pool"
  value       = google_iam_workload_identity_pool.pool.name
}
