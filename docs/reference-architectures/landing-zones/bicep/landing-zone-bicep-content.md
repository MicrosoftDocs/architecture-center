This article provides a reference architecture for a modularized Bicep solution you can use to deploy and manage the core platform capabilities of the Cloud Adoption Framework (CAF) Azure Landing Zones conceptual architecture.

![GitHub logo](../../../_images/github.png) An implementation of this architecture is available on [GitHub: Azure Landing Zones (ALZ) - Bicep Implementation](https://github.com/Azure/ALZ-Bicep). You can use it as a starting point and configure it as per your needs.

## Architecture

:::image type="content" border="true" source="images/bicep-architecture.png" alt-text="Diagram showing the nine bicep modules for deploying Azure landing zones." lightbox="images/bicep-architecture.png":::

The architecture takes advantage of the modular nature of Azure Bicep and is composed of nine modules. Each module encapsulates a core capability of the Cloud Adoption Framework Azure Landing Zones conceptual architecture. The modules can be deployed individually, but there are dependencies.

The architecture proposes the inclusion of orchestrator modules when limitations of Bicep & the Azure Resource manager are addressed. The orchestrator modules could be used to automate the deployment of the modules and to encapsulate differing deployment topologies.

## Modules

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

This module deploys custom policy definitions to management groups. 

Useful links:

- [Adopt policy-driven guardrails - CAF documentation](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/dine-guidance)
- [Module: Custom policy definitions - Reference Implementation](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/definitions)
- [Custom policy definitions deployed in reference implementations](https://github.com/Azure/Enterprise-Scale/blob/main/docs/ESLZ-Policies.md)

### Custom Role Definitions

### Logging & Sentinel

### Hub Networking

### Role Assignments

### Subscription Placement

### Built-In and Custom Policy Assignments

### Spoke Networking
