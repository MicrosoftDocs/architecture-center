---
title: Use Deployment Scripts to Check Resource Properties
description: Use Bicep and a deployment script to pause a deployment until a resource property returns a specific value.
author: jtracey93
ms.author: jatracey
ms.date: 05/05/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
    - devx-track-bicep
azureCategories:
  - devops
  - networking
products:
  - azure-resource-manager
  - azure-virtual-network
  - azure-virtual-wan
---

# Use deployment scripts to check resource properties

This article describes how to use Bicep and a deployment script to pause a deployment until a resource property returns a specific value. You can use this technique to ensure that a deployment succeeds if the deployed resource reports to Azure Resource Manager that it's ready but the underlying resources aren't. In this case, the deployed resource isn't yet ready to interact with the rest of the deployment, which means a pause is required.

This article uses an Azure Virtual WAN scenario to demonstrate the technique. The following files include a resource check and pause implementation:

- [orchestration.bicep](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/orchestration.bicep)
- [azResourceStateCheck.bicep](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/modules/azResourceStateCheck.bicep)
- [Invoke-AzResourceStateCheck.ps1](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/scripts/Invoke-AzResourceStateCheck.ps1)

You can adapt the files for your deployment. To help you, the azResourceStateCheck.bicep module is parameterized. The `dependsOn` property is used in orchestration.bicep to ensure that the vwanvhcs.bicep module deployment depends on the azResourceStateCheck.bicep module deployment.

## Architecture

:::image type="complex" border="false" source="./images/deployment-scripts-property-check.svg" alt-text="Diagram that shows the Bicep and deployment script architecture." lightbox="./images/deployment-scripts-property-check.svg":::
   Diagram that shows the deployment architecture split into two main areas. The left side displays the Azure resources created within a subscription boundary. The boundary includes a resource group that contains an Azure Virtual WAN that contains a virtual hub, three virtual networks with subnets, virtual hub connections, and a user-assigned managed identity with an Azure role-based access control (RBAC) Reader role assignment. The deployment script resource has a two-way connection to the user-assigned managed identity and to  the three virtual hub connections, and it outputs to the virtual hub. The right side shows the Bicep module file structure, which includes orchestration.bicep, with connections to the modules folder and to the scripts folder. The modules folder contains vnet.bicep, vwan.bicep, vwanhub.bicep, vwanvhcs.bicep, and azResourceStateCheck.bicep. The scripts folder contains Invoke-AzResourceStateCheck.ps1.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/deployment-scripts-property-check.vsdx) of this architecture.*

