---
title: Azure landing zones - Terraform module design considerations
description: Design considerations for the Azure landing zones Terraform module.
author: robbagby
ms.author: robbag
ms.date: 07/18/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
categories:
  - management-and-governance
  - devops
  - networking
  - security
ms.custom:
  - devx-track-terraform
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

# Azure landing zones - Terraform module design considerations

This article discusses important areas to consider when using the [Azure landing zones Terraform module](https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest). The module provides an opinionated approach to deploy and operate an Azure platform based on the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture) as detailed in the Cloud Adoption Framework (CAF).

Terraform is an open-source Infrastructure as Code (IaC) tool, created by HashiCorp, that uses declarative syntax to deploy infrastructure resources. It is extensible, has cross-platform support and enables immutable infrastructure through state tracking. 

<br/>

> [!VIDEO https://www.youtube.com/embed/PqfIeth62Yg]

> [!IMPORTANT]
> The module is available on the [Terraform Registry: Azure landing zones Terraform module](https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest). You can use it as a starting point and configure it as per your needs.

> [!NOTE]
> There are [implementations](/azure/cloud-adoption-framework/ready/landing-zone/implementation-options) for several deployment technologies, including portal-based, ARM templates and Terraform modules. The choice of deployment technology should not influence the resulting Azure landing zones deployment.

## Design

:::image type="content" border="true" source="images/alz-tf-module-overview.png" alt-text="Diagram showing the Azure landing zones conceptual architecture." lightbox="images/alz-tf-module-overview.png":::

The architecture takes advantage of the configurable nature of Terraform and is composed of a primary orchestration module. This module encapsulates multiple capabilities of the Azure landing zones conceptual architecture. You can deploy each capability individually or in part. For example, you can deploy just a hub network, or just the Azure DDoS Protection, or just the DNS resources. When doing so, you need to take into account that the capabilities have dependencies.

The architecture utilizes an orchestrator approach to simplify the deployment experience. You might prefer to implement each capability using one or more dedicated module instances where each is dedicated to a specific part of the architecture. This is all possible with the correct configuration.

## Modules

A core concept in Terraform is the use of modules. Modules enable you to organize deployments into logical groupings. With modules, you improve the readability of your Terraform files by encapsulating complex details of your deployment. You can also easily reuse modules for different deployments.

The ability to re-use modules offers a real benefit when defining and deploying landing zones. It enables repeatable, consistent environments in code while reducing the effort required to deploy at scale.

The Terraform implementation of Azure landing zones is delivered using a single module that acts as an orchestration layer. The orchestration layer allows you to select which resources are deployed and managed using the module. The module can be used multiple times in the same environment to deploy resources independently from each other. This can be useful in organizations where different teams are responsible for the different capabilities, or collections of sub-resources.

## Layers and staging

The implementation focuses on the central resource hierarchy of the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture). The design is centered around the following capabilities:

* Core resources
* Management resources
* Connectivity resources
* Identity resources

The module groups resources into these capabilities as they are intended to be deployed together. These groups form logical stages of the implementation.

You control the deployment of each of these capabilities by using feature flags. A benefit of this approach is the ability to add to your environment incrementally over time. For example, you can start with a small number of capabilities. You can add the remaining capabilities at a later stage when you’re ready.

### Core resources

The [core resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Core-Resources) capability of the module aligns to the [resource organization](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org) design area of the Cloud Adoption Framework. It deploys the foundational resources of the [conceptual architecture for Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture).

:::image type="content" border="true" source="images/terraform-caf-enterprise-scale-core.png" alt-text="Diagram showing the core Azure landing zones architecture deployed by the Terraform module." lightbox="images/terraform-caf-enterprise-scale-core.png":::

#### Archetypes

An important concept within the core resources capability is the inclusion of archetypes.

Archetypes provide a reusable, code-based approach to defining which policy definitions, policy set definitions, policy assignments, role definitions and role assignments must be applied at a given scope. In the Terraform implementation, these decisions are encapsulated as [Archetype Definitions](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions).

To create a landing zone, management groups are associated with an archetype definition. In the below example for a corp landing zone, the archetype_config has a pointer to the "es_corp" archetype definition. That definition contains all the policy and role configurations which will be added to this management group.

