terraform {
  cloud {
    organization = "my-org"

    workspaces {
      name = "app1"
    }
  }
}