*Review and download the [code samples in GitHub](https://github.com/Azure/CAE-Bits/tree/main/infra/samples/deployment-scripts-property-check) for this architecture.*

1. Submit the orchestration.bicep file for deployment to Resource Manager at the subscription scope.

   > [!NOTE]
   > You can get this Bicep file and the other files that are used for this example from the [infra/samples/deployment-scripts-property-check directory](https://github.com/Azure/CAE-Bits/tree/main/infra/samples/deployment-scripts-property-check). A partial organization of the files in the repo appears on the right-hand side of the architecture diagram.

1. The orchestration.bicep file creates a resource group at the subscription scope.

1. The orchestration.bicep file deploys the Virtual WAN and the spoke virtual networks.

   - orchestration.bicep deploys the [vwan.bicep](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/modules/vwan.bicep) module, which deploys the Virtual WAN at the resource group scope.

   - orchestration.bicep deploys the [vnet.bicep](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/modules/vnet.bicep) module, which deploys the virtual networks at the resource group scope.

   The Virtual WAN and spoke virtual networks are deployed in parallel because Bicep regards them as independent of one another. Dependencies determine the order of deployment in Bicep. A resource is deployed before any resource that depends on it. For more information about resource dependencies in Bicep, including explicit and implicit dependencies, see [Resource dependencies in Bicep](/azure/azure-resource-manager/bicep/resource-dependencies).

1. The orchestration.bicep file deploys the [vwanhub.bicep](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/modules/vwanhub.bicep) module, which deploys the Virtual WAN hub at the resource group scope. The hub depends implicitly on the Virtual WAN, which means that the hub deployment occurs only after the Virtual WAN deployment completes.

1. The orchestration.bicep file deploys the azResourceStateCheck.bicep module, which creates a user-assigned managed identity and assigns the Azure role-based access control (RBAC) Reader role to the resource group.

1. The azResourceStateCheck.bicep module deploys the [deployment script resource](/azure/templates/microsoft.resources/deploymentscripts?pivots=deployment-language-bicep).

1. The deployment script resource uses the user-assigned managed identity for Resource Manager authentication. The resource then runs the PowerShell deployment script, Invoke-AzResourceStateCheck.ps1. For more information about deployment scripts, see [Use deployment scripts in Bicep](/azure/azure-resource-manager/bicep/deployment-script-bicep).

   The script polls the Virtual WAN hub `routingState` property to determine whether the value is `Provisioned`:

   1. If the property value isn't `Provisioned`, the script pauses for a duration specified by a parameter set in the orchestration.bicep file and is passed to the azResourceStateCheck.bicep module. The script then checks the value of the `routingState` property value again.

      The script repeats the pause-and-check cycle. A parameter in the orchestration.bicep file determines the maximum number of iterations. If the property value isn't `Provisioned` after the maximum number of iterations, the script generates an exception and exits, which causes the remainder of the Bicep deployment to stop and fail.

   1. If the property value is `Provisioned`, the deployment script exits with a success code `(0)`.

1. If the deployment script succeeds, the orchestration.bicep file deploys the vwanvhcs.bicep module, which creates the connections between the spoke virtual networks and the Virtual WAN hub.

   The definition of the vwanvhcs.bicep module that's in orchestration.bicep has a `dependsOn` clause that causes vwanvhcs.bicep to depend explicitly on the successful completion of the azResourceStateCheck.bicep module. Therefore, the connections are created only if the `routingState` property is `Provisioned`.

   The vwanvhcs.bicep module deploys the Virtual WAN hub connections sequentially, rather than in parallel, because parallel deployment isn't supported for a single Virtual WAN hub. To set the batch size to `1`, the module uses the Bicep `batchSize` decorator, `@batchSize(1)`. This decorator ensures that the connections are deployed one at a time.

### Scenario details

The key parts of this architecture are the azResourceStateCheck.bicep module, which deploys the deployment script resource, and the associated deployment script Invoke-AzResourceStateCheck.ps1, which is a PowerShell file. The module uses the deployment script to check the value of a resource property. In this example, the resource is a Virtual WAN hub.

You can use `dependsOn` to make one module depend explicitly on another because this environment is deployed from a single file that uses Bicep modules. In this example, `dependsOn` makes the vwanvhcs.bicep module depend on the azResourceStateCheck.bicep module.

The following excerpt from orchestration.bicep shows `dependsOn` in use:

```Bicep
@description('The API version of the Azure Resource you need to use to check the state of a property.')
param parAzResourceApiVersion string = '2022-01-01'

@description('The property of the resource that you need to check. This is a property inside the `properties` bag of the resource that's captured from a GET call to the Resource ID.')
param parAzResourcePropertyToCheck string = 'routingState'

@description('The value of the property of the resource that you need to check.')
param parAzResourceDesiredState string = 'Provisioned'

@description('The duration that the deployment script waits between check or polling requests to check the property and its state, if it is not in its desired state. The duration defaults to `30` seconds.')
param parWaitInSecondsBetweenIterations int = 30

module modVWANHub 'modules/vwanHub.bicep' = {
  scope: rsg
  name: 'deployVWANHub'
  params: {
    region: region
    regionNamePrefix: regionNamePrefix
    defaultTags: defaultTags
    vwanHubCIDR: vwanHubCIDR
    vwanName: modVWAN.outputs.vwanName
  }
}

module modVWANHubRouterCheckerDeploymentScript 'modules/azResourceStateCheck.bicep' = {
  scope: rsg
  name: 'deployVWANHubRouterChecker'
  params: {
    parLocation: region
    parAzResourceId: modVWANHub.outputs.outVwanVHubId
    parAzResourceApiVersion: parAzResourceApiVersion
    parAzResourcePropertyToCheck: parAzResourcePropertyToCheck
    parAzResourceDesiredState: parAzResourceDesiredState
    parMaxIterations: parMaxIterations
    parWaitInSecondsBetweenIterations: parWaitInSecondsBetweenIterations
  }
}

module modVWanVhubVnetConnections 'modules/vwanVhcs.bicep' = {
  dependsOn: [
    modVWANHubRouterCheckerDeploymentScript
  ]
  scope: rsg
  name: 'deployConnectVnetsToVWANVHub'
  params: {
    vnets: vnets
    regionNamePrefix: regionNamePrefix
  }
}
```

The resource check is required because deployed Virtual WAN hubs aren't ready for use until the `routingState` property has the value of `Provisioned`. Virtual WAN hubs report successful deployment to the Resource Manager so the deployment engine continues deployment. A new Virtual WAN hub becomes operational after the Virtual WAN hub router is provisioned into the created hub. This process takes around 15 minutes. This behavior can be seen in the following screenshot of a new Virtual WAN hub. The screenshot shows a hub status of `Succeeded` but a routing status of `Provisioning`.

:::image type="content" border="true" source="./images/virtual-wan-hub-routing-status-provisioning.png" alt-text="Screenshot of a newly deployed Virtual WAN hub. The hub status is Ready and the routing status is Provisioning." lightbox="./images/virtual-wan-hub-routing-status-provisioning.png":::
:::image-end:::

If you try to deploy the vwanvhcs.bicep module before the `routingState` value is `Provisioned`, connection creation fails and overall deployment fails. Until the router is provisioned, redeployment attempts also fail.

The following screenshot shows an example of the deployment script log during `routingState` checks of the Virtual WAN hub. The log shows repeated checks of the property that return a value other than `Provisioned`.

:::image type="content" border="true" source="./images/deployment-script-in-action.png" alt-text="Screenshot that shows the deployment script polling the Virtual WAN hub routingState property." lightbox="./images/deployment-script-in-action.png":::
:::image-end:::

The following screenshot shows that the value changes to `Provisioned`.

:::image type="content" border="true" source="./images/deployment-script-in-action.png" alt-text="Screenshot that shows the completion of the deployment script when the Virtual WAN hub routingState property changes to Provisioned." lightbox="./images/deployment-script-in-action.png":::
:::image-end:::

If the value doesn't change to `Provisioned` after the maximum number of iterations, the script generates an exception, which signals the script resource failure to the Resource Manager. The Resource Manager deployment engine fails and stops the deployment because the exception suggests that there's an issue with the Azure resource that requires troubleshooting. For more information, see the following Invoke-AzResourceStateCheck.ps1 script.

```powershell
[CmdletBinding()]
param (
  [string]
  $azResourceResourceId,

  [string]
  $apiVersion = "2022-05-01",

  [string]
  $azResourcePropertyToCheck = "provisioningState",

  [string]
  $azResourceDesiredState = "Provisioned",

  [int]
  $waitInSecondsBetweenIterations = 30,

  [int]
  $maxIterations = 30
)

$totalTimeoutCalculation = $waitInSecondsBetweenIterations * $maxIterations

$azResourcePropertyExistenceCheck = Invoke-AzRestMethod -Method GET -Path "$($azResourceResourceId)?api-version=$($apiVersion)"

if ($azResourcePropertyExistenceCheck.StatusCode -ne "200") {
  $DeploymentScriptOutputs["azResourcePropertyState"] = "Not Found"
  throw "Unable to get Azure Resource - $($azResourceResourceId). Likely it doesn't exist. Status code: $($azResourcePropertyExistenceCheck.StatusCode) Error: $($azResourcePropertyExistenceCheck.Content)"
}

$azResourcePropertyStateResult = "Unknown"
$iterationCount = 0

do {
  $azResourcePropertyStateGet = Invoke-AzRestMethod -Method GET -Path "$($azResourceResourceId)?api-version=$($apiVersion)"
  $azResourcePropertyStateJsonConverted = $azResourcePropertyStateGet.Content | ConvertFrom-Json -Depth 10
  $azResourcePropertyStateResult = $azResourcePropertyStateJsonConverted.properties.$($azResourcePropertyToCheck)

  if ($azResourcePropertyStateResult -ne $azResourceDesiredState) {
    Write-Host "Azure Resource Property ($($azResourcePropertyToCheck)) is not in $($azResourceDesiredState) state. Waiting $($waitInSecondsBetweenIterations) seconds before checking again. Iteration count: $($iterationCount)"
    Start-Sleep -Seconds $waitInSecondsBetweenIterations
    $iterationCount++
  }
} while (
  $azResourcePropertyStateResult -ne $azResourceDesiredState -and $iterationCount -ne $maxIterations
)

if ($azResourcePropertyStateResult -eq $azResourceDesiredState) {
  Write-Host "Azure Resource Property ($($azResourcePropertyToCheck)) is now in $($azResourceDesiredState) state."
  $DeploymentScriptOutputs["azResourcePropertyState"] = "$($azResourceDesiredState)"
}

if ($iterationCount -eq $maxIterations -and $azResourcePropertyStateResult -ne $azResourceDesiredState) {
  $DeploymentScriptOutputs["azResourcePropertyState"] = "Azure Resource Property ($($azResourcePropertyToCheck)) is still not in desired state of $($azResourceDesiredState). Timeout reached of $($totalTimeoutCalculation) seconds."
  throw "Azure Resource Property ($($azResourcePropertyToCheck)) is still not in $($azResourceDesiredState) state after $($totalTimeoutCalculation) seconds."
}
```

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Jack Tracey](https://www.linkedin.com/in/jacktracey93) | Senior Cloud Solutions Architect

Other contributor:

- [Gary McMahon](https://www.linkedin.com/in/gmcmaho1) | Senior Cloud Solutions Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Files for the example in the Azure/CAE-Bits repo](https://github.com/Azure/CAE-Bits/tree/main/infra/samples/deployment-scripts-property-check)
- [Use deployment scripts in Bicep](/azure/azure-resource-manager/bicep/deployment-script-bicep)
- [Learn module: Extend Bicep and ARM templates using deployment scripts](/training/modules/extend-resource-manager-template-deployment-scripts/)
- [Everything you wanted to know about exceptions](/powershell/scripting/learn/deep-dives/everything-about-exceptions)
- [Migrate to Virtual WAN](/azure/virtual-wan/migrate-from-hub-spoke-topology)
- [Resource dependencies in Bicep](/azure/azure-resource-manager/bicep/resource-dependencies)
- [Bicep documentation](/azure/azure-resource-manager/bicep)

## Related resources

- [Hub-spoke network topology with Virtual WAN](../../networking/architecture/hub-spoke-virtual-wan-architecture.yml)
- [Architectural approaches for the deployment and configuration of multitenant solutions](../multitenant/approaches/deployment-configuration.md)
- [Development, security, and operations for infrastructure as code](../../solution-ideas/articles/devsecops-infrastructure-as-code.yml)