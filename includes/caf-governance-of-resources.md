<!-- TEMPLATE FILE - DO NOT ADD METADATA -->
<!-- markdownlint-disable MD002 MD041 -->
> [!NOTE]
>In the event of changes to your business requirements, Azure management groups allow you to easily reorganize your management hierarchy and subscription group assignments. However, keep in mind that policy and role assignments applied to a management group are inherited by all subscriptions underneath that group in the hierarchy. If you plan to reassign subscriptions between management groups, make sure that you are aware of any policy and role assignment changes that may result. See the [Azure management groups documentation](/azure/governance/management-groups) for more information.

### Governance of resources

A set of global policies and RBAC roles will provide a baseline level of governance enforcement. To meet the Cloud Governance team's policy requirements, implementation of the governance MVP requires completing the following tasks:

1. Identify the Azure Policy definitions needed to enforce business requirements. This can include using built-in definitions and creating new custom definitions.
2. Create a blueprint definition using these built-in and custom policy and the role assignments required by the governance MVP.
3. Apply policies and configuration globally by assigning the blueprint definition to all subscriptions.

#### Identify policy definitions

Azure provides several built-in policies and role definitions that you can assign to any management group, subscription, or resource group. Many common governance requirements can be handled using built-in definitions. However, it's likely that you will also need to create custom policy definitions to handle your specific requirements.

Custom policy definitions are saved to either a management group or a subscription and are inherited through the management group hierarchy. If a policy definition's save location is a management group, that policy definition is available to assign to any of that group's child management groups or subscriptions.

Since the policies required to support the governance MVP are meant to apply to all current subscriptions, the following business requirements will be implemented using a combination of built-in definitions and custom definitions created in the root management group:

1. Restrict the list of available role assignments to a set of built-in Azure roles authorized by your Cloud Governance team. This will require a [custom policy definition](https://github.com/Azure/azure-policy/tree/master/samples/Authorization/allowed-role-definitions). 
2. Require the use of the following tags on all resources: *Department/Billing Unit*, *Geography*, *Data Classification*, *Criticality*, *SLA*, *Environment*, *Application Archetype*, *Application*, and *Application Owner*. This can be handled using the "Require specified tag" built-in definition.
3. Require that the *Application* tag for resources should match the name of the relevant resource group. This can be handled using the "Require tag and its value" built-in definition.

For information on defining custom policies see the [Azure Policy documentation](/azure/governance/policy/tutorials/create-custom-policy-definition). For guidance and examples of custom policies, consult the [Azure Policy samples site](/azure/governance/policy/samples) and the associated [GitHub repository](https://github.com/Azure/azure-policy).

#### Assign Azure Policy and RBAC roles using Azure Blueprints

Azure policies can be assigned at the resource group, subscription, and management group level, and can be included in [Azure Blueprints](/azure/governance/blueprints/overview) definitions. Although the policy requirements defined in this governance MVP apply to all current subscriptions, it's very likely that future deployments will require exceptions or alternative policies. As a result, assigning policy using management groups, with all child subscriptions inheriting these assignments, may not be flexible enough to support these scenarios.

Azure Blueprints allow the consistent assignment of policy and roles, application of Resource Manager templates, and deployment of resource groups across multiple subscriptions. As with policy definitions, blueprint definitions are saved to management groups or subscriptions, and are available through inheritance to any children in the management group hierarchy.

The Cloud Governance team has decided that enforcement of required Azure Policy and RBAC assignments across subscriptions will be implemented through Azure Blueprints and associated artifacts:

1. In the root management group, create a blueprint definition named `governance-baseline`.
2. Add the following blueprint artifacts to the blueprint definition:
    1. Policy assignments for the custom Azure Policy definitions defined at the management group root.
    2. Resource group definitions for any groups required in subscriptions created or governed by the Governance MVP.
    3. Standard role assignments required in subscriptions created or governed by the Governance MVP.
3. Publish the blueprint definition.
4. Assign the `governance-baseline` blueprint definition to all subscriptions.

See the [Azure Blueprints documentation](/azure/governance/blueprints/overview) for more information on creating and using blueprint definitions.

### Secure hybrid VNet

Specific subscriptions often require some level of access to on-premises resources. This is common in migration scenarios or dev scenarios where dependent resources reside in the on-premises datacenter.

Until trust in the cloud environment is fully established it's important to tightly control and monitor any allowed communication between the on-premises environment and cloud workloads, and that the on-premises network is secured against potential unauthorized access from cloud-based resources. To support these scenarios, the governance MVP adds the following best practices:

1. Establish a cloud secure hybrid VNet.
    1. The [VPN reference architecture](/azure/architecture/reference-architectures/hybrid-networking/vpn) establishes a pattern and deployment model for creating a VPN Gateway in Azure.
    2. Validate that on-premises security and traffic management mechanisms treat connected cloud networks as untrusted. Resources and services hosted in the cloud should only have access to authorized on-premises services.
    3. Validate that the local edge device in the on-premises datacenter is compatible with [Azure VPN Gateway requirements](/azure/vpn-gateway/vpn-gateway-about-vpn-devices) and is configured to access the public internet.
1. In the root management group, create a second blueprint definition named `secure-hybrid-vnet`.
    1. Add the Resource Manager template for the VPN Gateway as an artifact to the blueprint definition.
    2. Add the Resource Manager template for the virtual network as an artifact to the blueprint definition.
    3. Publish the blueprint definition.
1. Assign the `secure-hybrid-vnet` blueprint definition to any subscriptions requiring on-premises connectivity. This definition should be assigned in addition to the `governance-baseline` blueprint definition.

One of the biggest concerns raised by IT security and traditional governance teams is the risk that early stage cloud adoption will compromise existing assets. The above approach allows cloud adoption teams to build and migrate hybrid solutions, with reduced risk to on-premises assets. As trust in the cloud environment increases, later evolutions may remove this temporary solution.

> [!NOTE]
> The above is a starting point to quickly create a baseline governance MVP. This is only the beginning of the governance journey. Further evolution will be needed as the company continues to adopt the cloud and takes on more risk in the following areas:
>
> - Mission-critical workloads
> - Protected data
> - Cost management
> - Multicloud scenarios
>
> Moreover, the specific details of this MVP are based on the example journey of a fictional company, described in the articles that follow. We highly recommend becoming familiar with the other articles in this series before implementing this best practice.
