
This article describes how to set up a local Gridwich development environment in either Visual Studio 2022 or above, or Visual Studio Code.

## Prerequisites

- Up-to-date [Visual Studio Code](https://code.visualstudio.com/) or [Visual Studio 2022](https://visualstudio.microsoft.com/downloads/).
- [Azure CLI](/cli/azure/install-azure-cli)
- [.NET 6.0](https://dotnet.microsoft.com/download/dotnet/6.0)
- [PowerShell](/powershell/scripting/overview)
- [Git](https://git-scm.com/downloads) installed, and your organization's Azure DevOps Gridwich repository cloned to your local machine. If you're using Windows [GitHub Desktop](https://desktop.github.com/), avoid cloning into user directories.

Optional:

- [curl](https://curl.haxx.se/)
- [Postman](https://www.postman.com/)

## Visual Studio Code setup

1. In Visual Studio Code, when prompted which version of Terraform language server to install, select the latest stable version:

1. After installation, run the following command:

   ```bash
   dotnet restore ./src --interactive
   ```

1. At the prompt, sign in to Azure so your build can access the artifact feed for installing the necessary NuGet packages.

1. Follow the instructions to [create local.settings.json](#create-localsettingsjson).

1. Press **F5**.

You can now make requests to the two Function endpoints shown in the build output, for example:

- `EventGrid: [POST] http://localhost:7071/api/EventGrid`
- `MediaInfo: [GET] http://localhost:7071/api/MediaInfo`

## Visual Studio setup

1. In Visual Studio, open the *src\Gridwich.Host.FunctionApp.sln* file in the directory where you cloned the Gridwich repository.

1. In **Solution Explorer**, right-click the **Gridwich.Host.FunctionApp** library and select **Set as Startup Project**.

1. Follow the instructions to [create local.settings.json](#create-localsettingsjson).

1. Press **F5**.

You can now make requests to the two Function endpoints shown in the build output, for example:

- `EventGrid: [POST] http://localhost:7071/api/EventGrid`
- `MediaInfo: [GET] http://localhost:7071/api/MediaInfo`

## Create local.settings.json

The following procedure creates the settings on your local machine to run the Gridwich Azure Function.

For an example *local.settings.json* file, see [sample.local.settings.json](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Host.FunctionApp/src/sample.local.settings.json).

If you need an Azure PowerShell CLI environment, you can use [Azure Cloud Shell](https://shell.azure.com) and select PowerShell instead of Bash.

1. To create the file, use the following PowerShell script and edit the results. In the script, use your Azure tenant and subscription values, and replace `mygridwichapp` with your application name.

   ```azurepowershell
   # Change the $targetEnv if you're not using the 'sb' environment
   $targetEnv = "sb"
   $targetTenant = "00000000-0000-0000-0000-000000000000"
   $targetSub = "00000000-0000-0000-0000-000000000000"
   $appname = "mygridwichapp"

   az account set --subscription $targetSub
   $appSettings = az webapp config appsettings list --subscription $targetSub --name $appname-grw-fxn-$targetEnv -g $appname-application-rg-$targetEnv | ConvertFrom-Json
   $settingsList = New-Object System.Collections.ArrayList($null)
   $settingsList.AddRange($appSettings)
   echo "{""IsEncrypted"": false,""Values"": {" > local.settings.$targetEnv.json
   $settingsList.ForEach({echo """$($_.name)"":""$($_.value)"","}) >> local.settings.$targetEnv.json
   echo """AzureWebJobsStorage"": ""UseDevelopmentStorage=true"",""FUNCTIONS_WORKER_RUNTIME"": ""dotnet"",""FUNCTIONS_EXTENSION_VERSION"": ""~4"",""AZURE_TENANT_ID"": ""$targetTenant"",""AZURE_SUBSCRIPTION_ID"": ""$targetSub""}}" >> local.settings.$targetEnv.json
   type local.settings.$targetEnv.json
   ```

1. Edit the resulting *local.settings.sb.json* file to remove the following lines:

   - `AzureWebJobsDashboard`
   - The `AzureWebJobsStorage` pointing to a connection string
   - `WEBSITE_CONTENTAZUREFILECONNECTIONSTRING`
   - `WEBSITE_CONTENTSHARE`
   - `WEBSITE_ENABLE_SYNC_UPDATE_SITE`
   - `WEBSITE_RUN_FROM_PACKAGE`

### Update Azure Key Vault secrets

To view Azure Key Vault keys and secrets, run the following script:

```azurepowershell
$keyVaultName = 'gridwich-kv-sb'
$targetUserPrincipalName = (az ad signed-in-user show | ConvertFrom-Json).userPrincipalName
az keyvault set-policy --name $keyVaultName --secret-permissions list get --upn $targetUserPrincipalName
```

Or, you can use the following Azure CLI commands:

1. Run the following command:

   ```azurecli
   az ad signed-in-user show
   ```

1. In the output, find and copy `userPrincipalName`, which may look like: `<your username_yourdomain>.com#EXT#@<an Azure Active Directory>.onmicrosoft.com`.

1. Run the following command, using the `userPrincipalName` value you copied:

   ```azurecli
   az keyvault set-policy --name gridwich-kv-sb --secret-permissions list get --upn "<your username_yourdomain>.com#EXT#@<an Azure Active Directory>.onmicrosoft.com"
   ```

To replace the `@Microsoft.KeyVault` secrets in *local.settings.sb.json* with actual values, run:

```azurepowershell
$keyVaultName="$appname-kv-$targetEnv"
$targetUserPrincipalName = (az ad signed-in-user show | ConvertFrom-Json).userPrincipalName
az keyvault set-policy --name $keyVaultName --secret-permissions list get --upn $targetUserPrincipalName
$APPLICATIONINSIGHTS_CONNECTION_STRING=$((az keyvault secret show --vault-name $keyVaultName --name appinsights-connectionstring  | ConvertFrom-Json).value)
$TELESTREAMCLOUD_API_KEY=$((az keyvault secret show --vault-name $keyVaultName --name telestream-cloud-api-key  | ConvertFrom-Json).value)
$GRW_TOPIC_END_POINT=$((az keyvault secret show --vault-name $keyVaultName --name grw-topic-end-point  | ConvertFrom-Json).value)
$GRW_TOPIC_KEY=$((az keyvault secret show --vault-name $keyVaultName --name grw-topic-key   | ConvertFrom-Json).value)
$AmsDrmFairPlayAskHex=$((az keyvault secret show --vault-name $keyVaultName --name ams-fairplay-ask-hex   | ConvertFrom-Json).value)
echo $('"APPLICATIONINSIGHTS_CONNECTION_STRING":"'+$APPLICATIONINSIGHTS_CONNECTION_STRING+'",') $('"TELESTREAMCLOUD_API_KEY":"'+$TELESTREAMCLOUD_API_KEY+'",') $('"GRW_TOPIC_END_POINT":"'+$GRW_TOPIC_END_POINT+'",') $('"GRW_TOPIC_KEY":"'+$GRW_TOPIC_KEY+'",') $('"AmsDrmFairPlayAskHex":"'+$AmsDrmFairPlayAskHex+'",')
```

### Replace the local file

Rename *local.settings.sb.json* to *local.settings.json* and copy it to [Gridwich.Host.FunctionApp/src](https://github.com/mspnp/gridwich/tree/main/src/Gridwich.Host.FunctionApp/src). Or edit *local.settings.json* in place, using the console output from the preceding scripts.

### Add dummy values for Azure FairPlay DRM

Manually add the following two values to *local.settings.json*:

- `AmsDrmFairPlayCertificateB64`. Use the base 64 string from [FakeFairPlayCert/FairPlay-out-base64.txt](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Publication.MediaServicesV3/tests/FakeFairPlayCert/FairPlay-out-base64.txt). Remove the line endings and set the string in a single line.
- `AmsDrmFairPlayPfxPassword`. Use the dummy password from [FakeFairPlayCert/password.txt](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Publication.MediaServicesV3/tests/FakeFairPlayCert/password.txt).

## Next steps

- [Create or delete a Gridwich cloud sandbox or test environment](create-delete-cloud-environment.yml)
- [Test a deployed Gridwich app locally](test-encoding.yml#how-to-test-gridwich-projects-locally)
