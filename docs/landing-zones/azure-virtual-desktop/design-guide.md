---
title: Azure landing zones - Azure Virtual Desktop landing zone design considerations
description: Design considerations for using the enterprise-scale Azure Virtual Desktop landing zone, which is part of the Cloud Adoption Framework for Azure.
author: RobBagby
categories:
  - azure-virtual-desktop
  - management-and-governance
  - migration
  - networking
  - security
ms.author: pnp
ms.date: 04/19/2023
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
azureCategories:
  - azure-virtual-desktop
  - management-and-governance
  - migration
  - networking
  - security
products:
  - azure-virtual-desktop
---

# Azure Virtual Desktop landing zone design guide

This article provides a design-oriented overview of the [enterprise-scale landing zone for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone), for architects and technical decision makers. The goal is to help you quickly gain an understanding of the accelerator and how it's designed, allowing you to shorten the time required to complete a successful deployment.


## Landing zone concepts

An Azure landing zone is a set of guidelines, policies, and configurations that provide a foundation for cloud workloads such as **Azure Virtual Desktop (AVD)**. It defines the governance, security, networking, identity, and operations required for hosting services at scale.

**Key components include:**
- **Platform Landing Zones**: Subscriptions that provide shared services (identity, connectivity, management) to applications in application landing zones.
- **Application Landing Zones**: Subscriptions for hosting specific applications, pre-provisioned through code and governed via management groups and policies.


[Landing zone concepts](../includes/concepts.md)]


## Reference architecture

The [enterprise-scale landing zone for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone) is part of the "Desktop virtualization" scenario article series in the Azure Cloud Adoption Framework. The series provides compatibility requirements, design principles, and deployment guidance for the landing zone. They also serve as the reference architecture for an enterprise-scale implementation, ensuring the environment is capable of hosting desktops and any supporting workloads.

When designing Azure Virtual Desktop (AVD) in an **Enterprise-Scale Landing Zone (ESLZ)**, it's essential to follow a structured architecture that ensures scalability, security, and operational excellence. The **Enterprise-Scale AVD Reference Architecture** provides a robust foundation for deploying AVD at scale while maintaining centralized governance, security, and performance.


### Benefits

- **Scalability**: The architecture supports large-scale deployments, enabling you to quickly scale resources based on demand.
- **Security**: Built-in security measures like RBAC and network security ensure your environment is protected from threats.
- **Operational Efficiency**: Automation and monitoring tools reduce the operational burden and improve system performance.



:::image type="content" source="./media/azure-virtual-desktop-reference-architecture.png" alt-text="Diagram of reference architecture required for Azure Virtual Desktop landing zone implementations." border="false" lightbox="./media/azure-virtual-desktop-reference-architecture.png" :::

## Design principles

Like other landing zones, the enterprise-scale Azure Virtual Desktop landing zone is built upon the core [design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) from the Cloud Adoption Framework (CAF) and is aligned with common [design areas](/azure/cloud-adoption-framework/ready/landing-zone/design-areas).

When designing an Azure Virtual Desktop (AVD) environment, it's essential to consider the design principles recommended by both the Cloud Adoption Framework (CAF) and the Well-Architected Framework (WAF). While CAF focuses on organizational readiness and scalable governance through landing zones, WAF provides guidance on building reliable, secure, cost-optimized, and operationally excellent solutions. These frameworks complement each other and ensure a holistic approach to cloud adoption and technical design.


### Cloud Adoption Framework (CAF) and Azure Landing Zone Design Principles

The **Cloud Adoption Framework (CAF)** is a comprehensive approach that guides organizations through the process of adopting Azure, including planning, governance, and operations. One key stage of the CAF is the **Ready phase**, which focuses on preparing your organization and its cloud environment for successful adoption. 

As part of the **Ready phase**, **Azure Landing Zones** provide a set of best practices for **structuring and securing** your cloud infrastructure. These **Azure Landing Zone design principles** are intended to ensure that your environment is properly governed, scalable, and secure, laying the foundation for a successful cloud migration.

Key principles include:

1. **Subscription Democratization**: Empowering teams to manage their own resources within a controlled framework.
2. **Policy-Driven Governance**: Ensuring compliance through centralized governance using policies and controls.
3. **Single Control and Management Plane**: Centralizing the management of resources to maintain oversight and control.

