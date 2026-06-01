output "repo_name" {
  description = "GitHub repository name"
  value       = github_repository.this.name
}

output "repo_full_name" {
  description = "Full repository name in org/repo format"
  value       = github_repository.this.full_name
}

output "repo_html_url" {
  description = "HTTPS URL of the repository"
  value       = github_repository.this.html_url
}

output "repo_ssh_clone_url" {
  description = "SSH clone URL of the repository"
  value       = github_repository.this.ssh_clone_url
}
