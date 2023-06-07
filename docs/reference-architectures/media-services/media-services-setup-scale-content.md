---
ms.custom:
  - devx-track-azurecli
---
Gridwich uses the Azure Media Services Platform as a Service (PaaS) for media processing.

## Azure Media Services v3

Use the Terraform file [functions/main.tf](https://github.com/mspnp/gridwich/blob/main/infrastructure/terraform/functions/main.tf) to configure a system-assigned managed identity for the Azure Functions App, with:

```terraform
resource "azurerm_windows_function_app" "fxn" {
  name                       = format("%s-%s-fxn-%s", var.appname, var.domainprefix, var.environment)
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.fxnapp.id
  storage_account_name       = azurerm_storage_account.fxnstor.name
  storage_account_access_key = azurerm_storage_account.fxnstor.primary_access_key
  functions_extension_version = "~4"
  https_only                  = true
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "dotnet"
  }
  site_config {
  }
  identity {
    type = "SystemAssigned"
  }
  lifecycle {
    ignore_changes = [
      app_settings,
      site_config
    ]
  }
}
```

Use the Terraform [bashscriptgenerator/templates/ams_sp.sh](https://github.com/mspnp/gridwich/blob/main/infrastructure/terraform/bashscriptgenerator/templates/ams_sp.sh) script to authorize the Azure Functions identity on the Azure Media Services account:

```bash
for id in ${mediaServicesAccountResourceId}
{
    echo "Granting fxn access to $id"
    az role assignment create --role "Contributor" --assignee-object-id ${functionPrincipalId} --scope $id --assignee-principal-type ServicePrincipal
}
```

## Scale Media Services resources

The Azure Media Services account owner can scale the streaming infrastructure by calling the Azure command-line interface (Azure CLI) within a YAML pipeline step.

The script is in [azcli-last-steps-template.yml](https://github.com/mspnp/gridwich/blob/main/infrastructure/azure-pipelines/templates/steps/azcli-last-steps-template.yml).

To set the Media Services *streaming endpoint* infrastructure scale, run:

```yaml
- task: AzureCLI@2
  displayName: 'Set the scale of Azure Media Services streaming endpoint infrastructure.'
  inputs:
    azureSubscription: '${{parameters.serviceConnection}}'
    scriptType: bash
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

- [Configure and manage secrets in Azure Key Vault](/training/modules/configure-and-manage-azure-key-vault)
- [Explore Azure Functions](/training/modules/explore-azure-functions)

## Related resources

- [Gridwich content protection and DRM](gridwich-content-protection-drm.yml)
- [Gridwich request-response messages](gridwich-message-formats.yml)
- [Gridwich saga orchestration](gridwich-saga-orchestration.yml)
- [Gridwich variable flow](variable-group-terraform-flow.yml)
