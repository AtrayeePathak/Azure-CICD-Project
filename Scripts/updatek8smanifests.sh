 #!/bin/bash
# Add set -e so the pipeline actually fails and turns RED if a command breaks!
set -e 
set -x

# 1. FIX THE URL: Ensure your actual org name 'atrayeepathak31' is here, NOT the placeholder
REPO_URL="https://:***REDACTED_PAT_2***@dev.azure.com/atrayeepathak31/Azure-devOps-project/_git/Azure-devOps-project"
# Clone the git repository into the /tmp directory
git clone "$REPO_URL" /tmp/temp_repo

# Navigate into the cloned repository directory
cd /tmp/temp_repo

# Update the image tag in the deployment.yaml file
sed -i "s|image:.*|image: atrayeeazurecicd.azurecr.io/$2:$3|g" k8s-specifications/$1-deployment.yaml

# Add the modified files
git add .

# Configure Git Identity for the Agent
git config user.email "azureagent@cicd.com"
git config user.name "Azure DevOps Agent"

# Commit the changes
git commit -m "Update Kubernetes manifest with new image tag"

# Push the changes back to the repository
git push

# Cleanup
rm -rf /tmp/temp_repo