```terraform
  es_corp_landing_zones = {
    "contoso-corp" = {
      display_name               = "Corp"
      parent_management_group_id = "contoso-landing-zones"
      subscription_ids           = []
      archetype_config           = {
        archetype_id ="es_corp"
        parameters   = {}
        access_control = {}
    }
  }
```

When the built-in archetypes don't align to your requirements, the module provides options to either [create new archetypes](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions#working-with-archetype-definitions-and-the-custom-library) or [make changes to existing](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Expand-Built-in-Archetype-Definitions).

### Management resources

The [management resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Management-Resources) capability of the module aligns to the [management](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management) design area of the Cloud Adoption Framework. This capability provides the option to deploy management and monitoring resources to the management platform landing zone.

### Connectivity resources

The [connectivity resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Connectivity-Resources) capability of the module provides the option to deploy the [network topology and connectivity](/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity) of the [conceptual architecture for Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture).

### Identity resources

The [identity resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Identity-Resources) capability of the module aligns to the [Azure identity and access management design area](/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access) of the Cloud Adoption Framework. This capability provides the option to configure policies on the Identity platform landing zone.

> [!NOTE]
> No resources are deployed with this capability. When the ```deploy_identity_resources``` variable is set to true, Azure Policy assignments are configured that protect resources in the identity platform landing zone subscription.

## Module descriptions

This section provides a high-level overview of the resources deployed by this module.

