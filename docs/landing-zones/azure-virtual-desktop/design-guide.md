---
title: Azure landing zones - Azure Virtual Desktop landing zone design considerations
description: Design considerations for using Azure Virtual Desktop in an landing zone.
author: roarrioj
ms.author: roarrioj
ms.date: 05/15/2025
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

The Azure Virtual Desktop reference architecture demonstrates how to deploy a proven architecture for Azure Virtual Desktop in your environment. This architecture is a suggested starting point for Azure Virtual Desktop. These reference solutions aid in accelerating deployment of Azure Virtual Desktop.

The [landing zone architecture for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone) is part of the [Virtual Desktop scenario article series](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/) in the Cloud Adoption Framework for Azure. The series provides compatibility requirements, design principles, and deployment guidance for the landing zone.

When designing Azure Virtual Desktop to run from application landing zone, it's essential to follow a structured architecture that ensures scalability, security, and operational excellence. This architecture provides a robust foundation for deploying Azure Virtual Desktop at scale while maintaining centralized governance, security, and performance.

### Benefits of this reference architecture

- **Scalability**: The architecture supports large-scale deployments, enabling you to quickly scale resources based on demand.
- **Security**: Uses security measures like Role-Based Access Control (RBAC) and network security ensure your environment is protected from threats.
- **Operational efficiency**: The architecture includes automation and monitoring tools to reduce the operational burden and improve system performance.

:::image type="complex" source="./media/azure-virtual-desktop-reference-architecture.png" alt-text="Diagram of Azure Virtual Desktop in an Azure landing zone." border="false" lightbox="./media/azure-virtual-desktop-reference-architecture.png":::
    TODO
:::image-end:::

*Figure 2: Azure Virtual Desktop landing zone in an Azure landing zone reference architecture. Download a [Visio file](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/diagrams/avd-accelerator-enterprise-scale-alz-architecture.vsdx) of this architecture.*

### Design principles addressed in this architecture

Like other landing zones, the Azure Virtual Desktop landing zone is built upon the core [Azure landing zone design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) and is aligned with common [design areas](/azure/cloud-adoption-framework/ready/landing-zone/design-areas).

This architecture follows the following key principles.

- **Subscription democratization**: Empowering teams to manage their own resources within a controlled framework.
- **Policy-driven governance**: Ensuring compliance through centralized governance using policies and controls.
- **Application-centric service model**: Focus on application-centric organizations.
- **Single control and management plane**: Centralizing the management of resources to maintain oversight and control.

> These principles help ensure that the organization is ready for cloud adoption and establishes a solid foundation for the Azure Virtul Desktop environment.

### Design areas

Design areas for the Azure Virtual Desktop landing zone are indicated with letters "A" through "J" in the diagram, to illustrate the hierarchy of resource organization:

| Legend | Design area | Objective |
|--------|-------------|-----------|
| A | [Enterprise enrollment](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-enterprise-enrollment) | Proper tenant creation, enrollment, and billing setup are important early steps. |
| B, G | [Identity and access management](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-identity-and-access-management) | Identity and access management is a primary security boundary in the public cloud. It's the foundation for any secure and fully compliant architecture. |
| C-H, J | [Resource organization](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-resource-organization) | As cloud adoption scales, considerations for subscription design and management group hierarchy have an impact on governance, operations management, and adoption patterns. |
| C-H, J | [Management and monitoring](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-management-and-monitoring) | For stable, ongoing operations in the cloud, a management baseline is required to provide visibility, operations compliance, and protect and recover capabilities. |
| E, F | [Network topology and connectivity](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-network-topology-and-connectivity) | Networking and connectivity decisions are an equally important foundational aspect of any cloud architecture. |
| G, F, J | [Business continuity and disaster recovery](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-business-continuity-and-disaster-recovery) | Automate auditing and enforcement of governance policies. |
| F, J | [Security governance and compliance](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-security-governance-and-compliance) | Implement controls and processes to protect your cloud environments. |
| I |  [Platform automation and DevOps](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-platform-automation-and-devops) | Align the best tools and templates to deploy your landing zones and supporting resources. |

