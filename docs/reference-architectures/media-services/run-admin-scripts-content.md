
The Azure Pipelines continuous integration and delivery (CI/CD) pipelines deploy the Gridwich application into Azure, but they don't set up any identity principals or their access rights to Azure resources. The pipelines use Terraform to generate and publish admin scripts, and a user with elevated permissions must run the scripts manually to create and configure Azure resources. This article describes the admin scripts and how to run them.

## Grant admin privileges

A user with elevated privileges must execute the pipeline-generated admin scripts. To grant users elevated privileges:

1. In Azure Active Directory (Azure AD), create a named group such as *Gridwich Admins*, and add the authorized admins to it.

1. In the Azure Subscription, select **Access Control (IAM)** in the left navigation, select **Add role assignments**, and then assign the **User Access Administrator** role for **Gridwich Admins**.

## Run the admin scripts

The pipelines convert environment variables to Terraform variables to find and replace the variable names in the admin script templates. For more information about this process, see [Pipelines to Terraform variable flow](variable-group-terraform-flow.yml).

The bash script source before variables replacement is in the Gridwich [bashscriptgenerator/templates](https://github.com/mspnp/gridwich/blob/main/infrastructure/terraform/bashscriptgenerator/templates) directory.

You can run the scripts in any order.

Connect to Azure and set \<subscriptionID> to the default subscription before running the scripts.

```azurecli
az login --tenant "<tenantID>"
az account set --subscription "<subscriptionID>"
```

### The ams_sp.sh script

The `ams_sp.sh` script grants the Azure Function App access to Azure Media Services resources.

The Terraform variables are:

- **mediaServicesAccountResourceId**, a list of Media Services Resource IDs.
- **functionPrincipalId**, the Function App managed identity service principal ID.
- **mediaServicesName**, the Media Services account name.
- **mediaServicesResourceGroupName**, the Media Services account resource group.

To run the script:

1. Download the *ams_sp.sh* file that the pipeline published as an artifact in the *bash_scripts_\** folder.
1. Run the following command:

   ```bash
   chmod +x ams_sp.sh && ./ams_sp.sh
   ```

### The egv_app_registration.sh script

The `egv_app_registration.sh` script uses the *egv_app_registration_manifest.json* file to secure the Azure Event Grid Viewer web app for each environment. The script creates and configures an [Azure App Registration](/azure/active-directory/develop/quickstart-register-app) for [Azure Active Directory (Azure AD)](/azure/active-directory/fundamentals/active-directory-whatis). The script then configures the Event Grid Viewer web app to use the App Registration to secure the viewer, making it available only to those that have proper Azure AD credentials.

The *egv_app_registration_manifest.json* file must be in the same directory as the script file for the script to run correctly. Using an external manifest file to configure an Azure App Registration is a Microsoft [best practice](https://github.com/Azure/azure-cli/issues/6023#issuecomment-400011467). The GUIDs used in the manifest file are called [well-known-appids](https://github.com/mjisaak/azure-active-directory/blob/master/README.md#well-known-appids), so they aren't a security risk when hard-coded in the manifest file.

The Terraform variables are:

- **tenantId**, the Azure AD tenant ID, which is used to create the token issuer URL.
- **eventgridViewerResourceGroupName**, the Event Grid Viewer resource group name.
- **eventgridViewerAppName**, the Event Grid Viewer web app name.
- **pipelineBuildId**, the pipeline Build ID. This value is currently unused, but can be used to build an Azure DevOps Build URL to display generated artifacts on screen.
- **keyVaultName**, the Azure Key Vault to store the Azure AD App Registration AppId/ClientId.

To run the script:

1. Download the published *egv_app_registration.sh* and *egv_app_registration_manifest.json* files into the same directory.
1. Run the following command:

   ```bash
   chmod +x egv_app_registration.sh && ./egv_app_registration.sh
   ```

### The fxn_to_storage_sp.sh script

The `fxn_to_storage_sp.sh` bash script grants the Function App access to various Azure Storage Accounts and their resource groups.

The script:

1. Loops and grants the Function App **Storage Blob Data Contributor** access to the Azure Storage Accounts.
1. Loops and grants the Function App **Reader and Data Access** access to the resource groups that contain the Storage Accounts.

The Terraform variables are:

- **storageAccountIds**, the list of Azure Storage Account IDs.
- **functionPrincipalId**, the Function App managed identity service principal ID.
- **storageRgIds**, the IDs of the resource groups that contain the Storage Accounts.

To run the script:

1. Download the published *fxn_to_storage_sp.sh* file.
1. Run the following command:

   ```bash
   chmod +x fxn_to_storage_sp.sh && ./fxn_to_storage_sp.sh
   ```

### The logic_app_sp.sh script

The `logic_app_sp.sh` bash script grants the Azure Logic App access to the Function App, the Storage Accounts, and the Storage Account resource groups.

The script:

1. Grants the Logic App **Website Contributor** access to the Function App.
1. Loops and grants the Logic App **Storage Blob Data Contributor** access to Azure Storage Accounts.
1. Loops and grants the Logic App **Reader and Data Access** access to the resource groups that contain the Storage Accounts.

The Terraform variables are:

- **logicAppSCHServicePrincipalId**, the Logic App managed identity service principal ID.
- **functionPrincipalId**, the Function App managed identity service principal ID.
- **storageAccountIds**, the list of Azure Storage Account IDs.
- **storageRgIds**, the IDs of the resource groups that contain the Storage Accounts.

To run the script:

1. Download the published *logic_app_sp.sh* file.
1. Run the following command:

   ```bash
   chmod +x logic_app_sp.sh && ./logic_app_sp.sh
   ```

## Next steps

- [Maintain and rotate Key Vault keys](maintain-keys.yml)
- [Variable group to Terraform flow](variable-group-terraform-flow.yml)
