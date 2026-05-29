terraform {
  backend "remote" {
    organization = "my-org"

    workspaces {
      name = "tfe-wif-pools"
    }
  }
}
