---
title: Azure Virtual Desktop Landing Zone Design Guide
description: Design considerations for using Azure Virtual Desktop in a landing zone.
author: roarrioj
ms.author: roarrioj
ms.date: 06/20/2025
ms.topic: conceptual
ms.subservice: architecture-guide
---

# Azure Virtual Desktop landing zone design guide

This article provides a design-oriented overview of the [Azure landing zone design architecture for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone). It targets architects and technical decision-makers. The goal is to help you quickly gain an understanding of the Virtual Desktop landing zone reference implementation.

## Landing zone concepts

An [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone/) is an environment that follows key design principles across eight design areas. These design principles accommodate all application portfolios and enable application migration, modernization, and innovation at scale. An Azure landing zone uses subscriptions to isolate and scale application resources and platform resources.

An Azure landing zone provides the necessary foundation for cloud workloads such as Virtual Desktop. It defines essential components like governance, security, networking, identity, and operations. You need all these components to host and manage services at scale.

### Types of landing zones

Azure landing zones have [two categories](/azure/cloud-adoption-framework/ready/landing-zone/#platform-landing-zones-vs-application-landing-zones):

- **Platform landing zones** provide shared foundational services like networking, identity management, and resource governance. Platform landing zones form the core infrastructure that supports application workloads.

- **Application landing zones** host specific applications, workloads, or services. They provide the necessary environment to run applications. You use policies and management groups to govern application landing zones.

## Reference architecture

The Virtual Desktop reference architecture is a proven architecture for running Virtual Desktop in an application landing zone. Start with this architecture for Virtual Desktop deployments.

The [landing zone architecture for Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone) is part of the [Virtual Desktop scenario article series](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/) in the Cloud Adoption Framework for Azure. The series provides compatibility requirements, design principles, and deployment guidance for the landing zone.

When you design Virtual Desktop to run from application landing zone, follow a structured architecture that ensures scalability, security, and operational excellence. This architecture provides a robust foundation to deploy Virtual Desktop at scale while maintaining centralized governance, security, and performance.

### Benefits of this reference architecture

- **Scalability:** Supports large-scale deployments so that you can quickly scale resources based on demand

- **Security:** Uses security measures like Azure role-based access control (Azure RBAC) and network security to protect your environment from threats
- **Operational efficiency:** Includes automation and monitoring tools to reduce operational burden and improve system performance

:::image type="content" source="./media/azure-virtual-desktop-accelerator-enterprise-scale-landing-zone-architecture.png" alt-text="Diagram that shows the reference architecture required for Virtual Desktop landing zone implementations." border="false" lightbox="./media/azure-virtual-desktop-accelerator-enterprise-scale-landing-zone-architecture.png":::
The diagram illustrates a comprehensive Azure architecture for managing subscriptions and workloads. At the top, the Enterprise Agreement/Microsoft Customer Agreement section connects to Microsoft Entra ID and Active Directory Domain Services, representing identity and access management. Below, the Management subscription includes dashboards and tools for governance and monitoring. The Management group and subscription organization section shows a hierarchy of management groups, including platform, identity, connectivity, and landing zone subscriptions, with connections to DevOps processes.

The Identity subscription contains virtual networks labeled region 1 and region N, each with DNS, UDRs, NSGs/ASGs, resource groups, and recovery services vaults. The Connectivity subscription includes Azure DNS Private Zones, ExpressRoute, and Azure Firewall, with virtual network peering connecting to other subscriptions. The Virtual Desktop landing zone subscriptions feature detailed virtual network configurations and peering, while the Sandbox subscription contains applications and management tools. A legend at the bottom provides definitions for icons and connections used throughout the diagram.
:::image-end:::

*Download a [Visio file](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/diagrams/avd-accelerator-enterprise-scale-alz-architecture.vsdx) of this architecture.*

### Design principles addressed in this architecture

The Virtual Desktop landing zone uses the core [Azure landing zone design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) and aligns with standard [design areas](/azure/cloud-adoption-framework/ready/landing-zone/design-areas).

This architecture uses the following key principles:

- **Subscription democratization:** Teams manage their own resources within a controlled framework.

- **Policy-driven governance:** Centralized policies and controls enforce compliance and governance.
- **Application-centric service model:** The architecture supports application-centric organizations.
- **Single control and management plane:** Centralized resource management maintains oversight and control.

### Design areas

The letters "A" through "I" in the diagram indicate design areas for the Virtual Desktop landing zone. They illustrate the hierarchy of resource organization.

| Legend | Design area | Objective |
|--------|-------------|-----------|
| A | [Azure billing and Active Directory tenant](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-enterprise-enrollment) | Set up the tenant, enrollment, and billing configuration early on. |
| B | [Identity and access management](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-identity-and-access-management) | Establish secure access to Virtual Desktop through Micorost Entra ID, conditional access, and Azure RBAC. Identity and access management is a primary security boundary in the public cloud. It serves as the foundation of any secure and fully compliant architecture.  |
| C | [Resource organization](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-resource-organization) | Design subscriptions and management group hierarchies to support governance, operations management, and adoption patterns at scale. |
| D, G, H | [Management and monitoring](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-management-and-monitoring) | Create a baseline that ensures operational visibility, compliance, and the ability to protect and recover workloads. |
| E | [Network topology and connectivity](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-network-topology-and-connectivity) | Design reliable and scalable network architecture as a foundational element of the cloud environment. |
| F | [Security](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-security-governance-and-compliance) | Apply security controls directly within the Azure Virtual Desktop workload. |
| G, F | [Business continuity and disaster recovery](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-business-continuity-and-disaster-recovery) | Create business continuity and disaster recovery (BCDR) strategies for Virtual Desktop and its supporting services to ensure resilience and recovery. This area isn't shown in the diagram. |
| I |  [Platform automation and DevOps](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-platform-automation-and-devops) | 	Enable infrastructure as code and continuous integration and continuous delivery (CI/CD) pipelines for managing platform-level resources, management group policies, role definitions, and subscription provisioning. |

> [!TIP]
>
> Review the Virtual Desktop design areas to ensure alignment with Virtual Desktop best practices.
>
> **[Virtual Desktop Azure landing zone design areas](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone#design-guidelines):** These areas define the foundational elements required to set up the Virtual Desktop deployment in an enterprise-scale environment. They focuses on preparing resources like network configurations, identity management, security, and governance. This landing zone helps create a scalable and secure environment for Virtual Desktop workloads.
>
> **[Virtual Desktop design areas](/azure/well-architected/azure-virtual-desktop/overview#what-are-the-key-design-areas):** These areas represent the architectural principles and best practices for designing and operating Virtual Desktop workloads. They cover areas such as application delivery, infrastructure design, security, and cost optimization. Each area aligns with Azure best practices to ensure an optimal and cost-effective Virtual Desktop implementation.

### Reference implementation

The Virtual Desktop application landing zone reference implementation represents an implementation that follows the reference architecture and design principles outlined in the Cloud Adoption Framework and the Azure Well-Architected Framework. This solution provides steps to prepare landing zone subscriptions for a scalable Virtual Desktop deployment and to deploy Virtual Desktop within those landing zone subscriptions.

The Virtual Desktop landing zone implementation provides your organization with an enterprise-ready Virtual Desktop deployment that aligns with best practices in scalability, security, and governance.

#### Architecture

> [!IMPORTANT]
> The accelerator deploys resources into the Virtual Desktop application landing zone and shared services landing zone subscriptions.
>
> You must deploy a [Cloud Adoption Framework platform landing zone](/azure/cloud-adoption-framework/ready/enterprise-scale/implementation#reference-implementation) first. This deployment provides the shared foundation services that resources in this implementation require.
>
> Review the Virtual Desktop [prerequisites](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-baseline.md#prerequisites) before you start the [deployment](https://github.com/Azure/avdaccelerator?tab=readme-ov-file#azure-virtual-desktop---lza-baseline).

The architecture is based on multiple subscriptions, each dedicated to specific purposes.

1. **Virtual Desktop subscription:** This subscription or subscriptions, depending on environment scale, is used to deploy the Virtual Desktop resources that are workload specific (not shared across workloads), some of the resources created on these subscriptions are virtual machines, storage, key vaults, private endpoints, among others. These subscriptions are considered part of the application landing zone.

1. **Virtual Desktop shared services subscription:** This subscription hosts all the services that are used by more than one Virtual Desktop workload, some of the resources created on this subscription are automation accounts, Data Collection Rules, Log Analytics workspaces, Azure Compute Galleries, among others. This subscription is also considered part of the application landing zone.

1. **Platform subscriptions:** These are foundational subscriptions that provide shared services across the entire environment. The application landing zone subscriptions are connected to and supported by these platform subscriptions.

   - **Management:**This subscription is part of the Azure Landing Zone platform structure and typically hosts shared management resources such as monitoring solutions, update management, and governance tools. In this architecture, the management subscription is not an active dependency for the Virtual Desktop workload. The workload team is responsible for implementing their own automation, monitoring, and management capabilities within their designated workload subscription.

   - **Connectivity:** Contains network-related components like Virtual Networks (VNets), Network Security Groups (NSGs), Azure Firewall, and ExpressRoute or VPN Gateways. In this architecture, the connectivity subscription is *responsible* for providing the Virtual Desktop application landing zone with secure and scalable network infrastructure, enabling isolated traffic flows, segmentation between organization workloads, and secure access to cross-premises resources.
   - **Identity:** Handles identity and access management services, specifically infrastructure components required to support domain-joined Virtual Desktop session hosts. In this architecture, the identity subscription provides the Virtual Desktop application landing zone with domain services such as Microsoft Entra Domain Services or self-managed Active Directory domain controllers hosted in Azure. These services enable session hosts to join a domain and authenticate users securely, supporting group policy enforcement. and legacy authentication scenarios required by some applications.

:::image type="complex" source="./media/azure-virtual-desktop-accelerator-baseline-architecture.png" alt-text="Diagram of Virtual Desktop reference architecture." border="false" lightbox="./media/azure-virtual-desktop-accelerator-baseline-architecture.png":::
The diagram illustrates an Virtual Desktop architecture with interconnected components distributed across multiple subscriptions. Within this setup, identity synchronization occurs between the customer network and Microsoft Entra ID through Microsoft Entra Connect, which communicates over the Internet. This synchronization process allows identities from the on-premises Active Directory Domain Services (AD DS) to be replicated in Azure Entra ID. Users from non-corporate networks access the Virtual Desktop control plane directly over the Internet without requiring VPN or ExpressRoute. Additionally, the connection between the customer network and the connectivity subscription is established via VPN or ExpressRoute, ensuring secure communication for internal Azure resources.

The identity subscription in Region A hosts Active Directory Domain Services and other identity management resources. Adjacent to this, the management subscription provides tools for monitoring, automation, and database management, supporting operational governance. The Virtual Desktop landing zone subscription is organized into two areas: the management plane, which includes workspaces, application groups, and session hosts, and the shared services landing zone, which contains the Azure Shared Image Gallery and additional resources for image management. Arrows throughout the diagram indicate the flow of data and dependencies between components, with a legend at the bottom explaining the symbols and connections used.
:::image-end:::

*Figure 2: Virtual Desktop reference architecture. Download a [Visio file](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/diagrams/avd-accelerator-enterprise-scale-alz-architecture.vsdx) of this architecture.*

#### Benefits of using this reference implementation

- **Scalability:** The implementation is designed to scale with your organization's needs.

- **Security:** The implementation uses enterprise-grade security, compliance, and governance controls to protect your environment.
- **Faster deployment:** The predefined templates, configurations, and best practices provide you a fast and reliable deployment.
- **Best practices compliance:** The implementation follows the best practices designed in the architecture.

#### Accelerator overview

[![GitHub icon](../../_images/github.png) Virtual Desktop landing zone reference implementation](https://github.com/Azure/avdaccelerator) supports multiple deployment scenarios depending on your requirements. Each deployment scenario supports both greenfield and brownfield deployments and provides multiple infrastructure-as-code (IaC) template options.

- Azure portal UI
- Azure CLI or Azure PowerShell Bicep template
- Terraform template

The accelerator uses resource naming automation based on the following recommendations.

- [Microsoft Cloud Adoption Framework (CAF) best practices for naming convention](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)

- The [recommended abbreviations for Azure resource types](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- The [minimum suggested tags](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging#minimum-suggested-tags)

Before proceeding with the deployment scenarios, familiarize yourself with the Azure resource [naming, tagging, and organization](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/resource-naming.md) used by the accelerator.

:::image type="complex" source="./media/azure-virtual-desktop-accelerator-resource-organization-naming.png" alt-text="Diagram showing Virtual Desktop resource organization and naming." border="false" lightbox="./media/azure-virtual-desktop-accelerator-resource-organization-naming.png":::
The diagram illustrates two subscriptions supporting Virtual Desktop. The left section shows an example structure using resource groups to organize Virtual Desktop components when deploying with the Virtual Desktop Accelerator. The naming convention and resource organization presented are for reference purposes. Key components include, but are not limited to, Host Pools, RemoteApp Groups, Workspaces, and Scaling Plans.

The right section represents shared resources that support Virtual Desktop, such as image templates, image galleries for session host provisioning, monitoring tools, and automation accounts.
:::image-end:::

*Figure 3: Virtual Desktop implementation resource organization and naming. Download a [Visio file](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/diagrams/avd-accelerator-resource-organization-naming.vsdx) of the image.*

##### Accelerator deployment

To perform the deployment, follow these steps.

1. **Review prerequisites:** Review the deployment prerequisites. This helps you ensure your environment is ready for the deployment.

1. **Deploy the platform landing zone** *(if you don't already have one)*: Start by deploying the platform landing zone to set up the foundational components.

1. **Deploy the Virtual Desktop reference implementation:** Once the platform landing zone is in place, deploy the Virtual Desktop landing zone reference implementation of the reference architecture.

To start, you need to choose the following deployment scenario tab that best matches your requirements.

##### [Baseline deployment](#tab/baseline)

The baseline deployment deploys the Virtual Desktop resources and dependent services that allow you to establish an Virtual Desktop baseline.

This deployment scenario includes the following items.

- [Virtual Desktop](/azure/virtual-desktop/overview) resources, including Virtual Desktop workspace, application groups, scaling plan, host pool, and session host virtual machines and optionally private endpoints

- An [Azure Files share](/azure/storage/files/files-smb-protocol) integrated with your identity service

- [Azure Key Vault](/azure/key-vault/general/overview) for secret, key, and certificate management

- Optionally, a new [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) with baseline Network Security Groups (NSG), Application Security Groups (ASG), and route tables

- Optionally, Storage Account and Key Vault private endpoints and private DNS zones

When you're ready for deployment, complete the following steps.

1. Follow the [Getting Started - Baseline Deployment Guide](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-baseline.md) for details on prerequisites, planning information, and a discussion on what is deployed.

1. Optionally, refer to the **Custom image build deployment** tab to build an updated image for your Virtual Desktop host sessions.

1. Continue with the [baseline deployment steps](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/deploy-baseline.md). If you created a custom Azure Compute Gallery image in the previous step, be sure to select "Compute gallery" for **OS image source** and select the correct **Image** on the **Session hosts** page:

:::image type="complex" source="./media/portal-session-hosts-os-selection.png" lightbox="./media/portal-session-hosts-os-selection.png" alt-text="Screenshot for deploying the Virtual Desktop highlighting the OS Selection" border="false":::
    Screenshot of the deployment user interface for the Virtual Desktop - Landing Zone Accelerator - Baseline. This screenshot shows the 'session hosts' tab of the deployment where the 'OS selection' is highlighted. The 'source' under 'OS Selection' is set to 'Compute Gallery'
:::image-end:::

###### [Custom image build deployment](#tab/custom-image)

The optional custom image build creates a new image from Azure Marketplace in an Azure compute gallery, optimized, patched, and ready to be used. This deployment is optional and can be customized to extend functionality, like adding scripts to further customize your images.

When you're ready for deployment, complete the following steps.

1. Review the [Getting Started - Custom Image Build Deployment Guide](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-custom-image-build.md) for details on prerequisites, planning information, and a discussion on what is deployed.

1. Continue with the [custom image build deployment steps](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/deploy-custom-image.md).

---

## Next steps

To continue building on the concepts from this design guide, explore the following Microsoft Learn resources:

[Enterprise-scale support for Virtual Desktop landing zone accelerator](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone) - Learn how to deploy an Virtual Desktop landing zone using Infrastructure-as-Code accelerators aligned with the Cloud Adoption Framework.

[Network topology and connectivity for Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-network-topology-and-connectivity) - Explore recommended network designs, including hub-and-spoke topology, hybrid connectivity, RDP Shortpath, and security best practices for Virtual Desktop.

[Security, governance, and compliance for Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-security-governance-and-compliance) - Understand how to implement security controls, role-based access, monitoring, and governance to ensure your Virtual Desktop environment is secure and compliant.

