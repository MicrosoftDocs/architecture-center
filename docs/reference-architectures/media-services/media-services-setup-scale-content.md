

Gridwich uses the Azure Media Services Platform as a Service (PaaS) for media processing.

## Azure Media Services V2

To perform the encoding of sprite sheets, or to create thumbnails during media processing, Gridwich uses the Azure Media Services V2 API via REST.

The [MediaServicesV2EncodeCreateHandler](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Encode.MediaServicesV2/src/EventGridHandlers/MediaServicesV2EncodeCreateHandler.cs) initiates work by calling the [MediaServicesV2RestEncodeService](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Encode.MediaServicesV2/src/Services/MediaServicesV2RestEncodeService.cs), which in turn uses the [MediaServicesV2RestWrapper](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Encode.MediaServicesV2/src/Services/MediaServicesV2RestWrapper.cs).

Within the [MediaServicesV2RestWrapper](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Encode.MediaServicesV2/src/Services/MediaServicesV2RestWrapper.cs), the function `ConfigureRestClient` sets up authentication via an [Azure.Core.TokenCredential](/dotnet/api/azure.identity.defaultazurecredential) object:

```csharp
var amsAccessToken = _tokenCredential.GetToken(
    new TokenRequestContext(
        scopes: new[] { "https://rest.media.azure.net/.default" },
        parentRequestId: null),
    default);
```

This code presents the identity of the [TokenCredential](/dotnet/api/azure.identity.interactivebrowsercredential) and requests authorization at the REST API scope.

When running locally, the `TokenCredential` prompts the developer to sign in. That identity is then presented when requesting access to the scope. For successful authentication, the developer must be a contributor on the resource, and the correct environment variables must be in the local settings file.

