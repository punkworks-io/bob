/*
    This file contains service controls for VPC

    * We let terraform_service_account control all the access. 

*/

module "vpc_service_control_organizational_access_policy" {
  source      = "terraform-google-modules/vpc-service-controls/google"
  version     = "1.0.3"
  parent_id   = var.org_id
  policy_name = "PCI Policy"
}

module "access_level_members" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "1.0.3"
  policy  = module.vpc_service_control_organizational_access_policy.policy_id
  name    = "terraform_members"
  members = [var.terraform_service_account]
}

module "regular_service_perimeter" {
  source              = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version             = "1.0.3"
  policy              = module.vpc_service_control_organizational_access_policy.policy_id
  perimeter_name      = "gke_perimeter"
  description         = "Perimeter shielding GKE projects"
  resources           = [google_project.production.number, google_project.test.number, google_project.network.number, google_project.management.number]
  access_levels       = [module.access_level_members.name]
  restricted_services = local.regular_service_perimeter_restricted_services
}