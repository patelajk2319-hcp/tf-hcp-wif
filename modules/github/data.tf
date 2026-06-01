# Teams are managed outside this stack — looked up by slug.
data "github_team" "nonprod" {
  slug = var.nonprod_team_slug
}

data "github_team" "prod" {
  slug = var.prod_team_slug
}