| Layer | Resource Type(s) | Description | Useful Links |
|---|---|---|---|
| Core | Management Groups | Management groups are the highest level resources in an Azure tenant. Management groups allow you to more easily manage your resources. You can apply policy at the management group level and lower level resources will inherit that policy. Specifically, you can apply the following items at the management group level that will be inherited by subscriptions under the management group:<br /><ul><li>Azure Policies</li><li>Azure Role Based Access Controls (RBAC) role assignments</li><li>Cost controls</li></ul> | <ul><li>[Management groups - Cloud Adoption Framework (CAF) documentation](/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups)</li></ul> |
| Core | Policy definitions, policy assignments, and policy set definitions | DeployIfNotExists (DINE) or Modify policies help ensure the subscriptions and resources that make up landing zones are compliant. Policies are assigned to management groups through policy assignments. The policies  ease the burden of management of landing zones. Policy set definitions group sets of policies together.<br /><br />Not all customers are able to use DINE or Modify policies. If that is the case for you, [CAF guidance on custom policies](/azure/cloud-adoption-framework/ready/enterprise-scale/dine-guidance) provides guidance. | <ul><li>[Adopt policy-driven guardrails - CAF documentation](/azure/cloud-adoption-framework/ready/enterprise-scale/dine-guidance)</li><li>[Custom policy definitions deployed in reference implementations](https://github.com/Azure/Enterprise-Scale/blob/main/docs/ESLZ-Policies.md)</li></ul> |
| Core | Role definitions and role assignments | Role-based access control (RBAC) simplifies the management of user rights within a system. Instead of managing the rights of individuals, you determine the rights required for different roles in your system. Azure RBAC has several [built-in roles](/azure/role-based-access-control/built-in-roles). Custom role definitions allow you to create custom roles for your environment.<br/><br/> Identity and access management (IAM) is the key security boundary in cloud computing. Azure RBAC allows you to perform role assignments of built-in roles or custom role definitions to Service Principals, Managed Identities or security groups across management groups and subscriptions. | <ul><li>[Azure role-based access control - CAF documentation](/azure/cloud-adoption-framework/ready/considerations/roles)</li><li>[Azure identity and access management design area - CAF documentation](/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access)</li><li>[Custom policy definitions deployed in reference implementations](https://github.com/Azure/Enterprise-Scale/blob/main/docs/ESLZ-Policies.md)</li></ul> |
| Management | Azure Monitor, Azure Automation, and Microsoft Sentinel | Azure Monitor, Azure Automation and Microsoft Sentinel allow you to monitor and manage your infrastructure and workloads. Azure Monitor is a solution that allows you to collect, analyze and act on telemetry from your environment.<br/><br/>Microsoft Sentinel is a cloud-native security information and event management (SIEM). It allows you to:<br/><ul><li>Collect - Collect data across your entire infrastructure</li><li>Detect - Detect threats that were previously undetected</li><li>Respond - Respond to legitimate threats with built-in orchestration</li><li>Investigate - Investigate threats with artificial intelligence</li></ul><br/>Azure Automation is a cloud-based automation system. It includes:<br/><ul><li>Configuration management - Inventory and track changes for Linux and Windows virtual machines and manage desired state configuration</li><li>Update management - Assess Windows and Linux system compliance and create scheduled deployments to meet compliance</li><li>Process automation - Automate management tasks</li></ul> | <ul><li>[Workload management and monitoring - CAF documentation](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads)</li></ul> |
| Connectivity | [Core networking resource types listed here](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Connectivity-Resources#resource-types) | Network topology is a key consideration in Azure landing zone deployments. [CAF focuses on two core networking approaches](/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology):<br/><ul><li>Topologies based on Azure Virtual WAN</li><li>Traditional topologies</li></ul> | <ul><li>[Define an Azure network topology - CAF Documentation](/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology)</li></ul> |
| Connectivity | Azure DDoS Protection | Azure landing zone guidance recommends enabling Azure DDoS Network Protection. This service offers turnkey protection against DDoS attacks. | <ul><li>[Azure DDoS Network Protection](/azure/ddos-protection/ddos-protection-overview)</li></ul> |
| Connectivity | DNS Zones, Private DNS Zones, and Private DNS Zone Virtual Network Link | Private DNS zones can be deployed to support the use of private endpoints. A private endpoint is a NIC that is assigned a private IP address from your virtual network. You can use the private IP address to securely communicate to services that supports Azure Private Link. Private DNS zones can be configured to resolve the fully qualified domain name (FQDN) of the service to the private endpoint private IP address. | <ul><li>[Azure Private Endpoint DNS configuration](/azure/private-link/private-endpoint-dns)</li></ul> |

## Using the Terraform module

> [!VIDEO https://www.youtube.com/embed/vFO_cyolUW0]

### Deploying core resources

By default, the module will deploy the following hierarchy, which is the core set of landing zone management groups:

* Root
  * Platform
    * Identity
    * Management
    * Connectivity
  * Landing zones
  * Decommissioned
  * Sandbox

The SAP, Corp and Online landing zone management groups don't apply to everyone so they aren't deployed by default. The following are ways to deploy these:

1. For demo purposes, you can set the ```deploy_demo_landing_zones``` variable to true that will deploy SAP, Corp and Online landing zones
2. For production purposes, you can turn on the management groups you want by setting the following variables to true:
    * ```deploy_corp_landing_zones```
    * ```deploy_online_landing_zones```
    * ```deploy_sap_landing_zones```
3. You can deploy your own custom landing zone management groups by creating a [custom landing zone](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-custom_landing_zones) definition

### Deploying management resources

To deploy the management resources, the ```deploy_management_resources``` variable must be set to true and the ```subscription_id_management``` variable must be set to the ID of the management subscription where the resources are to be deployed.

```bash
deploy_management_resources = true
subscription_id_management = <management subscription id>
```

### Deploying connectivity resources

[Deploy Connectivity Resources](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Connectivity-Resources) provides guidance on how to deploy these topologies.

### Deploying identity resources

To deploy the identity capability, the ```deploy_identity_resources``` variable must be set to true and the ```subscription_id_identity``` variable must be set to the ID of the identity subscription where the policies are to be configured.

```bash
deploy_identity_resources = true
subscription_id_identity = <identity subscription id>
```

## Customizing the Terraform implementation

> [!VIDEO https://www.youtube.com/embed/ct2KHaA7ekI]

The [Azure landing zone implementations](/azure/cloud-adoption-framework/ready/landing-zone/implementation-options) provided as part of the Cloud Adoption Framework suit a wide variety of requirements and use cases. However, there are often scenarios where customization is required to meet specific business needs.

> [!TIP]
> See [Tailor the Azure landing zone architecture to meet requirements](/azure/cloud-adoption-framework/ready/landing-zone/tailoring-alz) for further information.

The [Azure landing zones Terraform module](https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest) can be used as the basis of your customized deployment. It provides you a way to accelerate your implementation by removing the need to start from scratch because of a specific required change that rules a ready-made option out.

![GitHub logo](../../_images/github.png) Information on customizing the modules is available in the GitHub repo wiki [GitHub: Azure landing zones Terraform module - Wiki](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki). You can use it as a starting point and configure it as per your needs.
