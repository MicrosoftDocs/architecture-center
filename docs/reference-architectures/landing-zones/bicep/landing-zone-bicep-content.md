This article provides a reference architecture for a modularized Bicep solution you can use to deploy and manage the core platform capabilities of the [Cloud Adoption Framework (CAF) Azure landing zone conceptual architecture](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture).

Bicep is just one technology you can use to build solutions to deploy Azure landing zones. Other choices include Azure Resource Manager (ARM) templates and Terraform. Regardless of your deployment technology choice, the resulting implementation should align to [Cloud Adoption Framework (CAF) Azure landing zone conceptual architecture](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture). The choice of deployment technology should not influence the resulting Azure landing zones deployment.

![GitHub logo](../../../_images/github.png) An implementation of this architecture is available on [GitHub: Azure Landing Zones (ALZ) - Bicep Implementation](https://github.com/Azure/ALZ-Bicep). You can use it as a starting point and configure it as per your needs.

> [!NOTE]
> There are [implementations](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/implementation-options) for several deployment technologies, including portal-based, ARM templates and Terraform modules.

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

This module deploys custom role definitions. The module should follow [CAF guidance on Azure role-based access control](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/considerations/roles).

Useful links:

- [Azure role-based access control - CAF documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/considerations/roles)
- [Custom role definitions deployed in reference implementation](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/customRoleDefinitions)

### Logging, Automation & Sentinel

Azure Monitor, Azure Automation and Microsoft Sentinel allow you monitor and manage your infrastructure and workloads. Azure Monitor is a solution that allows you to collect, analyze and act on telemetry from your environment.

Microsoft Sentinel is a cloud-native security information and event management (SIEM). It allows you to:

- Collect - Collect data across your entire infrastructure
- Detect - Detect threats that were previously undetected
- Respond - Respond to legitimate threats with built-in orchestration
- Investigate - Investigate threats with artificial intelligence

Azure Automation is a cloud-based automation system. It includes:

- Configuration management - Inventory and track changes for Linux and Windows virtual machines and manage desired state configuration
- Update management - Assess Windows and Linux system compliance and create scheduled deployments to meet compliance
- Process automation - Automate management tasks

This module deploys the tools necessary to monitor, manage and access threats to your environment. These tools should include Azure Monitor, Azure Automation and Microsoft Sentinel.

Useful links:

- [Workload management and monitoring - CAF documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads)
- [Module: Logging, Automation & Sentinel - Reference Implementation](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/logging)

### Networking

Network topology is a key consideration in Azure landing zone deployments. [CAF focuses on 2 core networking approaches](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology):

- Topologies based on Azure Virtual WAN
- Traditional topologies

These modules will allow you to deploy either core network approach.

Useful links:

- [Define an Azure network topology - CAF Documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology)
- [Network Topology Deployment - Reference Implementation](https://github.com/Azure/ALZ-Bicep/blob/main/docs/wiki/DeploymentFlow.md#network-topology-deployment)

### Role Assignments

Identity and access management (IAM) is the key security boundary in cloud computing. Azure RBAC allows you to perform role assignments of [built-in roles](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles) or custom role definitions to security principals.

This module deploys role assignments to Service Principals, Managed Identities or security groups across management groups and subscriptions. The module should follow [CAF guidance on Azure identity and access management](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access).

Useful links:

- [Azure identity and access management design area - CAF documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access)
- [Module: Role Assignments for Management Groups & Subscriptions - Reference Implementation](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/roleAssignments)

### Subscription Placement

Subscriptions that are assigned to a management group inherit:

- Azure Policies
- Azure Role Based Access Controls (RBAC) role assignments
- Cost controls

This module moves subscriptions under the appropriate management group.

Useful links:

- [Module: Subscription Placement](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/subscriptionPlacement)
- [Management groups - Cloud Adoption Framework (CAF) documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups)

### Built-In and Custom Policy Assignments


## Layers and staging

In addition to modules, the Bicep landing zone implementation is structured using a concept of layers. Layers are groups of Bicep modules that are intended to be deployed together. Those groups form logical stages of the implementation.

:::image type="content" border="true" source="images/high-level-deployment-flow.png" alt-text="Diagram showing the deployment layers." lightbox="images/high-level-deployment-flow.png":::

A benefit of this layered approach is the ability to add to your environment incrementally over time. For example, you can start with a small number of the layers. You can add the remaining layers at a subsequent stage when you’re ready.

## Customizing the Bicep implementation

The landing zone implementations provided as part of the Cloud Adoption Framework suit a wide variety of requirements and use cases. However, there are often scenarios where customization is required to meet specific business needs.

This Bicep landing zone implementation can be used as the basis of your customized deployment. It provides you a way to accelerate your implementation by removing the need to start from scratch because of a specific required change that rules a ready-made option out.

To customize a Bicep landing zone...