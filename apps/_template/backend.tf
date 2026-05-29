terraform {
  backend "remote" {
    organization = "REPLACE_ME_ORG"

    workspaces {
      name = "REPLACE_ME_APPNAME"
    }
  }
}
