This article describes an approach that uses [Deployment Scripts](/azure/azure-resource-manager/bicep/deployment-script-bicep) to check the property of an Azure resource has a desired value. The Deployment Script is used to ensure a Bicep/ARM (Azure Resource Manager) deployment is successful when the resource being deployed reports to ARM that it is "ready" but underlying resources are not and therefore that resource isn't ready to be interacted with further in the remainder of the deployment yet.

> [!NOTE]
> For the purposes of this document, we will use an Azure Virtual WAN scenario to explain how Deployment Scripts can be used to help orchestrate a single end-to-end deployment. However, this approach can be taken and used against any Azure resource to help orchestrate the single deployment by checking the value of a property of the resource is as desired.
>
> If you are looking to use this against another resource type then you should review the following files and use utilize these in your deployment scenario, similar to how this article describes around utilizing the `dependsOn` property on resource/module deployments from your orchestration Bicep file:
>
> - [`azResourceStateCheck.bicep`](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/modules/azResourceStateCheck.bicep)
> - [`Invoke-AzResourceStateCheck.ps1`](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/scripts/Invoke-AzResourceStateCheck.ps1)

## Architecture

[![Architecture Diagram](images/deployment-scripts-property-check.png)](images/deployment-scripts-property-check.png#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/deployment-scripts-property-check.vsdx) of this architecture.*

*Review and utilize the [code samples in GitHub](https://github.com/Azure/CAE-Bits/tree/main/infra/samples/deployment-scripts-property-check) for this architecture.*

### Workflow

1. Submit [`orchestration.bicep`](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/orchestration.bicep) Bicep file for deployment to ARM at the Subscription scope.
2. Resource Group is created in Subscription.
3. Virtual WAN and spoke Virtual Networks are deployed in [parallel (default in ARM)](azure/azure-resource-manager/bicep/resource-dependencies).
4. Once the Virtual WAN deployment is complete, the Virtual WAN Hub is deployed inside the Virtual WAN (handled by an [implicit dependency](/azure/azure-resource-manager/bicep/resource-dependencies#implicit-dependency)).
5. A User-Assigned Managed Identity is then created and assigned the `Reader` RBAC (Role-Based Access Control) Role on the Resource Group.
6. Once the Role Assignment is complete, the Deployment Script resource is then deployed.
7. The Deployment Script runs the [`Invoke-AzResourceStateCheck.ps1`](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/scripts/Invoke-AzResourceStateCheck.ps1) PowerShell script which uses the User-Assigned Managed Identity to authenticate itself against ARM and poll the Virtual WAN Hub routingStatus` property to check it has the value of `Provisioned`.
   1. If it **doesn't**, it will wait the defined duration value provided to the parameter in the `orchestration.bicep` Bicep file and then check the property's value again. It will do this for a maximum number of iterations, again defined by the provided value to the parameter in the `orchestration.bicep` Bicep file. If it PowerShell script hits the maximum number of iterations and the property is still not of the desired value, the Deployment Script will throw an exception and exit, which will cause the remainder of the Bicep deployment to stop and fail.
   2. If it **does**, the Deployment Script will exit with a success code (`0`).
8. If the Deployment Script is successful then the Virtual Hub Connections are created between the spoke Virtual Networks and the Virtual WAN Hub. This uses an [explicit dependency](/azure/azure-resource-manager/bicep/resource-dependencies#explicit-dependency).
   1. The Virtual WAN Hub Connections are deployed sequentially rather than in parallel, as this is not supported on a single Virtual WAN Hub. This uses the Bicep [`batchSize` decorator](/azure/azure-resource-manager/bicep/loops#deploy-in-batches) by setting the batch size to 1.

### Summary

The key part of this architecture is the Deployment Script resource, deployed as a [Bicep module](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/modules/azResourceStateCheck.bicep), and the associated [PowerShell file](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/scripts/Invoke-AzResourceStateCheck.ps1) it uses to make calls to ARM to retrieve and check the value of a defined property on a specified Azure resource; in this example an Azure Virtual WAN Hub.

As this environment is all deployed from a single Bicep file ([`orchestration.bicep`](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/orchestration.bicep)), utilizing Bicep modules, we're able to declare a dependency, using `dependsOn`, on the Deployment Scripts Bicep module ([`azResourceStateCheck.bicep`](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/modules/azResourceStateCheck.bicep)) deployment on other Bicep module or resource deployments within the same Bicep file.

In this example, the Virtual WAN Hub Connections Bicep module ([`vwanVhcs.bicep`](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/modules/vwanVhcs.bicep)) deployment is dependent on the Deployment Scripts module. This is shown below in a reduced version of [`orchestration.bicep`](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/orchestration.bicep):

:::code language="bicep" source="~/azure-cae-bits/infra/samples/deployment-scripts-property-check/orchestration.bicep" range="57-68,98-134" highlight="110,125-127":::

This is because when a Virtual WAN Hub is created, it will report back to ARM that the deployment is successful, and that will signal to the ARM deployment engine that it can continue with other deployments that were dependent on the Virtual WAN Hub being available. However, the Virtual WAN Hub isn't actually "ready" yet as the Virtual WAN Hub Router is still being provisioned into the created hub, and this can take around 10-15 minutes to complete.

This can be seen in the below screenshot of a newly created Virtual WAN Hub:

[![Screenshot of a newly deployed Virtual WAN Hub with the Hub Status showing as Ready but the Routing Status showing as Provisioning](images/vwan-hub-routing-status-provisioning.png)](images/vwan-hub-routing-status-provisioning.png#lightbox)

With this now known, the importance of the Deployment Script, and the PowerShell script ([`Invoke-AzResourceStateCheck.ps1`](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/scripts/Invoke-AzResourceStateCheck.ps1)) it runs, can be understood. As if you were to try and create the Virtual WAN Hub Connections between the Virtual Networks and the Virtual WAN Hub before the Routing Status was "ready" (`Provisioned`), the Virtual WAN Hub Connections would fail and the overall Bicep/ARM deployment would fail. This would then require a redeployment of the Bicep/ARM deployment, by which time the Virtual WAN Hub Router might have now completed provisioning and be "ready" for the Virtual WAN Hub Connections to be created.

Therefore, utilizing the Deployment Script and the PowerShell script allows this situation to be avoided as it will poll the Virtual WAN Hub, via a `GET` API call, and check the specified property of `routingStatus` has the value of `Provisioned`, both of which are provided as parameters to the PowerShell script from the Deployment Script Bicep module. If the Virtual WAN Hub property, `routingStatus`, isn't `Provisioned` it will wait for a specified duration of time and then check again and it will repeat this for a specified number of iterations; again both of which are provided as parameters to the PowerShell script from the Deployment Script Bicep module.

>[!NOTE]
> The Deployment Script module creates a User-Assigned Managed Identity and grants it the Reader RBAC Role on the Resource Group and then uses this identity when running the PowerShell script to ensure it can make the required `GET` API calls against ARM to check the specified Azure Resource's property and value.

This can be seen in the below screenshot of the Deployment Script in action checking the Virtual WAN Hub's `routingStatus` property:

[![Screenshot of the Deployment Script polling the Virtual WAN Hub's routingStatus property](images/deployment-script-in-action.png)](images/deployment-script-in-action.png#lightbox)

Once the property of the Azure resource enters the desired state, before the number of maximum iterations is hit, the Deployment Script will complete and then this will signal to the ARM deployment engine that it can continue with other deployments that were dependent upon it.

[![Screenshot of the Deployment Script completing as the Virtual WAN Hub's routingStatus property is Provisioned](images/deployment-script-complete.png)](images/deployment-script-complete.png#lightbox)

If the Deployment Script does hit the maximum number of iterations whilst polling the Azure resource to check that the property has the desired value, it will [`throw` an exception](/powershell/scripting/learn/deep-dives/everything-about-exceptions) and this will signal to ARM that the Deployment Script resource has failed and therefore the ARM deployment engine will fail the deployment and not continue to deploy any of the remaining deployments or resources. This is required as this could indicate there's an issue with the Azure resource that has meant the property hasn't entered the desired state and this will require troubleshooting.

The [`Invoke-AzResourceStateCheck.ps1`](https://github.com/Azure/CAE-Bits/blob/main/infra/samples/deployment-scripts-property-check/scripts/Invoke-AzResourceStateCheck.ps1) can be seen below:

:::code language="powershell" source="~/azure-cae-bits/infra/samples/deployment-scripts-property-check/scripts/Invoke-AzResourceStateCheck.ps1" :::

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Jack Tracey](https://www.linkedin.com/in/jacktracey93) | Senior Cloud Solutions Architect

Other contributors:

- [Gary McMahon](https://www.linkedin.com/in/gmcmaho1/) | Senior Cloud Solutions Architect

## Next steps

- [Review the code sample in the `Azure/CAE-Bits` repo](https://github.com/Azure/CAE-Bits/tree/main/infra/samples/deployment-scripts-property-check)
- [Use deployment scripts in Bicep](/azure/azure-resource-manager/bicep/deployment-script-bicep)
- [Learn Module: Extend Bicep and ARM templates using deployment scripts](/training/modules/extend-resource-manager-template-deployment-scripts/)
- [Migrate to Azure Virtual WAN](/azure/virtual-wan/migrate-from-hub-spoke-topology)

## Related resources

- [Hub-spoke network topology with Azure Virtual WAN](../../networking/hub-spoke-vwan-architecture.yml)
