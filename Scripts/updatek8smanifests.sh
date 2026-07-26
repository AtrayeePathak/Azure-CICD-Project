#!/bin/bash

set -x

# Set the repository URL
REPO_URL="https://***REDACTED_PAT_1***@dev.azure.com/<AZURE-DEVOPS-ORG-NAME>/voting-app/_git/voting-app"

# Clone the git repository into the /tmp directory
git clone "$REPO_URL" /tmp/temp_repo

# Navigate into the cloned repository directory
cd /tmp/temp_repo

# Make changes to the Kubernetes manifest file(s)
# For example, let's say you want to change the image tag in a deployment.yaml file
sed -i "s|image:.*|image: atrayeeazurecicd/$2:$3|g" k8s-specifications/$1-deployment.yaml

# Add the modified files
git add .
git config user.email "azureagent@cicd.com"
git config user.name "Azure DevOps Agent"
# Commit the changes
git commit -m "Update Kubernetes manifest"

# Push the changes back to the repository
git push

# Cleanup: remove the temporary directory
rm -rf /tmp/temp_repo