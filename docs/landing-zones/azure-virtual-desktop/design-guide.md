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
ms.date: 04/01/2023
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

This article provides a design-oriented overview of the [enterprise-scale landing zone for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/wvd/enterprise-scale-landing-zone) for architects and technical decision makers. The goal is to help you quickly gain an understanding of the accelerator and how it's designed, allowing you to shorten the time required to complete a successful deployment.

## Landing zone concepts

[!INCLUDE [Landing zone concepts](../includes/concepts.md)]

## Reference architecture

The [enterprise-scale landing zone for Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/wvd/enterprise-scale-landing-zone) outlines landing zone compatibility requirements, design principles, and deployment guidance. Essentially, this design serves as the reference architecture for an enterprise-scale implementation, ensuring the environment is capable of hosting desktops and any supporting workloads.

:::image type="content" source="./media/azure-virtual-desktop-reference-architecture.png" alt-text="Diagram of reference architecture required for Azure Virtual Desktop landing zone implementations." border="false" lightbox="./media/azure-virtual-desktop-reference-architecture.png" :::

#### Design principles

Like other landing zones, the enterprise-scale Azure Virtual Desktop landing zone was designed using a common set of [Cloud Adoption Framework design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles), and the [Azure Virtual Desktop landing zone compatibility guidelines](/azure/cloud-adoption-framework/scenarios/wvd/ready#evaluate-compatibility). The following principles are specific to the Azure Virtual Desktop landing zone, and split into two categories of design concerns, environment and compliance:

- Environment design principles
  - [Enterprise enrollment](/azure/cloud-adoption-framework/scenarios/wvd/eslz-enterprise-enrollment)
  - [Identity and access management](/azure/cloud-adoption-framework/scenarios/wvd/eslz-identity-and-access-management)
  - [Network topology and connectivity](/azure/cloud-adoption-framework/scenarios/wvd/eslz-network-topology-and-connectivity)
  - [Resource organization](/azure/cloud-adoption-framework/scenarios/wvd/eslz-resource-organization) 
- Compliance design principles
  - [Management and monitoring](/azure/cloud-adoption-framework/scenarios/wvd/eslz-management-and-monitoring)
  - [Business continuity and disaster recovery](/azure/cloud-adoption-framework/scenarios/wvd/eslz-business-continuity-and-disaster-recovery)
  - [Security governance and compliance](/azure/cloud-adoption-framework/scenarios/wvd/eslz-security-governance-and-compliance)
  - [Platform automation and DevOps](/azure/cloud-adoption-framework/scenarios/wvd/eslz-platform-automation-and-devops)

Design areas for these principles are indicated by letters "A" through "J" in the diagram, to illustrate the hierarchy of resource organization:

[!INCLUDE [Landing zone design areas](../includes/design-areas.md)]

## Reference implementation

The Azure Virtual Desktop landing zone accelerator deploys resources for an enterprise-scale reference implementation of Azure Virtual Desktop. This implementation is based on the reference architecture discussed in the previous section.

#### Architecture

> [!IMPORTANT]
> The accelerator deploys into the Azure Virtual Desktop landing zone subscriptions identified in the following architecture diagram. **It's recommended that an appropriate platform landing zone is already deployed, to provide the enterprise-scale foundation services required by the resources that the accelerator deploys.** Ideally, a platform reference implementation was deployed from the official set of [Cloud Adoption Framework platform landing zones](/azure/cloud-adoption-framework/ready/enterprise-scale/implementation#reference-implementation). Deploying one of the official platform landing zones will also ensure you're compliant with the deployment prerequisites discussed later.

:::image type="content" source="https://raw.githubusercontent.com/Azure/avdaccelerator/main/workload/docs/diagrams/avd-accelerator-baseline-architecture.png" alt-text="Diagram of reference implementation created by Azure Virtual Desktop landing zone accelerator." border="false" lightbox="https://raw.githubusercontent.com/Azure/avdaccelerator/main/workload/docs/diagrams/avd-accelerator-baseline-architecture.png" :::

*Download a [Visio diagram](https://github.com/Azure/avdaccelerator/raw/main/workload/docs/diagrams/avd-accelerator-baseline-architecture.vsdx) of this architecture*

#### Accelerator overview

The ![GitHub logo](../../_images/github.png) [Azure Virtual Desktop landing zone accelerator](https://github.com/Azure/avdaccelerator) supports multiple deployment scenarios depending on your requirements. Each deployment scenario supports both greenfield and brownfield deployments, and provides multiple IaC template options:

- Azure portal UI using ARM template
- Azure CLI or Azure PowerShell using Bicep/ARM template
- Terraform template

The accelerator uses resource naming automation based on the following recommendations:
- [Microsoft Cloud Adoption Framework (CAF) best practices for naming convention](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- The [recommended abbreviations for Azure resource types](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- The [minimum suggested tags](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging#minimum-suggested-tags). 

Before proceeding with the deployment scenarios, familiarize yourself with the Azure resource [naming, tagging, and hierarchy](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/resource-naming.md) used by the accelerator: 

:::image type="content" source="https://raw.githubusercontent.com/Azure/avdaccelerator/main/workload/docs/diagrams/avd-accelerator-resource-organization-naming.png" alt-text="Diagram showing organization and naming of Azure resources deployed by the Azure Virtual Desktop landing zone accelerator." border="false" lightbox="https://raw.githubusercontent.com/Azure/avdaccelerator/main/workload/docs/diagrams/avd-accelerator-resource-organization-naming.png" :::

*Download a [full-sized image of this diagram](https://raw.githubusercontent.com/Azure/avdaccelerator/main/workload/docs/diagrams/avd-accelerator-resource-organization-naming.png)*

#### Accelerator deployment

To continue with deployment, choose one of the following deployment scenario tabs that best matches your requirements:

# [Baseline deployment](#tab/baseline)
The baseline deployment deploys Azure Virtual Desktop resources and dependent services that allow you to establish a baseline, including the following items:

- Azure Virtual Desktop resources, including one workspace and two application groups and a host pool
- Azure Files share
- Integration with Azure Active Directory
- Session hosts
- Optionally, a new virtual network with baseline Network Security Group (NSG) and route table

When you're ready for deployment, complete the following steps:
1. Review the [Get started](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-baseline.md) document for details on prerequisites, planning information, and a discussion on what is deployed. 
2. Continue with [Deployment of the landing zone](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/deploy-baseline.md).

# [Custom image build deployment](#tab/custom-image)
The optional custom image build creates a new image from Azure Marketplace in an Azure compute gallery, optimized, patched and ready to be used. This deployment is optional and can be customized to extend functionality, like adding additional scripts to further customize your images. The following images are currently offered:

- Windows 10 21H2
- Windows 10 22H2 (Gen 2)
- Windows 11 21H2 (Gen 2)
- Windows 11 22H2 (Gen 2)
- Windows 10 21H2 with M365
- Windows 10 22H2 with M365 (Gen 2)
- Windows 11 21H2 with M365 (Gen 2)
- Windows 11 22H2 with M365 (Gen 2)

You can also opt to enable the Trusted Launch or Confidential VM security type feature on the Azure Compute Gallery image definition. A custom image is optimized using [Virtual Desktop Optimization Tool (VDOT)](https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool) and patched with the latest Windows updates.

When you're ready for deployment, complete the following steps:
1. Review the [Get started](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/getting-started-custom-image-build.md) document for details on prerequisites, planning information, and a discussion on what is deployed. 
2. Continue with [Deployment of the landing zone](https://github.com/Azure/avdaccelerator/blob/main/workload/docs/deploy-custom-image.md).

---


