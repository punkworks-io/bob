/*

  This file maintains all the organisation policies applied on the main folder

*/



# This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses.
# By default, all VM instances are allowed to use external IP addresses. 
# 
# Here, we deny all
resource "google_folder_organization_policy" "external_ip_policy" {
  folder     = "folders/${var.folder_id}"
  constraint = "compute.vmExternalIpAccess"

  list_policy {
    deny {
      all = true
    }
  }
}


# This list constraint defines the set of members that can be added to Cloud IAM policies.
# By default, all user identities are allowed to be added to Cloud IAM policies.
# The allowed/denied list must specify one or more Cloud Identity or G Suite customer IDs.
# 
# By adding this constraint, only identities in the allowed list will be eligible to be added to Cloud IAM policies.
# We set it to be accesible only to the org's GSUITE id
resource "google_folder_organization_policy" "domain_restricted_sharing_policy" {
  folder     = "folders/${var.folder_id}"
  constraint = "iam.allowedPolicyMemberDomains"

  list_policy {
    allow {
      values = [var.gsuite_id]
    }
  }
}

# This list constraint defines the set of projects that can be used for image storage and disk instantiation for Compute Engine.
# By default, instances can be created from images in any project that shares images publicly or explicitly with the user. 
# 
# cos-cloud
# Container-Optimized OS images are available on Google Cloud Console's list of images with the prefix cos. 
# These are hosted under the cos-cloud project.
# 
# cos-containerd
# container runtime is A software that is responsible for running containers, and abstracts container management for Kubernetes.
# Containerd runtime is an industry-standard container runtime that's supported by Kubernetes, and used by many other projects.
# It provides the layering abstraction that allows for the implementation of a rich set of features like gVisor to extend Kubernetes functionality.
# It is considered more resource efficient and secure when compared to the Docker runtime.
resource "google_folder_organization_policy" "trusted_image_policy" {
  folder     = "folders/${var.folder_id}"
  constraint = "compute.trustedImageProjects"

  list_policy {
    allow {
      values = ["projects/cos-cloud", "projects/cos-containerd"]
    }
  }
}