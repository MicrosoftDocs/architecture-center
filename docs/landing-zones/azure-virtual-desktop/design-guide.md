---
title: Azure landing zones - Azure Virtual Desktop landing zone design considerations
description: Design considerations for using the enterprise-scale Azure Virtual Desktop landing zone, which is part of the Cloud Adoption Framework for Azure.
author: BryanLa
categories:
  - azure-virtual-desktop
  - management-and-governance
  - migration
  - networking
  - security
ms.author: bryanla
ms.date: 04/19/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
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

This article provides a design-oriented overview of the [enterprise-scale landing zone for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/wvd/enterprise-scale-landing-zone), for architects and technical decision makers. The goal is to help you quickly gain an understanding of the accelerator and how it's designed, allowing you to shorten the time required to complete a successful deployment.

## Landing zone concepts

[!INCLUDE [Landing zone concepts](../includes/concepts.md)]

## Reference architecture

The [enterprise-scale landing zone for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/wvd/enterprise-scale-landing-zone) is part of the "Desktop virtualization" scenario article series in the Azure Cloud Adoption Framework. The series provides compatibility requirements, design principles, and deployment guidance for the landing zone. They also serve as the reference architecture for an enterprise-scale implementation, ensuring the environment is capable of hosting desktops and any supporting workloads.

:::image type="content" source="./media/azure-virtual-desktop-reference-architecture.png" alt-text="Diagram of reference architecture required for Azure Virtual Desktop landing zone implementations." border="false" lightbox="./media/azure-virtual-desktop-reference-architecture.png" :::

#### Design principles

Like other landing zones, the enterprise-scale Azure Virtual Desktop landing zone was designed using a core set of [Cloud Adoption Framework design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) and guided by common [design areas](/azure/cloud-adoption-framework/ready/landing-zone/design-areas).

Design areas for the Azure Virtual Desktop landing zone are indicated with letters "A" through "J" in the diagram, to illustrate the hierarchy of resource organization:

| Legend | Design area | Objective |
|--------|-------------|-----------|
| A | [Enterprise enrollment](/azure/cloud-adoption-framework/scenarios/wvd/eslz-enterprise-enrollment)	| Proper tenant creation, enrollment, and billing setup are important early steps. |
| B, G | [Identity and access management](/azure/cloud-adoption-framework/scenarios/wvd/eslz-identity-and-access-management) | Identity and access management is a primary security boundary in the public cloud. It's the foundation for any secure and fully compliant architecture. |
| C-H, J | [Resource organization](/azure/cloud-adoption-framework/scenarios/wvd/eslz-resource-organization) |	As cloud adoption scales, considerations for subscription design and management group hierarchy have an impact on governance, operations management, and adoption patterns. |
| C-H, J | [Management and monitoring](/azure/cloud-adoption-framework/scenarios/wvd/eslz-management-and-monitoring) | For stable, ongoing operations in the cloud, a management baseline is required to provide visibility, operations compliance, and protect and recover capabilities. |
| E, F | [Network topology and connectivity](/azure/cloud-adoption-framework/scenarios/wvd/eslz-network-topology-and-connectivity) | Networking and connectivity decisions are an equally important foundational aspect of any cloud architecture. |
| G, F, J | [Business continuity and disaster recovery](/azure/cloud-adoption-framework/scenarios/wvd/eslz-business-continuity-and-disaster-recovery) | Automate auditing and enforcement of governance policies. |
| F, J | [Security governance and compliance](/azure/cloud-adoption-framework/scenarios/wvd/eslz-security-governance-and-compliance) | Implement controls and processes to protect your cloud environments. |
| I |  [Platform automation and DevOps](/azure/cloud-adoption-framework/scenarios/wvd/eslz-platform-automation-and-devops) | Align the best tools and templates to deploy your landing zones and supporting resources. |

## Reference implementation

The Azure Virtual Desktop landing zone accelerator deploys resources for an enterprise-scale reference implementation of Azure Virtual Desktop. This implementation is based on the reference architecture discussed in the previous section.

#### Architecture

> [!IMPORTANT]
> The accelerator deploys resources into the Azure Virtual Desktop landing zone subscriptions identified in the following architecture diagram: **AVD LZ Subscription**, and **AVD Shared Services LZ Subscription**. 
> 
> **We strongly recommend deployment of the appropriate [Cloud Adoption Framework platform landing zone](/azure/cloud-adoption-framework/ready/enterprise-scale/implementation#reference-implementation) first, to provide the enterprise-scale foundation services required by the resources deployed by the accelerator.** Refer to the [baseline deployment prerequisites](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-baseline.md#prerequisites) to review the full set of prerequisites and requirements for the accelerator.

:::image type="content" source="https://raw.githubusercontent.com/Azure/avdaccelerator/main/workload/docs/diagrams/avd-accelerator-baseline-architecture.png" alt-text="Diagram of reference implementation created by Azure Virtual Desktop landing zone accelerator." border="false" lightbox="https://raw.githubusercontent.com/Azure/avdaccelerator/main/workload/docs/diagrams/avd-accelerator-baseline-architecture.png" :::

*Download a [Visio diagram](https://github.com/Azure/avdaccelerator/raw/main/workload/docs/diagrams/avd-accelerator-baseline-architecture.vsdx) of this architecture*

#### Accelerator overview

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
1. Optionally, refer to the **Custom image build deployment** tab to build an updated image for your Azure Virtual Desktop host sessions. Then reference your custom image from the Azure Compute Gallery in the next step, when prompted for the "Session host - OS selection" in the Azure portal:
  :::image type="content" source="./media/portal-session-hosts-os-selection.png" alt-text="Screen shot of OS selection field on sessions hosts portal blade." border="false" lightbox="./media/portal-session-hosts-os-selection.png" :::
2. Continue with the [baseline deployment steps](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/deploy-baseline.md).


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