>**These principles help ensure that the organization is ready for cloud adoption and establishes a solid foundation for the AVD environment.**

---

### Well-Architected Framework (WAF) Design Principles

The **Well-Architected Framework (WAF)** focuses on the **technical design** of cloud environments, providing guidelines to ensure that your AVD solution is **reliable**, **secure**, **cost-efficient**, and **performant**. Key principles include:

1. **Reliability**: Ensuring high availability and disaster recovery capabilities.
2. **Security**: Protecting the environment with identity management, encryption, and access control.
3. **Cost Optimization**: Managing resources efficiently to keep costs under control.
4. **Performance Efficiency**: Optimizing compute, storage, and other resources for performance.
5. **Operational Excellence**: Implementing automation, monitoring, and continuous improvement practices.

>**These principles help ensure that the technical aspects of your AVD environment are optimized for the best possible user experience and operational performance.**

---

## Design Areas

### Azure Virtual Desktop Azure landing zone Design Areas

Design areas for the Azure Virtual Desktop landing zone are indicated with letters "A" through "J" in the diagram, to illustrate the hierarchy of resource organization:

| Legend | Design area | Objective |
|--------|-------------|-----------|
| A | [Enterprise enrollment](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-enterprise-enrollment)  | Proper tenant creation, enrollment, and billing setup are important early steps. |
| B, G | [Identity and access management](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-identity-and-access-management) | Identity and access management is a primary security boundary in the public cloud. It's the foundation for any secure and fully compliant architecture. |
| C-H, J | [Resource organization](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-resource-organization) | As cloud adoption scales, considerations for subscription design and management group hierarchy have an impact on governance, operations management, and adoption patterns. |
| C-H, J | [Management and monitoring](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-management-and-monitoring) | For stable, ongoing operations in the cloud, a management baseline is required to provide visibility, operations compliance, and protect and recover capabilities. |
| E, F | [Network topology and connectivity](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-network-topology-and-connectivity) | Networking and connectivity decisions are an equally important foundational aspect of any cloud architecture. |
| G, F, J | [Business continuity and disaster recovery](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-business-continuity-and-disaster-recovery) | Automate auditing and enforcement of governance policies. |
| F, J | [Security governance and compliance](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-security-governance-and-compliance) | Implement controls and processes to protect your cloud environments. |
| I |  [Platform automation and DevOps](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/eslz-platform-automation-and-devops) | Align the best tools and templates to deploy your landing zones and supporting resources. |


