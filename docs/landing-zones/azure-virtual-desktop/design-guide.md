---
title: Azure landing zones - Azure Virtual Desktop landing zone design considerations
description: Design considerations for using Azure Virtual Desktop in a landing zone.
author: roarrioj
ms.author: roarrioj
ms.date: 06/20/2025
ms.topic: conceptual
ms.subservice: architecture-guide
---

# Azure Virtual Desktop landing zone design guide

This article provides a design-oriented overview of the [Azure landing zone design for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone), for architects and technical decision makers. The goal is to help you quickly gain an understanding of the Azure Virtual Desktop landing zone reference implementation.

## Landing zone concepts

An [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone/) is an environment that follows key design principles across eight design areas. These design principles accommodate all application portfolios and enable application migration, modernization, and innovation at scale. An Azure landing zone uses subscriptions to isolate and scale application resources and platform resources.

An Azure landing zone provides the necessary foundation for cloud workloads such as Azure Virtual Desktop. It defines essential components like governance, security, networking, identity, and operations, all of these are required for hosting and managing services at scale.

### Types of landing zones

Azure landing zones are categorized into [two types](/azure/cloud-adoption-framework/ready/landing-zone/#platform-landing-zones-vs-application-landing-zones):

- **Platform landing zone**

   This provides shared foundational services like networking, identity management, and resource governance. Your platform landing zone is the core infrastructure upon which application workloads are built.

- **Application landing zones**

   These are designed to host particular applications, workloads, or services. They provide the necessary environment for running applications and are governed via policies and management groups.

## Reference architecture

The Azure Virtual Desktop reference architecture is a proven architecture for running Azure Virtual Desktop in an application landing zone. This architecture is a recommended starting point for Azure Virtual Desktop deployments.

The [landing zone architecture for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone) is part of the [Virtual Desktop scenario article series](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/) in the Cloud Adoption Framework for Azure. The series provides compatibility requirements, design principles, and deployment guidance for the landing zone.

When designing Azure Virtual Desktop to run from application landing zone, it's essential to follow a structured architecture that ensures scalability, security, and operational excellence. This architecture provides a robust foundation for deploying Azure Virtual Desktop at scale while maintaining centralized governance, security, and performance.

### Benefits of this reference architecture

- **Scalability**: The architecture supports large-scale deployments, enabling you to quickly scale resources based on demand.
- **Security**: Uses security measures like Role-Based Access Control (RBAC) and network security ensure your environment is protected from threats.
- **Operational efficiency**: The architecture includes automation and monitoring tools to reduce the operational burden and improve system performance.

:::image type="complex" source="./media/azure-virtual-desktop-accelerator-enterprise-scale-alz-architecture.png" alt-text="Diagram of Azure Virtual Desktop architecture in an Azure landing zone." border="false" lightbox="./media/azure-virtual-desktop-accelerator-enterprise-scale-alz-architecture.png":::

    The diagram illustrates a comprehensive Azure architecture for managing subscriptions and workloads. At the top, the Enterprise Agreement/Microsoft Customer Agreement section connects to Microsoft Entra ID and Active Directory Domain Services, representing identity and access management. Below, the Management subscription includes dashboards and tools for governance and monitoring. The Management group and subscription organization section shows a hierarchy of management groups, including platform, identity, connectivity, and landing zone subscriptions, with connections to DevOps processes.

The Identity subscription contains virtual networks labeled region I and region II, each with DNS, UDRs, NSGs/ASGs, resource groups, and recovery services vaults. The Connectivity subscription includes Azure DNS Private Zones, ExpressRoute, and Azure Firewall, with virtual network peering connecting to other subscriptions. The Azure Virtual Desktop landing zone subscriptions feature detailed virtual network configurations and peering, while the Sandbox subscription contains applications and management tools. A legend at the bottom provides definitions for icons and connections used throughout the diagram.
:::image-end:::


*Figure 1: Azure Virtual Desktop landing zone in an Azure landing zone reference architecture. Download a [Visio file](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/diagrams/avd-accelerator-enterprise-scale-alz-architecture.vsdx) of this architecture.*

### Design principles addressed in this architecture

Like other landing zones, the Azure Virtual Desktop landing zone is built upon the core [Azure landing zone design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) and is aligned with common [design areas](/azure/cloud-adoption-framework/ready/landing-zone/design-areas).

This architecture follows the following key principles.

- **Subscription democratization**: Empowering teams to manage their own resources within a controlled framework.
- **Policy-driven governance**: Ensuring compliance through centralized governance using policies and controls.
- **Application-centric service model**: Focus on application-centric organizations.
- **Single control and management plane**: Centralizing the management of resources to maintain oversight and control.

### Design areas

Design areas for the Azure Virtual Desktop landing zone are indicated with letters "A" through "I" in the diagram, to illustrate the hierarchy of resource organization:

| Legend | Design area (s) | Objective |
|--------|-------------|-----------|
| A | [Azure billing and Active Directory tenant](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-enterprise-enrollment) | Proper tenant creation, enrollment, and billing setup are important early steps. |
| B | [Identity and access management](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-identity-and-access-management) | Identity and access management is a primary security boundary in the public cloud. It's the foundation for any secure and fully compliant architecture. Enables secure access to AVD through Azure AD, conditional access, and role-based access control |
| C | [Resource organization](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-resource-organization) | As cloud adoption scales, considerations for subscription design and management group hierarchy have an impact on governance, operations management, and adoption patterns. |
| D, G, H | [Management and monitoring](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-management-and-monitoring) | For stable, ongoing operations in the cloud, a management baseline is required to provide visibility, operations compliance, and protect and recover capabilities. |
| E | [Network topology and connectivity](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-network-topology-and-connectivity) | Networking and connectivity decisions are an equally important foundational aspect of any cloud architecture. |
| F | [Security](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-security-governance-and-compliance) | Implements security controls within the AVD workload |
| G, F | [Business continuity and disaster recovery](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-business-continuity-and-disaster-recovery) | not represented in the diagram, this area is addressed by implementing BCDR strategies for the AVD workload and its supporting services to ensure resilience and recovery capabilities.|
| I |  [Platform automation and DevOps](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-platform-automation-and-devops) | Supports infrastructure-as-code and CI/CD pipelines for deploying and managing platform-level resources and governance artifacts such as management group policies, role definitions, and subscription vending processes.|



> [!TIP]
>
> We recommend you review the Azure Virtual Desktop design areas to ensure alignment with best practices for Azure Virtual Desktop.
>
> **[Azure Virtual Desktop Azure landing zone design areas](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone#design-guidelines)**: This describes the foundational elements required to set up the Azure Virtual Desktop deployment in an enterprise-scale environment. It focuses on preparing resources like network configurations, identity management, security, and governance. This landing zone helps create a scalable and secure environment for Azure Virtual Desktop workloads.
>
> **[Azure Virtual Desktop design areas](/azure/well-architected/azure-virtual-desktop/overview#what-are-the-key-design-areas)**: These areas refer the architectural principles and best practices to design and operate an Azure Virtual Desktop workload. It covers areas such as Application delivery, Infrastructure design, Security, and Cost optimization. These areas follow Azure's best practices for ensuring an optimal and cost-effective Azure Virtual Desktop implementation.

### Reference implementation

Azure Virtual Desktop application landing zone reference implementation represents an implementation that follows the reference architecture and design principles outlined in the Cloud Adoption Framework and the Azure Well-Architected Framework. This solution provides steps to prepare landing zone subscriptions for a scalable Azure Virtual Desktop deployment, and a deployment of Azure Virtual Desktop within the landing zone subscriptions.

When you use the Azure Virtual Desktop landing zone implementation, your organization has an enterprise-ready Azure Virtual Desktop deployment that aligns with best practices in scalability, security, and governance.

#### Architecture

> [!IMPORTANT]
> The accelerator deploys resources into the Azure Virtual Desktop application landing zone and shared services landing zone subscriptions.
>
> You must deploy a [Cloud Adoption Framework platform landing zone](/azure/cloud-adoption-framework/ready/enterprise-scale/implementation#reference-implementation) first, to provide the shared foundation services required by the resources deployed in this implementation.
>
> Review the Azure Virtual Desktop [prerequisites](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-baseline.md#prerequisites) before initiating a deployment of the [implementation](https://github.com/Azure/avdaccelerator?tab=readme-ov-file#azure-virtual-desktop---lza-baseline).

The architecture is based on multiple subscriptions, each dedicated to specific purposes.

1. **Azure Virtual Desktop subscription**: This subscription or subscriptions, depending on environment scale, is used to deploy the Azure Virtual Desktop resources that are workload specific (not shared across workloads), some of the resources created on these subscriptions are virtual machines, storage, key vaults, private endpoints, among others. These subscriptions are considered part of the application landing zone.

1. **Azure Virtual Desktop shared services subscription**: This subscription hosts all the services that are used by more than one Azure Virtual Desktop workload, some of the resources created on this subscription are automation accounts, Data Collection Rules, Log Analytics workspaces, Azure Compute Galleries, among others. This subscription is also considered part of the application landing zone.

1. **Platform subscriptions**: These are foundational subscriptions that provide shared services across the entire environment. The application landing zone subscriptions are connected to and supported by these platform subscriptions.

   - **Management**:This subscription is part of the Azure Landing Zone platform structure and typically hosts shared management resources such as monitoring solutions, update management, and governance tools. In this architecture, the management subscription is not an active dependency for the Azure Virtual Desktop workload. The workload team is responsible for implementing their own automation, monitoring, and management capabilities within their designated workload subscription.
   - **Connectivity**: Contains network-related components like Virtual Networks (VNets), Network Security Groups (NSGs), Azure Firewall, and ExpressRoute or VPN Gateways. In this architecture, the connectivity subscription is *responsible* for providing the Azure Virtual Desktop application landing zone with secure and scalable network infrastructure, enabling isolated traffic flows, segmentation between organization workloads, and secure access to cross-premises resources.
   - **Identity**: Handles identity and access management services, specifically infrastructure components required to support domain-joined Azure Virtual Desktop session hosts. In this architecture, the identity subscription provides the Azure Virtual Desktop application landing zone with domain services such as Microsoft Entra Domain Services or self-managed Active Directory domain controllers hosted in Azure. These services enable session hosts to join a domain and authenticate users securely, supporting group policy enforcement. and legacy authentication scenarios required by some applications.

:::image type="complex" source="./media/avd-accelerator-baseline-architecture.png" alt-text="Diagram of Azure Virtual Desktop reference architecture." border="false" lightbox="./media/avd-accelerator-baseline-architecture.png":::
    TODO
:::image-end:::


*Figure 2: Azure Virtual Desktop reference architecture. Download a [Visio file](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/diagrams/avd-accelerator-enterprise-scale-alz-architecture.vsdx) of this architecture.*

#### Benefits of using this reference implementation

- **Scalability**: The implementation is designed to scale with your organization's needs.
- **Security**: The implementation uses enterprise-grade security, compliance, and governance controls to protect your environment.
- **Faster deployment**: The predefined templates, configurations, and best practices provide you a fast and reliable deployment.
- **Best practices compliance**: The implementation follows the best practices designed in the architecture.


#### Accelerator overview

[![GitHub icon](../../_images/github.png) Azure Virtual Desktop landing zone reference implementation](https://github.com/Azure/avdaccelerator) supports multiple deployment scenarios depending on your requirements. Each deployment scenario supports both greenfield and brownfield deployments and provides multiple infrastructure-as-code (IaC) template options.

- Azure portal UI
- Azure CLI or Azure PowerShell Bicep template
- Terraform template

The accelerator uses resource naming automation based on the following recommendations.

- [Microsoft Cloud Adoption Framework (CAF) best practices for naming convention](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- The [recommended abbreviations for Azure resource types](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- The [minimum suggested tags](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging#minimum-suggested-tags)

Before proceeding with the deployment scenarios, familiarize yourself with the Azure resource [naming, tagging, and organization](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/resource-naming.md) used by the accelerator.

:::image type="complex" source="./media/avd-accelerator-resource-organization-naming.png" alt-text="Diagram showing Azure Virtual Desktop resource organization and naming." border="false" lightbox="./media/avd-accelerator-resource-organization-naming.png":::
    TODO
:::image-end:::


*Figure 3: Azure Virtual Desktop implementation resource organization and naming. Download a [Visio file](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/diagrams/avd-accelerator-resource-organization-naming.vsdx) of the image.*

##### Accelerator deployment


To perform the deployment, follow these steps.

1. **Review prerequisites**: Review the deployment prerequisites. This will help you ensure your environment is ready for the deployment.

1. **Deploy the platform landing zone** *(if you don't already have one)*: Start by deploying the platform landing zone to set up the foundational components.

1. **Deploy the Azure Virtual Desktop reference implementation**: Once the platform landing zone is in place, deploy the Azure Virtual Desktop landing zone reference implementation of the reference architecture.

To start, you need to choose the following deployment scenario tab that best matches your requirements.

##### [Baseline deployment](#tab/baseline)
The baseline deployment deploys the Azure Virtual Desktop resources and dependent services that allow you to establish an Azure Virtual Desktop baseline.

This deployment scenario includes the following items.

- [Azure Virtual Desktop](/azure/virtual-desktop/overview) resources, including Azure Virtual Desktop workspace, application groups, scaling plan, host pool, and session host virtual machines and optionally private endpoints

- An [Azure Files share](/azure/storage/files/files-smb-protocol) integrated with your identity service

- [Azure Key Vault](/azure/key-vault/general/overview) for secret, key, and certificate management

- Optionally, a new [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) with baseline Network Security Groups (NSG), Application Security Groups (ASG), and route tables

- Optionally, Storage Account and Key Vault private endpoints and private DNS zones

When you're ready for deployment, complete the following steps.

1. Follow the [Getting Started - Baseline Deployment Guide](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-baseline.md) for details on prerequisites, planning information, and a discussion on what is deployed.

1. Optionally, refer to the **Custom image build deployment** tab to build an updated image for your Azure Virtual Desktop host sessions.

1. Continue with the [baseline deployment steps](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/deploy-baseline.md). If you created a custom Azure Compute Gallery image in the previous step, be sure to select "Compute gallery" for **OS image source** and select the correct **Image** on the **Session hosts** page:

:::image type="complex" source="./media/portal-session-hosts-os-selection.png" lightbox="./media/portal-session-hosts-os-selection.png" alt-text="Screenshot for deploying the Azure Virtual Desktop highlighting the OS Selection" border="false":::
    Screenshot of the deployment user interface for the Azure Virtual Desktop - Landing Zone Accelerator - Baseline. This screenshot shows the 'session hosts' tab of the deployment where the 'OS selection' is highlighted. The 'source' under 'OS Selection' is set to 'Compute Gallery'
:::image-end:::



###### [Custom image build deployment](#tab/custom-image)
The optional custom image build creates a new image from Azure Marketplace in an Azure compute gallery, optimized, patched, and ready to be used. This deployment is optional and can be customized to extend functionality, like adding scripts to further customize your images.

When you're ready for deployment, complete the following steps.

1. Review the [Getting Started - Custom Image Build Deployment Guide](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-custom-image-build.md) for details on prerequisites, planning information, and a discussion on what is deployed.

1. Continue with the [custom image build deployment steps](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/deploy-custom-image.md).

---

## Next steps

To continue building on the concepts from this design guide, explore the following Microsoft Learn resources:

[Enterprise-scale support for Azure Virtual Desktop landing zone accelerator](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone) - Learn how to deploy an Azure Virtual Desktop landing zone using Infrastructure-as-Code accelerators aligned with the Cloud Adoption Framework.

[Network topology and connectivity for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-network-topology-and-connectivity) - Explore recommended network designs, including hub-and-spoke topology, hybrid connectivity, RDP Shortpath, and security best practices for Azure Virtual Desktop.

[Security, governance, and compliance for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-security-governance-and-compliance) - Understand how to implement security controls, role-based access, monitoring, and governance to ensure your Azure Virtual Desktop environment is secure and compliant.

