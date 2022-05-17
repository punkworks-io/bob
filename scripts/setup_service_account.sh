#!/bin/bash

set -eu

echo ""
echo "Preparing to execute with the following values:"
echo "==================================================="
echo "Organization: ${GCP_org_id:?}"
echo "Billing Account: ${GCP_billing_account:?}"
echo "Folder: ${GCP_folder_id:?}"
echo "----------------------------------------------------"
echo "TF Admin Project: ${GCP_tf_admin_project:?}"
echo "TF Service Account on GCP: ${GCP_tf_service_account_name:?}"
echo "Service account credentials path: ${GCP_tf_service_account_credentials:?}"
echo "==================================================="
echo ""
echo "Continuing in 10 seconds. Ctrl+C to cancel if you change your mind"

sleep 10

echo "=> Creating terraform service account"
gcloud iam service-accounts create ${GCP_tf_service_account_name} \
  --display-name "Terraform admin account" \
  --project "${GCP_tf_admin_project}"


echo "=> Creating service account keys and saving to ${GCP_tf_service_account_credentials}"
gcloud iam service-accounts keys create "${GCP_tf_service_account_credentials}" \
  --iam-account "${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com"

echo "=> Binding IAM roles to service account"

# Add Viewer permissions for the Terraform Admin project
gcloud projects add-iam-policy-binding "${GCP_tf_admin_project}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role roles/viewer

# Enable Access Context Manager API for the Terraform Admin project
gcloud services --project ${GCP_tf_admin_project} enable accesscontextmanager.googleapis.com

# Add Storage Admin permissions for the Terraform Admin project
gcloud projects add-iam-policy-binding "${GCP_tf_admin_project}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role roles/storage.admin

# Add accesscontextmanager.policyAdmin
gcloud organizations add-iam-policy-binding "${GCP_org_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role="roles/accesscontextmanager.policyAdmin"

# Add resourcemanager.organizationAdmin
gcloud organizations add-iam-policy-binding "${GCP_org_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role="roles/resourcemanager.organizationAdmin"

# Add orgpolicy.policyAdmin
gcloud organizations add-iam-policy-binding "${GCP_org_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role="roles/orgpolicy.policyAdmin"

# Add billing admin
gcloud organizations add-iam-policy-binding "${GCP_org_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role="roles/billing.admin"

# Add Storage Admin permissions to entire Folder
gcloud resource-manager folders add-iam-policy-binding "${GCP_folder_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role roles/storage.admin

# Add Container cluster admin permissions to entire Folder
gcloud resource-manager folders add-iam-policy-binding "${GCP_folder_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role roles/container.admin

# Add serviceusage.serviceUsageAdmin
gcloud resource-manager folders add-iam-policy-binding "${GCP_folder_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role roles/serviceusage.serviceUsageAdmin

# Add IAM serviceAccountUser permissions to entire Folder
gcloud resource-manager folders add-iam-policy-binding "${GCP_folder_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role roles/iam.serviceAccountUser

# Add Project Creator permissions to entire Folder
gcloud resource-manager folders add-iam-policy-binding "${GCP_folder_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role roles/resourcemanager.projectCreator

gcloud resource-manager folders add-iam-policy-binding "${GCP_folder_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role roles/resourcemanager.folderIamAdmin

# Add Billing Project Manager permissions to all projects in Folder
gcloud resource-manager folders add-iam-policy-binding "${GCP_folder_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role roles/billing.projectManager

# Add Compute Admin permissions to all projects in Folder
gcloud resource-manager folders add-iam-policy-binding "${GCP_folder_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role roles/compute.admin

# Add Shared VPC Admin permissions to all projects in Folder
gcloud resource-manager folders add-iam-policy-binding "${GCP_folder_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role roles/compute.xpnAdmin

gcloud resource-manager folders add-iam-policy-binding "${GCP_folder_id}" \
--member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
--role roles/compute.networkAdmin

echo "=> Setting up IAM roles for StackDriver Logging"

gcloud resource-manager folders add-iam-policy-binding "${GCP_folder_id}" \
  --member "serviceAccount:${GCP_tf_service_account_name}@${GCP_tf_admin_project}.iam.gserviceaccount.com" \
  --role roles/logging.configWriter

echo ""
echo "Service Account set up successfully"
echo ""