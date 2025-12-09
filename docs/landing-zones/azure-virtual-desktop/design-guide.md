---
title: Azure Virtual Desktop Landing Zone Design Guide
description: Learn about the design areas in the Azure landing zone architecture for Azure Virtual Desktop, including resource organization and networking.
author: roarrioj
ms.author: roarrioj
ms.date: 06/20/2025
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Azure Virtual Desktop landing zone design guide

This article provides an overview of the design areas in the [Azure landing zone architecture for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone). It targets architects and technical decision-makers. Use this guidance to quickly gain an understanding of the Virtual Desktop landing zone reference implementation.

## Landing zone concepts

An [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone/) is an environment that follows key design principles across eight design areas. These design principles accommodate all application portfolios and enable application migration, modernization, and innovation at scale. An Azure landing zone uses subscriptions to isolate and scale application resources and platform resources.

An Azure landing zone provides the necessary foundation for cloud workloads such as Virtual Desktop. It defines essential components like governance, security, networking, identity, and operations. To host and manage services at scale, you need all these components.

### Types of landing zones

Azure landing zones have [two categories](/azure/cloud-adoption-framework/ready/landing-zone/#platform-landing-zones-vs-application-landing-zones):

- **Platform landing zone** provides shared foundational services like networking, identity management, and resource governance. The platform landing zone forms the core infrastructure that supports application workloads.

- **Application landing zones** host specific applications, workloads, or services. They provide the necessary environment to run applications. Policies and management groups enforce governance in application landing zones.

## Reference architecture

The Virtual Desktop reference architecture is a proven architecture for running Virtual Desktop in an application landing zone. Start with this architecture for Virtual Desktop deployments.

The [landing zone architecture for Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone) is part of the [Virtual Desktop scenario article series](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/) in the Cloud Adoption Framework for Azure. This series describes compatibility requirements, design principles, and deployment guidance for the landing zone.

When you design Virtual Desktop to run from an application landing zone, follow this structured architecture to ensure scalability, security, and operational excellence. This architecture provides a robust foundation to deploy Virtual Desktop at scale while maintaining centralized governance, security, and performance.

### Benefits of this reference architecture

- **Scalability:** Supports large-scale deployments so that you can quickly scale resources based on demand

- **Security:** Uses security measures like Azure role-based access control (Azure RBAC) and network security to protect your environment from threats
- **Operational efficiency:** Includes automation and monitoring tools to reduce operational burden and improve system performance

:::image type="complex" source="./media/virtual-desktop-accelerator-enterprise-landing-zone.svg" alt-text="Diagram that shows the reference architecture required for Virtual Desktop landing zone implementations." border="false" lightbox="./media/virtual-desktop-accelerator-enterprise-landing-zone.svg":::
The diagram illustrates a comprehensive Azure architecture for managing subscriptions and workloads. At the top, the Enterprise Agreement and Microsoft Customer Agreement section connects to Microsoft Entra ID and Active Directory Domain Services, which represents identity and access management. Below that section, the Management subscription includes dashboards and tools for governance and monitoring. The management group and subscription organization section shows a hierarchy of management groups, including platform, identity, connectivity, and landing zone subscriptions, with connections to DevOps processes.

The Identity subscription contains virtual networks labeled region 1 and region N. Each virtual network contains DNS, UDRs, NSGs or ASGs, resource groups, and recovery services vaults. The Connectivity subscription includes Azure DNS private zones, ExpressRoute, and Azure Firewall. Virtual network peering connects this subscription to other subscriptions. The Virtual Desktop landing zone subscriptions show details about virtual network configurations and peering. The Sandbox subscription contains applications and management tools. A legend at the bottom provides definitions for icons and connections in the diagram.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-desktop-accelerator-enterprise-landing-zone.vsdx) of this architecture.*

### Design areas

The letters "A" through "I" in the diagram indicate design areas for the Virtual Desktop landing zone. This diagram shows the hierarchy of resource organization.

