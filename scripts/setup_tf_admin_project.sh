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



echo "=> Creating project inside the folder ${GCP_folder_id}"
project_exists=`gcloud projects list --filter "${GCP_tf_admin_project}" | grep "${GCP_tf_admin_project}" | wc -l | tr -d ' '`
if [ "$project_exists" = "0" ];then 
  gcloud projects create "${GCP_tf_admin_project}" --folder "${GCP_folder_id}"
else
  echo "Project already exists. Skipping"
fi

echo "=> Linking ${GCP_billing_account} Billing Account to your project"
gcloud beta billing projects link "${GCP_tf_admin_project}" \
  --billing-account="${GCP_billing_account}"

echo "=> Enabling required APIs"
gcloud --project "${GCP_tf_admin_project}" services enable container.googleapis.com
gcloud --project "${GCP_tf_admin_project}" services enable cloudresourcemanager.googleapis.com
gcloud --project "${GCP_tf_admin_project}" services enable cloudbilling.googleapis.com
gcloud --project "${GCP_tf_admin_project}" services enable iam.googleapis.com
gcloud --project "${GCP_tf_admin_project}" services enable admin.googleapis.com
gcloud --project "${GCP_tf_admin_project}" services enable sqladmin.googleapis.com
gcloud --project "${GCP_tf_admin_project}" services enable dlp.googleapis.com
gcloud --project "${GCP_tf_admin_project}" services enable servicenetworking.googleapis.com

echo ""
echo "TF admin project created successfully"
echo ""