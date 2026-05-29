terraform {
  backend "remote" {
    organization = "my-org"

    workspaces {
      name = "app1"
    }
  }
}
