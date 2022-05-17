/*

  We use a remote backend to maintain the state of Terraform.

  The remote backend is provided by terraform cloud

  This file maintains the project & workspace details for TF-cloud

*/

terraform {
  backend "remote" {
    organization = "shoparazzi"

    workspaces {
      name = "bob"
    }
  }
}