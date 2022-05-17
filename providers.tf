/*

  This file maintains all the providers we install on terraform.

  All the infra is is setup on GCP.4

  Currently we use below GCP providers for terraform 
  1. google
  2. google-beta

*/


provider "google" {
  version = "~> 3.8"
  region  = var.region
}


provider "google-beta" {
  version = "~> 3.8"
  region  = var.region
}