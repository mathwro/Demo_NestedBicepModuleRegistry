# Bicep Registry Workflows

This repo publishes Bicep resources and modules to an Azure Container Registry (ACR) using GitHub Actions.

## Requirements

1. Azure AD app + federated credentials for GitHub Actions OIDC.
2. An ACR that allows the app to publish Bicep modules.
3. GitHub repository secrets:
   - AZURE_CLIENT_ID
   - AZURE_TENANT_ID
   - AZURE_SUBSCRIPTION_ID
   - ACR_NAME

## Repository Layout

- resources/\<resource\>/\<version\>/\<file\>.bicep
- modules/\<module\>/\<version\>/\<file\>.bicep

## Workflow Behavior

- Publish Bicep Resources: triggers on changes under resources/ and publishes both version and latest tags.
- Publish Bicep Modules: triggers on changes under modules/ and publishes both version and latest tags.
- A resource publish sends a repository_dispatch to trigger the module workflow.
- The module workflow scans the dispatch payload for resource changes and publishes dependent modules.

## Setup Steps

1. Create an Azure AD application and grant it access to the ACR.
   - Assign AcrPush role to the app on the ACR.
   - Assign Reader role to the app on the ACR (Note, not strictly required but the line in the scripts with az acr show will fail the run without it).
2. Configure GitHub Actions OIDC in Entra ID (federated credentials).
   - Subject should match repo and workflow (for example: repo:<owner>/<repo>:ref:refs/heads/main).
3. Add the required secrets to the GitHub repo.
   1. AZURE_CLIENT_ID: The app (client) ID of the Azure AD application.
   2. AZURE_TENANT_ID: The tenant ID of the Azure AD application
   3. AZURE_SUBSCRIPTION_ID: The subscription ID where the ACR is located.
   4. ACR_NAME: The name of the Azure Container Registry (without the .azurecr.io suffix).
4. Place Bicep files into the resources/ and modules/ folders following the layout above.
5. Push to main. The workflows will publish:
   - br:\<acr_login_server\>/resources/\<name\>:\<version\> and :latest
   - br:\<acr_login_server\>/modules/\<name\>:\<version\> and :latest
  
## Notes

- The --force flag is used in the az bicep publish command to allow overwriting existing versions. In a production scenario, you may want to remove this flag to prevent accidental overwrites.
- Remember to update the reference to the correct ACR name in the Bicep file for referencing the ACR-hosted modules. (The "br:demoname.azurecr.io/resources/storageaccount:latest" line in the storageContainer.bicep file is an example and should be updated to match your ACR login server and module path).