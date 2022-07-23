terraform {
  cloud {
    organization = "exaf-epfl"
    workspaces {
      name = "tf-github-test"
    }
  }
}