| Legend | Design area | Objective |
|--------|-------------|-----------|
| A | [Azure billing and Active Directory tenant](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-enterprise-enrollment) | Set up the tenant, enrollment, and billing configuration early on. |
| B | [Identity and access management](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-identity-and-access-management) | Establish secure access to Virtual Desktop through Microsoft Entra ID, conditional access, and Azure RBAC. Identity and access management is a primary security boundary in the public cloud. It serves as the foundation of secure and fully compliant architectures.  |
| C | [Resource organization](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-resource-organization) | Design subscriptions and management group hierarchies to support governance, operations management, and adoption patterns at scale. |
| D, G, H | [Management and monitoring](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-management-and-monitoring) | Create a baseline that ensures operational visibility, compliance, and the ability to protect and recover workloads. |
| E | [Network topology and connectivity](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-network-topology-and-connectivity) | Design reliable and scalable network architecture as a foundational element of the cloud environment. |
| F | [Security](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-security-governance-and-compliance) | Apply security controls directly within the Virtual Desktop workload. |
| G, F | [Business continuity and disaster recovery](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-business-continuity-and-disaster-recovery) | Create business continuity and disaster recovery strategies for Virtual Desktop and its supporting services to ensure resilience and recovery. This area isn't explicitly labeled in the diagram but is represented within sections G and F. |
| I |  [Platform automation and DevOps](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-platform-automation-and-devops) | 	Enable infrastructure as code and continuous integration and continuous delivery (CI/CD) pipelines to manage platform-level resources, management group policies, role definitions, and subscription provisioning. |