:::image type="content" source="../enterprise-scale/media/azure-landing-zone-architecture-diagram-hub-spoke.svg" alt-text="A conceptual architecture diagram of an Azure landing zone." lightbox="../enterprise-scale/media/azure-landing-zone-architecture-diagram-hub-spoke.svg":::
*Figure 1: Azure landing zone conceptual architecture. Download a [Visio file](https://github.com/microsoft/CloudAdoptionFramework/raw/main/ready/enterprise-scale-architecture.vsdx) of this architecture.*





> [!TIP]
>
>  It is recommended to review the **Azure Virtual Desktop Design Areas** to ensure alignment with best practices for AVD.
> 
> **Difference between " Azure Virtual Desktop Azure (AVD) landing zone Design Areas" and "Azure Virtual Desktop Design Areas"**:
>
> - **Azure Virtual Desktop Azure landing zone Design Areas**: This refers to the foundational elements required to set up the **Azure Virtual Desktop (AVD)** deployment in an enterprise-scale environment. It focuses on preparing resources like network configurations, identity management, security, and governance. This landing zone helps create a scalable and secure environment for AVD workloads.
>
>📖 Reference [Azure Virtual Desktop Azure landing zone - Design guidelines](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone#design-guidelines)
>
>
> - **Azure Virtual Desktop Design Areas**: These refer to the architectural principles and best practices specifically related to the design and operation of AVD. It covers areas such as **Application Delivery**, **Infrastructure Design**, **Security**, and **Cost Optimization**. These areas follow Azure's best practices for ensuring an optimal and cost-effective AVD implementation.
>
> 📖 Reference [Azure Virtual Desktop - design areas](https://github.com/MicrosoftDocs/well-architected/blob/main/well-architected/azure-virtual-desktop/overview.md#what-are-the-key-design-areas)
>






## Reference implementation

Azure Virtual Desktop Landing Zone Accelerator (LZA) represents the strategic design path and target technical state for Azure Virtual Desktop deployment. This solution provides an architectural approach and reference implementation to prepare landing zone subscriptions for a scalable Azure Virtual Desktop deployment. 

The **Azure Virtual Desktop Landing Zone Accelerator (LZA)** provides an enterprise-scale implementation of Azure Virtual Desktop (AVD), streamlining the deployment process while ensuring scalability, security, and governance. This accelerator is based on the reference architecture and design principles laid out in the Cloud Adoption Framework (CAF) and the Well-Architected Framework (WAF).

### Azure Virtual Desktop Landing Zone Accelerator (LZA)

The **LZA** is designed to prepare **Azure Virtual Desktop** (AVD) workloads for deployment by creating an optimized landing zone in Azure. The accelerator ensures that all relevant infrastructure components, governance policies, and best practices are implemented to support scalable and secure AVD environments.

By using the **LZA**, you can rapidly set up an enterprise-scale reference environment with the necessary resources to deploy **Azure Virtual Desktop** and integrate it with other Azure services.

### Architecture

> [!IMPORTANT]
> The accelerator deploys resources into the Azure Virtual Desktop landing zone subscriptions identified in the following architecture diagram: **AVD LZ Subscription**, and **AVD Shared Services LZ Subscription**. 
> 
> **We strongly recommend deployment of the appropriate [Cloud Adoption Framework platform landing zone](/azure/cloud-adoption-framework/ready/enterprise-scale/implementation#reference-implementation) first, to provide the enterprise-scale foundation services required by the resources deployed by the accelerator.** Refer to the [baseline deployment prerequisites](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-baseline.md#prerequisites) to review the full set of prerequisites and requirements for the accelerator.

:::image type="content" source="https://raw.githubusercontent.com/Azure/avdaccelerator/main/workload/docs/diagrams/avd-accelerator-baseline-architecture.png" alt-text="Diagram of reference implementation created by Azure Virtual Desktop landing zone accelerator." border="false" lightbox="https://raw.githubusercontent.com/Azure/avdaccelerator/main/workload/docs/diagrams/avd-accelerator-baseline-architecture.png" :::

The LZA architecture is based on multiple primary subscriptions, each dedicated to a specific service:


1. **AVD LZ Subscription**: This is the main subscription for AVD workloads, where the virtual desktops, virtual machines, and related infrastructure are deployed.
   
2.  **Platform Subscriptions**: These are foundational subscriptions that provide shared services across the entire environment. They include:
   - **Management**: Includes resources for governance, monitoring, and operations, such as **Azure Monitor** and **Azure Automation**.
   - **Networking**: Contains network-related components like **VNets**, **NSGs**, and **Azure Firewall** to ensure secure communication between resources.
   - **Identity**: Handles the identity and access management services

*Download a [Visio diagram](https://github.com/Azure/avdaccelerator/raw/main/workload/docs/diagrams/avd-accelerator-baseline-architecture.vsdx) of this architecture*



### Benefits of Using the AVD Landing Zone Accelerator

1. **Scalability**: The accelerator helps set up an architecture that can scale with your organization's needs.
2. **Security**: Implements enterprise-grade security, compliance, and governance controls to protect your environment.
3. **Faster Deployment**: Predefined templates, configurations, and best practices ensure faster and more reliable deployments.
4. **Best Practices Compliance**: The architecture follows the best practices laid out in the Cloud Adoption Framework , ensuring a robust deployment.

### Next Steps

1. **Review Prerequisites**: Make sure to check the baseline deployment prerequisites to ensure your environment is ready.
2. **Deploy the Platform Landing Zone**: Start by deploying the platform landing zone to set up the foundational components.
3. **Use the AVD LZA**: Once the platform landing zone is in place, deploy the Azure Virtual Desktop Landing Zone Accelerator to implement the reference architecture.

For detailed guidance, refer to the full [Enterprise-Scale Landing Zone for Azure Virtual Desktop documentation](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone).



### Accelerator overview

The ![GitHub logo](../../_images/github.png) [Azure Virtual Desktop landing zone accelerator](https://github.com/Azure/avdaccelerator) supports multiple deployment scenarios depending on your requirements. Each deployment scenario supports both greenfield and brownfield deployments, and provides multiple IaC template options:

- Azure portal UI (ARM template)
- Azure CLI or Azure PowerShell (Bicep/ARM template)
- Terraform template

The accelerator uses resource naming automation based on the following recommendations:
- [Microsoft Cloud Adoption Framework (CAF) best practices for naming convention](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- The [recommended abbreviations for Azure resource types](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- The [minimum suggested tags](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging#minimum-suggested-tags). 

Before proceeding with the deployment scenarios, familiarize yourself with the Azure resource [naming, tagging, and organization](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/resource-naming.md) used by the accelerator: 

:::image type="content" source="https://raw.githubusercontent.com/Azure/avdaccelerator/main/workload/docs/diagrams/avd-accelerator-resource-organization-naming.png" alt-text="Diagram showing organization and naming of Azure resources deployed by the Azure Virtual Desktop landing zone accelerator." border="false" lightbox="https://raw.githubusercontent.com/Azure/avdaccelerator/main/workload/docs/diagrams/avd-accelerator-resource-organization-naming.png" :::

*Download a [full-sized image of this diagram](https://raw.githubusercontent.com/Azure/avdaccelerator/main/workload/docs/diagrams/avd-accelerator-resource-organization-naming.png)*

#### Accelerator deployment

To continue with deployment, choose the following deployment scenario tab that best matches your requirements:

# [Baseline deployment](#tab/baseline)
The baseline deployment deploys the Azure Virtual Desktop resources and dependent services that allow you to establish an Azure Virtual Desktop baseline. 

This deployment scenario includes the following items:

- [Azure Virtual Desktop](/azure/virtual-desktop/overview) resources, including one workspace, two application groups, a scaling plan, a host pool, and session host virtual machines
- An [Azure Files share](/azure/storage/files/files-smb-protocol) integrated with your identity service
- [Azure Key Vault](/azure/key-vault/general/overview) for secret, key, and certificate management
- Optionally, a new [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) with baseline Network Security Groups (NSG), Application Security Groups (ASG), and route tables

When you're ready for deployment, complete the following steps:
1. Review the [get started](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-baseline.md) document for details on prerequisites, planning information, and a discussion on what is deployed. 
1. Optionally, refer to the **Custom image build deployment** tab to build an updated image for your Azure Virtual Desktop host sessions. 
2. Continue with the [baseline deployment steps](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/deploy-baseline.md). If you created a custom Azure Compute Gallery image in the previous step, be sure to select "Compute gallery" for **OS image source** and select the correct **Image** on the **Session hosts** page:

   :::image type="content" source="./media/portal-session-hosts-os-selection.png" alt-text="Screen shot of OS selection field on sessions hosts page in the Azure portal." border="false" lightbox="./media/portal-session-hosts-os-selection.png" :::


# [Custom image build deployment](#tab/custom-image)
The optional custom image build creates a new image from Azure Marketplace in an Azure compute gallery, optimized, patched and ready to be used. This deployment is optional and can be customized to extend functionality, like adding scripts to further customize your images. 

The following images are currently offered:

- Windows 10 21H2
- Windows 10 22H2 (Gen 2)
- Windows 11 21H2 (Gen 2)
- Windows 11 22H2 (Gen 2)
- Windows 10 21H2 with Microsoft 365
- Windows 10 22H2 with Microsoft 365 (Gen 2)
- Windows 11 21H2 with Microsoft 365 (Gen 2)
- Windows 11 22H2 with Microsoft 365 (Gen 2)

You can also opt to enable the Trusted Launch or Confidential VM security type feature on the Azure Compute Gallery image definition. A custom image is optimized using [Virtual Desktop Optimization Tool (VDOT)](https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool) and patched with the latest Windows updates.

When you're ready for deployment, complete the following steps:
1. Review the [get started](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-custom-image-build.md) document for details on prerequisites, planning information, and a discussion on what is deployed. 
1. Continue with the [custom image build deployment steps](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/deploy-custom-image.md).

---