> [!TIP]
>
> It's recommended to review the Azure Virtual Desktop design areas to ensure alignment with best practices for Azure Virtual Desktop.
>
> **[Azure Virtual Desktop Azure landing zone design areas](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone#design-guidelines)**: This describes the foundational elements required to set up the Azure Virtual Desktop deployment in an enterprise-scale environment. It focuses on preparing resources like network configurations, identity management, security, and governance. This landing zone helps create a scalable and secure environment for Azure Virtual Desktop workloads.
>
> **[Azure Virtual Desktop design areas](/azure/well-architected/azure-virtual-desktop/overview#what-are-the-key-design-areas)**: These areas refer the architectural principles and best practices to design and operate an Azure Virtual Desktop workload. It covers areas such as Application delivery, Infrastructure design, Security, and Cost optimization. These areas follow Azure's best practices for ensuring an optimal and cost-effective Azure Virtual Desktop implementation.

### Reference implementation

Azure Virtual Desktop application landing zone reference implementation represents an implementation that follows the reference architecture and design principles outlined in the Cloud Adoption Framework and the Azure Well-Architected Framework. This solution provides steps to prepare landing zone subscriptions for a scalable Azure Virtual Desktop deployment, and a deployment of Azure Virtual Desktop within the landing zone subscriptions.

When you use the Azure Virtual Desktop landing zone implementation, your organization will have an enterprise-ready Azure Virtual Desktop deployment that aligns with best practices in scalability, security, and governance.

#### Architecture

> [!IMPORTANT]
> The accelerator deploys resources into the Azure Virtual Desktop application landing zone and shared services landing zone subscriptions.
>
> You must deploy a [Cloud Adoption Framework platform landing zone](/azure/cloud-adoption-framework/ready/enterprise-scale/implementation#reference-implementation) first, to provide the shared foundation services required by the resources deployed in this implementation.
>
> Review the Azure Virtual Desktop [prerequisites](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-baseline.md#prerequisites) before initiating a deployment of the [implementation](https://github.com/Azure/avdaccelerator?tab=readme-ov-file#azure-virtual-desktop---lza-baseline).

The architecture is based on multiple subscriptions, each dedicated to specific purposes.

1. **Azure Virtual Desktop subscription**: This subscription or subscriptions depending on environment scale, will be used to deploy the Azure Virtual Desktop resources that are workload specific (not shared across workloads), some of the resources created on this subscriptions are VMs, Storage, Key Vaults, Private Endpoints, among others.

1. **Azure Virtual Desktop shared services subscription**: This subscription hosts all the services that are used by more than one Azure Virtual Desktop workload, some of the resources created on this subscriptions are Automation Accounts, Data Collection Rules, Log Analytics Workspace, Compute Galleries, among others.

1. **Platform subscriptions**: These are foundational subscriptions that provide shared services across the entire environment. They include:

   - **Management**: Includes resources for governance, monitoring, and operations, such as Azure Monitor and Azure Automation.
   - **Connectivity**: Contains network-related components like Virtual Networks, Network security groups, and Azure Firewall to ensure secure communication between resources.
   - **Identity**: Handles the identity and access management services.

:::image type="complex" source="./media/avd-accelerator-baseline-architecture.png" alt-text="Figure 3: Azure Virtual Desktop reference architecture." border="false" lightbox="./media/avd-accelerator-baseline-architecture.png":::
    TODO
:::image-end:::

*Figure 3: Azure Virtual Desktop reference architecture. Download a [Visio file](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/diagrams/avd-accelerator-baseline-architecture.vsdx) of this architecture.*

#### Benefits of using this reference implementation

- **Scalability**: The accelerator helps set up an architecture that can scale with your organization's needs.
- **Security**: Implements enterprise-grade security, compliance, and governance controls to protect your environment.
- **Faster deployment**: Predefined templates, configurations, and best practices ensure faster and more reliable deployments.
- **Best practices compliance**: The architecture follows the best practices outlined in the Cloud Adoption Framework.

### Next steps

1. **Review prerequisites**: review the baseline deployment prerequisites, this will help you ensure your environment is ready for the deployment.
2. **Deploy the platform landing zone**: Start by deploying the platform landing zone to set up the foundational components.
3. **Use the Azure Virtual Desktop accelerator**: Once the platform landing zone is in place, deploy the Azure Virtual Desktop landing zone accelerator to implement the reference architecture.

For detailed guidance, refer to the full [Enterprise-Scale landing zone for Azure Virtual Desktop documentation](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone).

#### Accelerator overview

The :::image type="icon" source="../../_images/github.png"::: [Azure Virtual Desktop landing zone reference implementation](https://github.com/Azure/avdaccelerator) supports multiple deployment scenarios depending on your requirements. Each deployment scenario supports both greenfield and brownfield deployments and provides multiple infrastructure-as-code (IaC) template options.

- Azure portal UI
- Azure CLI or Azure PowerShell Bicep template
- Terraform template

The accelerator uses resource naming automation based on the following recommendations.

- [Microsoft Cloud Adoption Framework (CAF) best practices for naming convention](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- The [recommended abbreviations for Azure resource types](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- The [minimum suggested tags](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging#minimum-suggested-tags)

Before proceeding with the deployment scenarios, familiarize yourself with the Azure resource [naming, tagging, and organization](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/resource-naming.md) used by the accelerator.

:::image type="complex" source="./media/avd-accelerator-resource-organization-naming.png" alt-text="Figure 4: Azure Virtual Desktop implementation resource organization and naming." border="false" lightbox="./media/avd-accelerator-resource-organization-naming.png":::
    TODO
:::image-end:::

*Figure 4: Azure Virtual Desktop implementation resource organization and naming. Download a [Visio file](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/diagrams/avd-accelerator-resource-organization-naming.vsdx) of the image.*

##### Accelerator deployment

To continue with deployment, choose the following deployment scenario tab that best matches your requirements.

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

   :::image type="complex" source="./media/portal-session-hosts-os-selection.png" alt-text="Screen shot of OS selection field on sessions hosts page in the Azure portal." border="false" lightbox="./media/portal-session-hosts-os-selection.png":::
       TODO
   :::image-end:::


###### [Custom image build deployment](#tab/custom-image)
The optional custom image build creates a new image from Azure Marketplace in an Azure compute gallery, optimized, patched and ready to be used. This deployment is optional and can be customized to extend functionality, like adding scripts to further customize your images.

When you're ready for deployment, complete the following steps.

1. Review the [Getting Started - Custom Image Build Deployment Guide](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-custom-image-build.md) for details on prerequisites, planning information, and a discussion on what is deployed.

1. Continue with the [custom image build deployment steps](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/deploy-custom-image.md).

---

## Next steps

TODO