> [!TIP]
>
> Review the Virtual Desktop design areas to ensure alignment with Virtual Desktop best practices.
>
> [Virtual Desktop Azure landing zone design areas](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone#design-guidelines): These areas define the foundational elements required to set up the Virtual Desktop deployment in an enterprise-scale environment. They focus on preparing resources like network configurations, identity management, security, and governance. This landing zone helps create a scalable and secure environment for Virtual Desktop workloads.
>
> [Virtual Desktop design areas](/azure/well-architected/azure-virtual-desktop/overview#what-are-the-key-design-areas): These areas represent the architectural principles and best practices for designing and operating Virtual Desktop workloads. They cover aspects such as application delivery, infrastructure design, security, and cost optimization. Each area aligns with Azure best practices to ensure an optimal and cost-effective Virtual Desktop implementation.

### Design principles

Like other landing zones, the Virtual Desktop landing zone follows the core [Azure landing zone design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) and aligns with common [design areas](/azure/cloud-adoption-framework/ready/landing-zone/design-areas).

This architecture uses the following key principles:

- **Subscription democratization:** Teams manage their own resources within a controlled framework.

- **Policy-driven governance:** Centralized policies and controls enforce compliance and governance.
- **Application-focused service model:** The architecture supports organizations structured around applications.
- **Single control and management plane:** Centralized resource management maintains oversight and control.

### Reference implementation

The Virtual Desktop application landing zone reference implementation follows the reference architecture and design principles outlined in the Cloud Adoption Framework and the Azure Well-Architected Framework. This solution provides steps to prepare landing zone subscriptions for a scalable Virtual Desktop deployment and to deploy Virtual Desktop within those landing zone subscriptions.

The Virtual Desktop landing zone implementation provides your organization with an enterprise-ready Virtual Desktop deployment that aligns with best practices in scalability, security, and governance.

#### Architecture

> [!IMPORTANT]
> The implementation deploys resources into the Virtual Desktop application landing zone and platform landing zone subscriptions.
>
> You must deploy a [Cloud Adoption Framework platform landing zone](/azure/cloud-adoption-framework/ready/enterprise-scale/implementation#reference-implementation) first. This deployment provides the shared foundation subscriptions and services that resources in this implementation require.
>
> Review the Virtual Desktop [prerequisites](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-baseline.md#prerequisites) before you start the [deployment](https://github.com/Azure/avdaccelerator?tab=readme-ov-file#azure-virtual-desktop---lza-baseline).

This architecture is based on multiple subscriptions that are each dedicated to specific purposes:

- **Virtual Desktop subscription:** This subscription, or multiple subscriptions depending on environment scale, deploys the Virtual Desktop resources that are specific to individual workloads, not shared across workloads. These resources include virtual machines, storage accounts, key vaults, and private endpoints. This subscription is considered part of the application landing zone.

- **Virtual Desktop shared services subscription:** This subscription hosts all services shared across multiple Virtual Desktop workloads. It includes resources like Azure Automation accounts, data collection rules, Log Analytics workspaces, and Azure compute galleries. This subscription is considered part of the application landing zone.

- **Platform subscriptions:** These foundational subscriptions provide shared services across the entire environment. They support and connect to application landing zone subscriptions.

  - **Management subscription:** This subscription is part of the Azure landing zone platform structure and typically hosts shared management resources. These resources include monitoring solutions, update management tools, and governance tools. In this architecture, the management subscription isn't an active dependency for the Virtual Desktop workload. The workload team must implement their own automation, monitoring, and management capabilities within their designated workload subscription.

  - **Connectivity subscription:** This subscription contains network-related components like virtual networks, network security groups (NSGs), Azure Firewall, and Azure ExpressRoute or VPN gateways. In this architecture, this subscription provides the Virtual Desktop application landing zone with secure and scalable network infrastructure. This capability enables isolated traffic flows, segmentation between organization workloads, and secure access to cross-premises resources.
  - **Identity subscription:** This subscription handles identity and access management services required to support domain-joined Virtual Desktop session hosts. In this architecture, this subscription provides the Virtual Desktop application landing zone with domain services. These services include Microsoft Entra Domain Services or self-managed Active Directory domain controllers hosted in Azure. These services enable session hosts to join a domain and authenticate users securely, enforce group policies, and support legacy authentication scenarios that some applications require.

:::image type="complex" source="./media/virtual-desktop-accelerator-baseline.svg" alt-text="Diagram that shows the Virtual Desktop reference architecture." border="false" lightbox="./media/virtual-desktop-accelerator-baseline.svg":::
The diagram illustrates a Virtual Desktop architecture with interconnected components distributed across multiple subscriptions. Within this setup, identity synchronization occurs between the customer network and Microsoft Entra ID through Microsoft Entra Connect, which communicates over the internet. This synchronization process allows identities from the on-premises Active Directory Domain Services (AD DS) to be replicated in Microsoft Entra ID. Users from noncorporate networks access the Virtual Desktop control plane directly over the internet without requiring VPN or ExpressRoute. Also, the connection between the customer network and the connectivity subscription is established via VPN or ExpressRoute, which ensures secure communication for internal Azure resources.

The identity subscription in Region A hosts AD DS and other identity management resources. Adjacent to this subscription, the management subscription provides tools for monitoring, automation, and database management, which support operational governance. The Virtual Desktop landing zone subscription is organized into two areas: the management plane, which includes workspaces, application groups, and session hosts, and the shared services landing zone, which contains the Azure shared image gallery and other resources for image management. Arrows throughout the diagram indicate the flow of data and dependencies between components. A legend at the bottom explains the symbols and connections.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-virtual-desktop-accelerator-baseline-architecture.vsdx) of this architecture.*

#### Benefits of this reference implementation

- **Scalability:** It scales efficiently to meet your organization's needs.

- **Security:** It uses enterprise-grade security, compliance, and governance controls to protect your environment.
- **Faster deployment:** It accelerates deployment by using predefined templates, configurations, and best practices.
- **Best practices compliance:** It follows the best practices in the architecture.

#### Repository overview

[![GitHub icon](../../_images/github.png) The Virtual Desktop landing zone reference implementation](https://github.com/Azure/avdaccelerator) supports multiple deployment scenarios depending on your requirements. Each deployment scenario supports both greenfield and brownfield deployments and provides multiple infrastructure as code (IaC) template options:

- The Azure portal UI
- The Azure CLI or Azure PowerShell Bicep template
- A Terraform template

The implementation uses resource naming automation based on the following recommendations:

- [Cloud Adoption Framework best practices for naming conventions](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)

- The [recommended abbreviations for Azure resource types](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- The [minimum suggested tags](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging#minimum-suggested-tags)

Before you proceed with the deployment scenarios, familiarize yourself with the implementations's Azure resource [naming, tagging, and organization](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/resource-naming.md).

:::image type="complex" source="./media/virtual-desktop-accelerator-resource-organization-naming.svg" alt-text="Diagram that shows Virtual Desktop resource organization and naming." lightbox="./media/virtual-desktop-accelerator-resource-organization-naming.svg":::
The diagram shows two subscriptions that support Virtual Desktop. The left section shows an example structure that uses resource groups to organize Virtual Desktop components when you deploy with the Virtual Desktop implementation. The naming convention and resource organization presented are for reference purposes. Key components include host pools, RemoteApp groups, workspaces, and scaling plans.

The section on the right represents shared resources that support Virtual Desktop, such as image templates, image galleries for session host provisioning, monitoring tools, and automation accounts.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-desktop-accelerator-resource-organization-naming.vsdx) of the image.*

##### Deployment steps

To perform the deployment, do the following steps:

1. **Review the deployment prerequisites.** This step helps you ready your environment for the deployment.

1. **Deploy the platform landing zone if you don't already have one.** This step sets up the foundational components.

1. **Deploy the Virtual Desktop reference implementation.** After the platform landing zone is in place, deploy the Virtual Desktop landing zone reference implementation of the reference architecture.

To start, choose the following deployment scenario that best matches your requirements.

##### [Baseline deployment](#tab/baseline)

The baseline deployment deploys the Virtual Desktop resources and dependent services required to establish a Virtual Desktop baseline.

This deployment scenario includes the following items:

- [Virtual Desktop](/azure/virtual-desktop/overview) resources, including a workspace, scaling plan, host pool, application groups, session host virtual machines, and optionally, private endpoints

- An [Azure Files share](/azure/storage/files/files-smb-protocol) integrated with your identity service

- [Azure Key Vault](/azure/key-vault/general/overview) for secret, key, and certificate management

- Optionally, a new [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) that includes baseline NSGs, application security groups (ASGs), and route tables

- Optionally, Azure Storage account and Key Vault private endpoints and private Domain Name System (DNS) zones

When you're ready for deployment, do the following steps:

1. Follow the [Baseline Deployment Guide](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-baseline.md) for details about prerequisites, planning information, and deployment components.

1. Optionally, review the **Custom image build deployment** tab to build an updated image for your Virtual Desktop host sessions.

1. Do the [baseline deployment steps](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/deploy-baseline.md). If you created a custom Azure Compute Gallery image in the previous step, on the **Session hosts** page, choose *Compute Gallery* as the **OS selection source**. Then select the correct **Image**.

:::image type="complex" source="./media/portal-session-hosts-os-selection.png" lightbox="./media/portal-session-hosts-os-selection.png" alt-text="Screenshot that shows the OS selection for the Virtual Desktop deployment.":::
   Screenshot of the deployment user interface for the Virtual Desktop Landing Zone Accelerator baseline. This screenshot shows the session hosts tab of the deployment where the OS selection is highlighted. The source under OS selection is set to Compute Gallery.
:::image-end:::

###### [Custom image build deployment](#tab/custom-image)

You can optionally create a custom image build that generates a new image from Azure Marketplace. This image is stored in an Azure compute gallery. It's optimized, patched, and ready to use. You can customize this deployment to extend functionality, such as adding scripts.

When you're ready for deployment, do the following steps:

1. Review the [Custom Image Build Deployment Guide](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-custom-image-build.md) for details about prerequisites, planning information, and deployment components.

1. Do the [custom image build deployment steps](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/deploy-custom-image.md).

---

## Next steps

To build on the concepts from this design guide, explore the following Microsoft Learn resources:

- [Deploy an enterprise-scale Azure landing zone for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone): Learn how to deploy a Virtual Desktop landing zone that aligns with the Cloud Adoption Framework.

- [Network topology and connectivity for Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-network-topology-and-connectivity): Explore recommended network designs, including hub-and-spoke topology, hybrid connectivity, RDP Shortpath, and security best practices for Virtual Desktop.

- [Security, governance, and compliance for Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-security-governance-and-compliance): Understand how to implement security controls, Azure RBAC, monitoring, and governance to ensure the security and compliance of your Virtual Desktop environment.
