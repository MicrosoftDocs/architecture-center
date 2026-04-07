---
title: Get Started with Virtual Desktop Architecture Design
description: Get an overview of Azure virtual desktop technologies and cloud desktop design, including architecture guidance, solution ideas, and reference architectures.
ms.author: anaharris
author: anaharris-ms
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.date: 03/26/2026
ai-usage: ai-assisted
---

# Get started with virtual desktop architecture design

Migrating user desktops to the cloud helps improve employee productivity so that employees can work from anywhere on a high-security cloud-based virtual desktop infrastructure. Azure provides several virtual desktop solutions to meet different organizational needs:

- [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/): A desktop and application virtualization service that runs on Azure. It provides multisession Windows desktops and published applications, with simplified management and scaling.

- [Windows 365](https://www.microsoft.com/windows-365): A cloud-based service that automatically creates Cloud PCs for your users. Windows 365 assigns each Cloud PC to an individual user as their dedicated Windows device. Windows 365 is evolving to include developer-focused capabilities that Microsoft Dev Box previously offered. It provides a single platform for cloud desktops across information workers and developers. For more information, see [Dev Box capabilities unified into Windows 365](/azure/dev-box/dev-box-windows-365-announcement).

- [Omnissa Horizon Cloud on Microsoft Azure](https://www.omnissa.com/products/horizon-cloud/): An Omnissa service that simplifies the delivery of virtual desktops and applications on Azure by extending Azure Virtual Desktop.

- [Citrix Virtual Apps and Desktops for Azure](https://docs.citrix.com/en-us/citrix-virtual-apps-desktops.html): A desktop and app virtualization service that you can use to provision Windows desktops and apps on Azure with Citrix and Azure Virtual Desktop.

## Architecture

This section outlines virtual desktop architecture on Azure and shows how the key stages of a virtual desktop solution journey connect from initial learning through production deployment.

:::image type="complex" border="false" source="images/virtual-desktop-get-started-diagram.svg" alt-text="Diagram that shows the virtual desktop solution journey on Azure." lightbox="images/virtual-desktop-get-started-diagram.svg":::
   The architecture includes hub-and-spoke virtual networks with connectivity via Azure ExpressRoute, identity components with Microsoft Entra ID and Active Directory Domain Services (AD DS), Azure Virtual Desktop host pools with session hosts, endpoint devices, storage solutions (Azure Files and Azure NetApp Files), and monitoring with Log Analytics.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-desktop-get-started-diagram.vsdx) of this architecture.*

The previous diagram demonstrates a typical basic or baseline virtual desktop implementation. For real-world solutions that you can build in Azure, see [Virtual desktop architectures](#virtual-desktop-architectures).

## Explore virtual desktop architectures and guides

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions and guides. These articles can help you decide how to use virtual desktop technologies in Azure. Solution ideas demonstrate implementation patterns and possibilities to consider as you plan your virtual desktop proof-of-concept (POC) development.

### Virtual desktop guides

**Technology choices:** The following articles help you evaluate and select the best virtual desktop technologies for your workload requirements:

- [Azure Virtual Desktop landing zone design guide](../landing-zones/azure-virtual-desktop/design-guide.md): Plan and design your [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) deployment aligned with Azure landing zone principles.

- [Windows 365 Azure network connection](windows-365-azure-network-connection.md): Design and implement [Windows 365](https://www.microsoft.com/windows-365) Azure network connections to integrate Cloud PCs with your existing network infrastructure.

- [Multiregion business continuity and disaster recovery (BCDR) for Azure Virtual Desktop](../example-scenario/azure-virtual-desktop/azure-virtual-desktop-multi-region-bcdr.md): Design a multiregion BCDR strategy for Azure Virtual Desktop to provide high availability and resilience.

### Virtual desktop architectures

The following production-ready architectures demonstrate end-to-end virtual desktop solutions that you can deploy and customize:

- [Deploy Esri ArcGIS Pro in Azure Virtual Desktop](../example-scenario/data/esri-arcgis-azure-virtual-desktop.yml): Deploy Esri ArcGIS Pro in [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) to take advantage of the hyperscale capabilities of Azure. This architecture includes back-end components like ArcGIS Enterprise and supports GPU-enabled virtual machines (VMs) for demanding 2D and 3D geographic information system (GIS) workflows.

## Learn about virtual desktop on Azure

[Microsoft Learn](/training/?WT.mc_id=learnaka) provides free online training resources for Azure virtual desktop technologies. The platform offers videos, tutorials, and interactive labs for specific products and services, along with learning paths organized by job role.

The following resources provide foundational knowledge for virtual desktop implementations on Azure.

**Azure Virtual Desktop:** Use the following resources to build core Azure Virtual Desktop knowledge.

- [Deliver remote desktops and apps by using Azure Virtual Desktop](/training/paths/m365-wvd/): Learn the fundamentals of planning and deploying [Azure Virtual Desktop](/azure/virtual-desktop/overview).

- [Implement an Azure Virtual Desktop infrastructure](/training/paths/implement-azure-virtual-infrastructure/): Develop skills for implementing and managing [Azure Virtual Desktop](/azure/virtual-desktop/overview) infrastructure.

- [Monitor and maintain an Azure Virtual Desktop infrastructure](/training/paths/monitor-maintain-azure-virtual-desktop-infrastructure/): Learn how to monitor, maintain, and optimize [Azure Virtual Desktop](/azure/virtual-desktop/overview) environments.

- [Examine Windows 365](/training/modules/examine-windows-365/): Learn the basics of [Windows 365](https://www.microsoft.com/windows-365) Cloud PCs, including editions, architecture, life cycle, and how they integrate with your environment. Windows 365 provides single-user virtual desktops as an alternative to the multisession model in Azure Virtual Desktop.

## Organizational readiness

Organizations that start their cloud adoption can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption. For cloud-scale virtual desktop guidance, see [Cloud-scale analytics](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics).

Key [Cloud Adoption Framework](/azure/cloud-adoption-framework/) resources for virtual desktop:

- [Azure Virtual Desktop planning](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/plan): Plan your [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) migration or deployment.

- [Azure Virtual Desktop Azure landing zone review](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/ready): Review your Azure landing zone readiness for Azure Virtual Desktop.

To help ensure the quality of your virtual desktop solution on Azure, follow the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions.

For virtual desktop-specific guidance, see [Azure Virtual Desktop workloads](/azure/well-architected/azure-virtual-desktop/overview).

## Best practices

To implement virtual desktop solutions, focus on security, performance, and cost management. The following resources provide guidance about best practices for your [Azure Virtual Desktop](/azure/virtual-desktop/overview) environment:

- [Security recommendations for Azure Virtual Desktop](/azure/virtual-desktop/security-recommendations): Follow security recommendations to protect your Azure Virtual Desktop environment.

- [Azure security baseline for Azure Virtual Desktop](/security/benchmark/azure/baselines/azure-virtual-desktop-security-baseline): Apply the Microsoft cloud security benchmark to Azure Virtual Desktop.

- [Session host VM sizing guidelines](/windows-server/remote/remote-desktop-services/session-host-virtual-machine-sizing-guidelines): Select the appropriate VM sizes for your session host workloads.

- [Peripheral and resource redirection over the Remote Desktop Protocol (RDP)](/azure/virtual-desktop/redirection-remote-desktop-protocol): Learn which local devices and peripherals users can access in their Azure Virtual Desktop remote sessions, including redirection methods and supported resource types.

- [Create and assign an autoscale scaling plan for Azure Virtual Desktop](/azure/virtual-desktop/autoscale-create-assign-scaling-plan): Use the native autoscale feature to automatically scale session host VMs in and out based on scaling schedules. This approach optimizes costs and performance for pooled and personal host pools.

## Operations guide

Workload deployment on Azure marks a significant milestone, and [day-2 operations](https://dzone.com/articles/defining-day-2-operations) become critical.

Focus on the following key operational areas:

- [Turn on Insights to monitor Azure Virtual Desktop](/azure/virtual-desktop/insights): Use [Azure Virtual Desktop](/azure/virtual-desktop/overview) Insights to track the health, performance, and usage of your Azure Virtual Desktop environment.

- [Create and assign an autoscale scaling plan for Azure Virtual Desktop](/azure/virtual-desktop/autoscale-create-assign-scaling-plan): Use the native autoscale feature to automatically scale session host VMs in and out based on a scaling schedule. This approach optimizes costs and performance.

- [Session host VM sizing guidelines](/windows-server/remote/remote-desktop-services/session-host-virtual-machine-sizing-guidelines): Select the appropriate VM sizes for your session host workloads.

- [Set up device redirection](/azure/virtual-desktop/redirection-remote-desktop-protocol): Set up which local devices users can access in their remote sessions.

- [Monitor and maintain an Azure Virtual Desktop infrastructure](/training/paths/monitor-maintain-azure-virtual-desktop-infrastructure/): Learn how to plan for DR, set up automation, and optimize session host capacity for [Azure Virtual Desktop](/azure/virtual-desktop/overview).

- [BCDR for Azure Virtual Desktop](../example-scenario/azure-virtual-desktop/azure-virtual-desktop-multi-region-bcdr.md): Design a multiregion BCDR strategy for [Azure Virtual Desktop](/azure/virtual-desktop/overview) to provide high availability and resilience.

## Stay current with virtual desktops

Azure virtual desktop services evolve to address modern data challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/).

To stay current with key virtual desktop services, see the following articles:

- [What's new in Azure Virtual Desktop](/azure/virtual-desktop/whats-new): Learn about new features and improvements in [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/).

- [What's new in Windows 365 Enterprise and Frontline](/windows-365/enterprise/whats-new): Stay updated on [Windows 365](https://www.microsoft.com/windows-365) Cloud PC features, including virtual desktop capabilities for information workers and developers.

## Other resources

The virtual desktop category covers a range of solutions. The following resources can help you discover more about Azure.

### Identity

Authentication and identity underpin any virtual desktop deployment:

- [Supported identities and authentication methods](/azure/virtual-desktop/authentication): Learn how [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) authentication works.

- [Microsoft Entra joined session hosts in Azure Virtual Desktop](/azure/virtual-desktop/azure-ad-joined-session-hosts): Deploy session hosts that use [Microsoft Entra ID](/entra/fundamentals/what-is-entra) for authentication.

- [Compare self-managed Active Directory Domain Services, Microsoft Entra ID, and managed Microsoft Entra Domain Services](/entra/identity/domain-services/compare-identity-solutions): Compare identity solutions to determine the right fit for your virtual desktop environment.

### FSLogix

[FSLogix](/fslogix/overview-what-is-fslogix) supports roaming profiles in remote computing environments like Azure Virtual Desktop. It stores a complete user profile in a single container. At sign-in, FSLogix dynamically attaches this container to the computing environment:

- [FSLogix configuration examples](/fslogix/concepts-configuration-examples): Review configuration examples for FSLogix profile containers.

- [FSLogix profile containers and Azure Files](/azure/virtual-desktop/fslogix-profile-containers): Use [Azure Files](/azure/storage/files/storage-files-introduction) as a storage solution for FSLogix profile containers.

- [Storage options for FSLogix profile containers in Azure Virtual Desktop](/azure/virtual-desktop/store-fslogix-profile): Compare storage options for FSLogix profile containers.

### Networking

Network connectivity is a key consideration for virtual desktop deployments:

- [Azure Virtual Desktop network connectivity](/azure/virtual-desktop/network-connectivity): Review a high-level overview of the network connections that Azure Virtual Desktop uses.

- [RDP Shortpath for Azure Virtual Desktop](/azure/virtual-desktop/rdp-shortpath): Set up RDP Shortpath to establish a direct User Datagram Protocol (UDP)-based transport between a client and session host.

### Hybrid

Most organizations need a hybrid approach to virtual desktops because they integrate cloud-based virtual desktops with on-premises infrastructure. Azure Virtual Desktop supports hybrid deployment scenarios that extend virtual desktop capabilities to on-premises environments. To connect environments, organizations must [choose a hybrid network architecture](/azure/architecture/reference-architectures/hybrid-networking/).

- [Azure Virtual Desktop for Azure Local](../hybrid/azure-local-workload-virtual-desktop.yml): Deploy Azure Virtual Desktop on [Azure Local](/azure/azure-local/overview) hardware for scenarios that require on-premises data residency or low-latency connectivity.

## Amazon Web Services (AWS) or Google Cloud professionals

To help you ramp up quickly, the following articles compare Azure virtual desktop options to other cloud services.

- [AWS to Azure services comparison - User computing](../aws-professional/index.md#end-user-computing)
- [Google Cloud to Azure services comparison](../gcp-professional/services.md)
