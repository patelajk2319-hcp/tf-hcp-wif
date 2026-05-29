output "nonprod_pool_name" {
  description = "Full resource name of the nonprod WIF pool"
  value       = module.wif_pool_nonprod.pool_name
}

output "prod_pool_name" {
  description = "Full resource name of the prod WIF pool"
  value       = module.wif_pool_prod.pool_name
}
