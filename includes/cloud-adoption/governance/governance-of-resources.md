### Governance of resources

Enforcing governance across subscriptions will come from Azure Blueprints and the associated assets within the blueprint.

1. Create an Azure Blueprint named "Governance MVP".
    1. Enforce the use of standard Azure roles.
    2. Enforce that users can only authenticate against existing an RBAC implementation.
    3. Apply this blueprint to all subscriptions within the management group.
2. Create an Azure Policy to apply or enforce the following:
    1. Resource tagging should require values for Business Function, Data Classification, Criticality, SLA, Environment, and  Application.
    2. The value of the Application tag should match the name of the resource group.
    3. Validate role assignments for each resource group and resource.
3. Publish and apply the "Governance MVP" Azure Blueprint to each management group.

These patterns enable resources to be discovered and tracked, and enforce basic role management.

### Demilitarized Zone (DMZ)

It’s common for specific subscriptions to require some level of access to on-premises resources. This may be the case for migration scenarios or development scenarios, when some dependent resources are still in the on-premises datacenter. In this case, the governance MVP adds the following best practices:

1. Establish a Cloud DMZ.
    1. The [Cloud DMZ reference architecture](/azure/architecture/reference-architectures/dmz/secure-vnet-hybrid) establishes a pattern and deployment model for creating a VPN Gateway in Azure.
    2. Validate that proper DMZ connectivity and security requirements are in place for a local edge device in the on-premises datacenter.
    3. Validate that the local edge device is compatible with Azure VPN Gateway requirements.
    4. Once connection to the on-premise VPN has been verified, capture the Resource Manager template created by that reference architecture.
2. Create a second blueprint named "DMZ".
    1. Add the Resource Manager template for the VPN Gateway to the blueprint.
3. Apply the DMZ blueprint to any subscriptions requiring on-premises connectivity. This blueprint should be applied in addition to the governance MVP blueprint.

One of the biggest concerns raised by IT security and traditional governance teams, is the risk of early stage cloud adoption compromising existing assets. The above approach allows cloud adoption teams to build and migrate hybrid solutions, with reduced risk to on-premises assets. In later evolution, this temporary solution would be removed.

> [!NOTE]
> The above is a starting point to quickly create a baseline governance MVP. This is only the beginning of the governance journey. Further evolution will be needed as the company continues to adopt the cloud and takes on more risk in the following areas:
>
> - Mission-critical workloads
> - Protected data
> - Cost management
> - Multi-cloud scenarios
>
>Moreover, the specific details of this MVP are based on the example journey of a fictitious company, described in the articles that follow. We highly recommend becoming familiar with the other articles in this series before implementing this best practice.
