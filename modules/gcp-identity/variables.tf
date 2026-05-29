variable "app_name" {
  description = "Application name — used as a prefix for all resource IDs"
  type        = string
}

variable "wif_gcp_project_id" {
  description = "GCP project ID hosting the WIF pools"
  type        = string
}

variable "nonprod_wif_pool_name" {
  description = "User-defined name of the nonprod WIF pool (e.g. hcp-tf-wif-nonprod)"
  type        = string
}

variable "prod_wif_pool_name" {
  description = "User-defined name of the prod WIF pool (e.g. hcp-tf-wif-prod)"
  type        = string
}

variable "dev_project_id" {
  description = "GCP project ID for the dev environment"
  type        = string
}

variable "test_project_id" {
  description = "GCP project ID for the test environment"
  type        = string
}

variable "qa_project_id" {
  description = "GCP project ID for the qa environment"
  type        = string
}

variable "prod_project_id" {
  description = "GCP project ID for the prod environment"
  type        = string
}

variable "nonprod_roles" {
  description = "IAM roles to grant the nonprod agent SA on each nonprod project (dev, test, qa)"
  type        = list(string)
  default = [
    "roles/storage.admin",
    "roles/cloudsql.admin",
    "roles/compute.admin",
  ]
}

variable "prod_roles" {
  description = "IAM roles to grant the prod agent SA on the prod project"
  type        = list(string)
  default = [
    "roles/storage.admin",
    "roles/cloudsql.admin",
    "roles/compute.admin",
  ]
}
