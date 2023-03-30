---
title: Azure landing zones - Bicep modules design considerations
description: Design considerations for the Azure landing zones Bicep modules.
author: robbagby
categories:
  - management-and-governance
  - devops
  - networking
  - security
ms.custom:
  - devx-track-bicep
ms.author: robbag
ms.date: 06/14/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
azureCategories:
  - devops
  - hybrid
  - management-and-governance
  - networking
  - security
products:
  - azure
  - azure-resource-manager
  - azure-policy
  - azure-rbac
  - azure-virtual-network
---

# Azure landing zones - Bicep modules design considerations

This article discusses the design considerations of the modularized [Azure Landing Zones (ALZ) - Bicep](https://github.com/Azure/ALZ-Bicep) solution you can use to deploy and manage the core platform capabilities of the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture) as detailed in the Cloud Adoption Framework (CAF).

[Bicep](/azure/azure-resource-manager/bicep/overview?tabs=bicep) is a domain-specific language (DSL) that uses declarative syntax to deploy Azure resources. It has concise syntax, reliable type safety, and support for code reuse.

![GitHub logo](../../_images/github.png) An implementation of this architecture is available on [GitHub: Azure Landing Zones (ALZ) - Bicep Implementation](https://github.com/Azure/ALZ-Bicep). You can use it as a starting point and configure it as per your needs.

> [!VIDEO https://www.youtube.com/embed/-pZNrH1GOxs]

> [!NOTE]
> There are [implementations](/azure/cloud-adoption-framework/ready/landing-zone/implementation-options) for several deployment technologies, including portal-based, ARM templates and Terraform modules. The choice of deployment technology should not influence the resulting Azure landing zones deployment.

## Design

:::image type="content" border="true" source="images/bicep-architecture.png" alt-text="Diagram showing the bicep modules for deploying Azure landing zones." lightbox="images/bicep-architecture-highres.png":::

The architecture takes advantage of the modular nature of Azure Bicep and is composed of number of modules. Each module encapsulates a core capability of the Azure Landing Zones conceptual architecture. The modules can be deployed individually, but there are dependencies to be aware of.

The architecture proposes the inclusion of orchestrator modules to simplify the deployment experience. The orchestrator modules could be used to automate the deployment of the modules and to encapsulate differing deployment topologies.

## Modules

A core concept in Bicep is the use of [modules](/azure/azure-resource-manager/bicep/modules). Modules enable you to organize deployments into logical groupings. With modules, you improve the readability of your Bicep files by encapsulating complex details of your deployment. You can also easily reuse modules for different deployments.

The ability to re-use modules offers a real benefit when defining and deploying landing zones. It enables repeatable, consistent environments in code while reducing the effort required to deploy at scale.

## Layers and staging

> [!VIDEO https://www.youtube.com/embed/FNT0ZtUxYKQ]

In addition to modules, the Bicep landing zone architecture is structured using a concept of layers. Layers are groups of Bicep modules that are intended to be deployed together. Those groups form logical stages of the implementation.

:::image type="content" border="true" source="images/high-level-deployment-flow.png" alt-text="Diagram showing the deployment layers." lightbox="images/high-level-deployment-flow.png":::

A benefit of this layered approach is the ability to add to your environment incrementally over time. For example, you can start with a small number of the layers. You can add the remaining layers at a subsequent stage when you’re ready.

## Module descriptions

This section provides a high-level overview of the core modules in this architecture.

|Layer| Module | Description | Useful Links |
|---|---|---|
|Core | Management Groups | Management groups are the highest level resources in an Azure tenant. Management groups allow you to more easily manage your resources. You can apply policy at the management group level and lower level resources will inherit that policy. Specifically, you can apply the following items at the management group level that will be inherited by subscriptions under the management group:<br /><ul><li>Azure Policies</li><li>Azure Role Based Access Controls (RBAC) role assignments</li><li>Cost controls</li></ul><br />This module deploys the management group hierarchy as defined in the Azure landing zone conceptual architecture. | <ul><li>[Management groups - Cloud Adoption Framework (CAF) documentation](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups)</li><li>[Module:  Management Groups - Reference Implementation](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/managementGroups)</li></ul> |
|Core | Custom Policy Definitions | DeployIfNotExists (DINE) or Modify policies help ensure the subscriptions and resources that make up landing zones are compliant. The policies also ease the burden of management of landing zones.<br /><br />This module deploys custom policy definitions to management groups. Not all customers are able to use DINE or Modify policies. If that is the case for you, [CAF guidance on custom policies](/azure/cloud-adoption-framework/ready/enterprise-scale/dine-guidance) provides guidance. | <ul><li>[Adopt policy-driven guardrails - CAF documentation](/azure/cloud-adoption-framework/ready/enterprise-scale/dine-guidance)</li><li>[Module: Custom policy definitions - Reference Implementation](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/definitions)</li><li>[Custom policy definitions deployed in reference implementations](https://github.com/Azure/Enterprise-Scale/blob/main/docs/ESLZ-Policies.md)</li></ul> |
|Core | Custom Role Definitions | Role-based access control (RBAC) simplifies the management of user rights within a system. Instead of managing the rights of individuals, you determine the rights required for different roles in your system. Azure RBAC has several [built-in roles](/azure/role-based-access-control/built-in-roles). Custom role definitions allow you to create custom roles for your environment.<br /><br />This module deploys custom role definitions. The module should follow [CAF guidance on Azure role-based access control](/azure/cloud-adoption-framework/ready/considerations/roles). | <ul><li>[Azure role-based access control - CAF documentation](/azure/cloud-adoption-framework/ready/considerations/roles)</li><li>[Custom role definitions deployed in reference implementation](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/customRoleDefinitions)</li></ul> |
|Management | Logging, Automation & Sentinel | Azure Monitor, Azure Automation and Microsoft Sentinel allow you monitor and manage your infrastructure and workloads. Azure Monitor is a solution that allows you to collect, analyze and act on telemetry from your environment.<br /><br />Microsoft Sentinel is a cloud-native security information and event management (SIEM). It allows you to:<br /><ul><li>Collect - Collect data across your entire infrastructure</li><li>Detect - Detect threats that were previously undetected</li><li>Respond - Respond to legitimate threats with built-in orchestration</li><li>Investigate - Investigate threats with artificial intelligence</li></ul><br />Azure Automation is a cloud-based automation system. It includes:<br /><ul><li>Configuration management - Inventory and track changes for Linux and Windows virtual machines and manage desired state configuration</li><li>Update management - Assess Windows and Linux system compliance and create scheduled deployments to meet compliance</li><li>Process automation - Automate management tasks</li></ul><br />This module deploys the tools necessary to monitor, manage and access threats to your environment. These tools should include Azure Monitor, Azure Automation and Microsoft Sentinel. | <ul><li>[Workload management and monitoring - CAF documentation](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads)</li><li>[Module: Logging, Automation & Sentinel - Reference Implementation](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/logging)</li></ul> |
|Connectivity | Networking | Network topology is a key consideration in Azure landing zone deployments. [CAF focuses on 2 core networking approaches](/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology):<br /><ul><li>Topologies based on Azure Virtual WAN</li><li>Traditional topologies</li></ul><br />These modules deploy the network topology that you choose. | <ul><li>[Define an Azure network topology - CAF Documentation](/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology)</li><li>[Modules: Network Topology Deployment - Reference Implementation](https://github.com/Azure/ALZ-Bicep/blob/main/docs/wiki/DeploymentFlow.md#network-topology-deployment)</li></ul> |
|Identity | Role Assignments | Identity and access management (IAM) is the key security boundary in cloud computing. Azure RBAC allows you to perform role assignments of [built-in roles](/azure/role-based-access-control/built-in-roles) or custom role definitions to security principals.<br /><br />This module deploys role assignments to Service Principals, Managed Identities or security groups across management groups and subscriptions. The module should follow [CAF guidance on Azure identity and access management](/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access). | <ul><li>[Azure identity and access management design area - CAF documentation](/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access)</li><li>[Module: Role Assignments for Management Groups & Subscriptions - Reference Implementation](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/roleAssignments)</li></ul> |
|Core | Subscription Placement | Subscriptions that are assigned to a management group inherit:<br /><ul><li>Azure Policies</li><li>Azure Role Based Access Controls (RBAC) role assignments</li><li>Cost controls</li></ul><br />This module moves subscriptions under the appropriate management group. | <ul><li>[Management groups - Cloud Adoption Framework (CAF) documentation](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups)</li><li>[Module: Subscription Placement](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/subscriptionPlacement)</li></ul> |
|Core | Built-In and Custom Policy Assignments | This module deploys the default Azure landing zone Azure Policy assignments to management groups. It also creates role assignments for system-assigned Managed Identities created by policies. | <ul><li>[Adopt policy-driven guardrails - CAF documentation](/azure/cloud-adoption-framework/ready/enterprise-scale/dine-guidance)</li><li>[Module: ALZ Default Policy Assignments](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/modules/policy/assignments/alzDefaults)</li></ul> |
|Management | Orchestrator Modules | Orchestrator modules can greatly improve the deployment experience. These modules encapsulate the deployment of multiple modules in a single module. This hides the complexity from the end user. | <ul><li>[Module: Orchestration - hubPeeredSpoke - Spoke network, including peering to Hub (Hub & Spoke or Virtual WAN)](https://github.com/Azure/ALZ-Bicep/tree/main/infra-as-code/bicep/orchestration/hubPeeredSpoke)</li></ul> |

## Customizing the Bicep implementation

The [Azure landing zone implementations](/azure/cloud-adoption-framework/ready/landing-zone/implementation-options) provided as part of the Cloud Adoption Framework suit a wide variety of requirements and use cases. However, there are often scenarios where customization is required to meet specific business needs.  

> [!TIP]
> See [Tailor the Azure landing zone architecture to meet requirements](/azure/cloud-adoption-framework/ready/landing-zone/tailoring-alz) for further information.

Once the platform landing zone is implemented the next step is to deploy [Application landing zones](/azure/cloud-adoption-framework/ready/landing-zone/#platform-vs-application-landing-zones) which enable application teams under the `landing zones` management group with the guardrails that Central IT or PlatformOps administrators require. The `corp` management group is for corporate connected applications, while the `online` management group is for applications that are primarily publicly facing, but may still connect to corporate applications via hub networks in some scenarios. 

> [!Video https://www.youtube.com/embed/cZ7IN3zGbyM]

The [Bicep Azure landing zone implementation](https://github.com/Azure/ALZ-Bicep) can be used as the basis of your customized deployment. It provides you a way to accelerate your implementation by removing the need to start from scratch because of a specific required change that rules a ready-made option out.

![GitHub logo](../../_images/github.png) Information on customizing the modules is available in the GitHub repo wiki [GitHub: Azure Landing Zones (ALZ) Bicep - Wiki- Consumer Guide](https://github.com/Azure/ALZ-Bicep/wiki/ConsumerGuide). You can use it as a starting point and configure it as per your needs.