Use the Terraform file [functions/main.tf](https://github.com/mspnp/gridwich/blob/main/infrastructure/terraform/functions/main.tf) to configure a system-assigned managed identity for the Azure Functions App, with:

```terraform
resource "azurerm_function_app" "fxn" {
  name                       = format("%s-%s-fxn-%s", var.appname, var.domainprefix, var.environment)
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.fxnapp.id
  storage_account_name       = azurerm_storage_account.fxnstor.name
  storage_account_access_key = azurerm_storage_account.fxnstor.primary_access_key
  version                    = "~3"
  https_only                 = true

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      app_settings
    ]
  }
}
```

Use the Terraform [bashscriptgenerator/templates/ams_sp.sh](https://github.com/mspnp/gridwich/blob/main/infrastructure/terraform/bashscriptgenerator/templates/ams_sp.sh) script to authorize the Azure Functions service principal on the Azure Media Services account:

```bash
for id in ${mediaServicesAccountResourceId}
{
    echo "Granting fxn access to $id"
    az role assignment create --role "Contributor" --assignee-object-id ${functionPrincipalId} --scope $id
}
```

## Azure Media Services V3

The Azure Media Services V3 SDK doesn't support managed identity. Instead, the *ams_sp.sh* script creates an explicit service principal to use with the Media Services V3 SDK, by using the `az ams account sp create` command:

```azurecli
# Ref: https://docs.microsoft.com/azure/media-services/latest/access-api-cli-how-to

echo 'Creating service principal for Azure Media Services'
AZOUT=$(az ams account sp create --account-name ${mediaServicesName} --resource-group ${mediaServicesResourceGroupName} | jq '{AadClientId: .AadClientId, AadSecret:.AadSecret}')
```

The script then places the credentials in a key vault for app settings to consume:

```bash
echo 'Adding access policy in KeyVault'
USER_PRINCIPAL_NAME=$(az ad signed-in-user show | jq -r '.userPrincipalName')
az keyvault set-policy --name ${keyVaultName} --upn $USER_PRINCIPAL_NAME --secret-permissions set get list delete > /dev/null
echo 'Updating ams-sp-client-id and ams-sp-client-secret in KeyVault'
az keyvault secret set --vault-name ${keyVaultName} --name 'ams-sp-client-id' --value $(echo $AZOUT | jq -r '.AadClientId') > /dev/null
az keyvault secret set --vault-name ${keyVaultName} --name 'ams-sp-client-secret' --value $(echo $AZOUT | jq -r '.AadSecret')  > /dev/null
echo 'Revoking access policy in KeyVault'
az keyvault delete-policy --name ${keyVaultName} --upn $USER_PRINCIPAL_NAME > /dev/null
echo 'Done.'
```

The Function App settings use a reference to the Azure Key Vault. The script creates those and other settings in the Terraform `functions/main.tf` file:

```terraform
    {
      name        = "AmsAadClientId"
      value       = format("@Microsoft.KeyVault(SecretUri=https://%s.vault.azure.net/secrets/%s/)", var.key_vault_name, "ams-sp-client-id")
      slotSetting = false
    },
    {
      name        = "AmsAadClientSecret"
      value       = format("@Microsoft.KeyVault(SecretUri=https://%s.vault.azure.net/secrets/%s/)", var.key_vault_name, "ams-sp-client-secret")
      slotSetting = false
    },
```

## Scale Media Services resources

The Azure Media Services account owner can scale the streaming infrastructure by calling the Azure command-line interface (Azure CLI) within a YAML pipeline step.

The script is in [azcli-last-steps-template.yml](https://github.com/mspnp/gridwich/blob/main/infrastructure/azure-pipelines/templates/steps/azcli-last-steps-template.yml).

To set the Media Services *streaming endpoint* infrastructure scale, run:

```yaml
- task: AzureCLI@1
  displayName: 'Set the scale of Azure Media Services streaming endpoint infrastructure.'
  inputs:
    azureSubscription: '${{parameters.serviceConnection}}'
    scriptLocation: inlineScript
    inlineScript: |
      set -eu
      echo Set the scale of Azure Media Services streaming endpoint infrastructure for $AZURERM_MEDIA_SERVICES_ACCOUNT_RESOURCE_ID
      # Configurable values:
      amsStreamingEndpointScaleUnitsDesired=0
      #
      # Setup
      amsStreamingEndpointName=${{ parameters.applicationName }}amsse01${{ parameters.environment }}
      amsStreamingEndpointName=$(echo $amsStreamingEndpointName | tr '[:upper:]' '[:lower:]')
      amsaccount=$(az ams account show --ids $AZURERM_MEDIA_SERVICES_ACCOUNT_RESOURCE_ID)
      amsAccountName=$(echo $amsaccount | jq -r '.name')
      amsAccountResourceGroupName=$(echo $amsaccount | jq -r '.resourceGroup')
      amsStreamingEndpointListJson=$(az ams streaming-endpoint list --resource-group $amsAccountResourceGroupName --account-name $amsAccountName)
      amsStreamingEndpointJson=$(echo $amsStreamingEndpointListJson | jq --arg amssename $amsStreamingEndpointName -r '.[] | select(.name == $amssename)')
      amsDefaultJson=$(echo $amsStreamingEndpointListJson | jq -r '.[] | select(.name == "default")')
      #
      # If there is an endpoint, check and update the scale and run-state, otherwise create it.
      if [[ -n "$amsStreamingEndpointJson" ]]
      then
        scaleUnitsActual=$(echo $amsStreamingEndpointJson | jq -r '.scaleUnits')
        if [[ $scaleUnitsActual -ne $amsStreamingEndpointScaleUnitsDesired ]]
        then
          echo Azure Media Services streaming endpoint $amsStreamingEndpointName will be scaled
          echo az ams streaming-endpoint scale --resource-group $amsAccountResourceGroupName --account-name $amsAccountName --name $amsStreamingEndpointName --scale-units $amsStreamingEndpointScaleUnitsDesired --no-wait
          az ams streaming-endpoint scale --resource-group $amsAccountResourceGroupName --account-name $amsAccountName --name $amsStreamingEndpointName --scale-units $amsStreamingEndpointScaleUnitsDesired --no-wait
        fi
        resourceStateActual=$(echo $amsStreamingEndpointJson | jq -r '.resourceState')
        if [[ $resourceStateActual == "Stopped"  ]]
        then
          echo Starting the $amsStreamingEndpointName endpoint
          echo az ams streaming-endpoint start --resource-group $amsAccountResourceGroupName --account-name $amsAccountName --name $amsStreamingEndpointName --no-wait
          az ams streaming-endpoint start --resource-group $amsAccountResourceGroupName --account-name $amsAccountName --name $amsStreamingEndpointName --no-wait
        fi
      else
        echo Azure Media Services streaming endpoint $amsStreamingEndpointName will be created
        echo az ams streaming-endpoint create --resource-group $amsAccountResourceGroupName --account-name $amsAccountName --name $amsStreamingEndpointName --auto-start --scale-units $amsStreamingEndpointScaleUnitsDesired --no-wait
        az ams streaming-endpoint create --resource-group $amsAccountResourceGroupName --account-name $amsAccountName --name $amsStreamingEndpointName --auto-start --scale-units $amsStreamingEndpointScaleUnitsDesired --no-wait
      fi
      #
      # If there is a default endpoint, stop it.
      if [[ -n "$amsDefaultJson" ]]
      then
        resourceStateActual=$(echo $amsDefaultJson | jq -r '.resourceState')
        if [[ $resourceStateActual != "Stopped"  ]]
        then
          echo Stopping the default endpoint
          echo az ams streaming-endpoint stop --resource-group $amsAccountResourceGroupName --account-name $amsAccountName --name default --no-wait
          az ams streaming-endpoint stop --resource-group $amsAccountResourceGroupName --account-name $amsAccountName --name default --no-wait
        fi
      fi
    addSpnToEnvironment: true
```

## Next steps

Product documentation:

- [Gridwich cloud media system](gridwich-architecture.yml)
- [About Azure Key Vault](/azure/key-vault/general/overview)
- [Azure Media Services v3 overview](/azure/media-services/latest/media-services-overview)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)

Microsoft Learn modules:

- [Configure and manage secrets in Azure Key Vault](/learn/modules/configure-and-manage-azure-key-vault)
- [Explore Azure Functions](/learn/modules/explore-azure-functions)

## Related resources

- [Gridwich content protection and DRM](gridwich-content-protection-drm.yml)
- [Gridwich request-response messages](gridwich-message-formats.yml)
- [Gridwich saga orchestration](gridwich-saga-orchestration.yml)
- [Gridwich variable flow](variable-group-terraform-flow.yml)
