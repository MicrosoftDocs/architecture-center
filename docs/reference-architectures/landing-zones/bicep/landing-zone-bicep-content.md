This article provides a reference architecture for a modularized Bicep solution you can use to deploy and manage the core platform capabilities of the Cloud Adoption Framework (CAF) Azure Landing Zones conceptual architecture.

![GitHub logo](../../../_images/github.png) An implementation of this architecture is available on [GitHub: Azure Landing Zones (ALZ) - Bicep Implementation](https://github.com/Azure/ALZ-Bicep). You can use it as a starting point and configure it as per your needs.

## Architecture

:::image type="content" border="true" source="images/bicep-architecture.png" alt-text="Diagram showing the nine bicep modules for deploying Azure landing zones." lightbox="images/bicep-architecture.png":::

The architecture takes advantage of the modular nature of Azure Bicep and is composed of nine modules. Each module encapsulates a core capability of the Cloud Adoption Framework Azure Landing Zones conceptual architecture. The modules can be deployed individually, but there are dependencies.

The architecture proposes the inclusion of orchestrator modules when limitations of Bicep & the Azure Resource manager are addressed. The orchestrator modules could be used to automate the deployment of the modules and to encapsulate differing deployment topologies.

## Modules

A core concept in Bicep is the use of modules. Modules enable you to organize deployments into logical groupings. With modules, you improve the readability of your Bicep files by encapsulating complex details of your deployment. You can also easily reuse modules for different deployments.

This ability to re-use offers a real benefit when defining and deploying landing zones. It enables repeatable, consistent environments in code while reducing the effort required to deploy at scale.

As part of the Bicep landing zone implementation, the following modules have been created and can be found in the GitHub repository.

### Management Groups

Management groups are the highest level resources in an Azure tenant. Management groups allow you to more easily manage your resources. You can apply policy at the management group level and lower level resources will inherit that policy. Specifically, you can apply the following items at the management group level that will be inherited by subscriptions under the management group:

- Azure Policies
- Azure Role Based Access Controls (RBAC) role assignments
- Cost controls

This module deploys the management group hierarchy. The module should follow [CAF guidance on management groups](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups). The management group hierarchy should:

- Be relatively flat, ideally 3-4 levels. A flat hierarchy is simple and easy to maintain.
- Be structured so workloads running under each management group will have similar security and compliance requirements.
- Include a top-level sandbox management group that allows users to experiment with resources not yet allowed in production environments.
- Include a platform management group that supports common policy and role assignments for platform-level resources.
- Include a default landing zone to be used for new subscriptions.
- Not follow the antipattern of management groups for production, testing and development environments.

Useful links:

- [Management groups - Cloud Adoption Framework (CAF) documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups)
- [Module:  Management Groups - Reference Implementation](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/managementGroups)

### Custom Policy Definitions

DeployIfNotExists (DINE) or Modify policies help ensure the subscriptions and resources that make up landing zones are compliant. The policies also ease the burden of management of landing zones.

This module deploys custom policy definitions to management groups. Not all customers are able to use DINE or Modify policies. If that is the case for you, [CAF guidance on custom policies](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups) provides guidance.  

Useful links:

- [Adopt policy-driven guardrails - CAF documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/dine-guidance)
- [Module: Custom policy definitions - Reference Implementation](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/definitions)
- [Custom policy definitions deployed in reference implementations](https://github.com/Azure/Enterprise-Scale/blob/main/docs/ESLZ-Policies.md)

### Custom Role Definitions

Role-based access control (RBAC) simplifies the management of user rights within a system. Instead of managing the rights of individuals, you determine the rights required for different roles in your system. Azure RBAC has several [built-in roles](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles). Custom role definitions allow you to create custom roles for your environment.  

This module deploys custom role definitions. The module should follow [CAF guidance on Azure role-based access control](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/considerations/roles). The guidance includes:

- Follow a least-privileged access model. Limit the permissions to what is required to perform work.
- Avoid resource-specific permissions. They become difficult to manage as your system grows.
- Consider following a common pattern for dividing IT responsibilities that includes high-level roles such as:
  - SecOps - Security oversight
  - NetOps - Manages network
  - SysOps - Manages compute and storage infrastructure
  - Dev - Manages build and deploy operations

Useful links:

- [Azure role-based access control - CAF documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/considerations/roles)
- [Custom role definitions deployed in reference implementation](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/customRoleDefinitions)

### Logging & Sentinel

### Hub Networking

### Role Assignments

### Subscription Placement

### Built-In and Custom Policy Assignments

### Spoke Networking

## Layers and staging

In addition to modules, the Bicep landing zone implementation is structured using a concept of layers. Layers are groups of Bicep modules that are intended to be deployed together. Those groups form logical stages of the implementation.

:::image type="content" border="true" source="images/high-level-deployment-flow.png" alt-text="Diagram showing the deployment layers." lightbox="images/high-level-deployment-flow.png":::

A benefit of this layered approach is the ability to add to your environment incrementally over time. For example, you can start with a small number of the layers. You can add the remaining layers at a subsequent stage when you’re ready.

## Customizing the Bicep implementation

The landing zone implementations provided as part of the Cloud Adoption Framework suit a wide variety of requirements and use cases. However, there are often scenarios where customization is required to meet specific business needs.

This Bicep landing zone implementation can be used as the basis of your customized deployment. It provides you a way to accelerate your implementation by removing the need to start from scratch because of a specific required change that rules a ready-made option out.

To customize a Bicep landing zone...