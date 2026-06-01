terraform {
  cloud {
    organization = "my-org"

    workspaces {
      name = "tfe-wif-pools"
    }
  }
}
