---
title: Virtual desktop architecture design
description: Get an overview of Azure virtual desktop technologies, guidance offerings, solution ideas, and reference architectures.
author: anaharris-ms
ms.author: pnp
ms.date: 02/13/2026
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted

---

# Get started with virtual desktop architecture design

Migrating end-user desktops to the cloud helps improve employee productivity and enables employees to work from anywhere on a high-security cloud-based virtual desktop infrastructure. Azure provides several virtual desktop solutions to meet different organizational needs:

- [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/): A desktop and application virtualization service that runs on Azure. It provides multi-session Windows desktops and published applications, with simplified management and scaling.
- [Windows 365](https://www.microsoft.com/windows-365): A cloud-based service that automatically creates Cloud PCs for your end users. Each Cloud PC is assigned to an individual user and is their dedicated Windows device. Windows 365 is evolving to include developer-focused capabilities formerly offered through Microsoft Dev Box, providing a single platform for cloud desktops across information workers and developers. For more information, see [Dev Box capabilities unified into Windows 365](/azure/dev-box/dev-box-windows-365-announcement).
- [Omnissa Horizon Cloud on Microsoft Azure](https://www.omnissa.com/products/horizon-cloud/): An Omnissa service that simplifies the delivery of virtual desktops and applications on Azure by extending Azure Virtual Desktop.
- [Citrix Virtual Apps and Desktops for Azure](https://docs.citrix.com/en-us/citrix-virtual-apps-desktops.html): A desktop and app virtualization service that you can use to provision Windows desktops and apps on Azure with Citrix and Azure Virtual Desktop.

## Architecture

This section provides an overview of the virtual desktop architecture on Azure, showing how the key stages of a virtual desktop solution journey connect — from initial learning through production deployment.

:::image type="complex" border="false" source="images/virtual-desktop-get-started-diagram.svg" alt-text="Diagram that shows the virtual desktop solution journey on Azure." lightbox="images/virtual-desktop-get-started-diagram.svg":::
   Diagram showing the solution journey for virtual desktops on Azure. The journey starts with learning and organizational readiness, then moves to choosing appropriate Azure services, followed by implementation best practices and production deployment.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-desktop-get-started-diagram.vsdx) of this architecture.*

The diagram above demonstrates a typical basic/baseline virtual desktop implementation. Refer to the [architectures](#explore-virtual-desktop-architectures-and-guides) section to find real-world solutions that you can build in Azure.

## Explore virtual desktop architectures and guides

The following articles include fully developed architectures that you can deploy in Azure and expand to production-grade solutions, along with guides to help you decide how to use virtual desktop technologies in Azure.

### Virtual desktop guides

These guides help you plan, design, and implement virtual desktop solutions in Azure:

- **[Azure Virtual Desktop landing zone design guide](/azure/architecture/landing-zones/azure-virtual-desktop/design-guide)**: Plan and design your [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) deployment aligned with Azure landing zone principles.
- **[Windows 365 Azure network connection](/azure/architecture/guide/virtual-desktop/windows-365-azure-network-connection)**: Design and implement [Windows 365](https://www.microsoft.com/windows-365) Azure network connections to integrate Cloud PCs with your existing network infrastructure.
- **[Multiregion Business Continuity and Disaster Recovery (BCDR) for Azure Virtual Desktop](/azure/architecture/example-scenario/azure-virtual-desktop/azure-virtual-desktop-multi-region-bcdr)**: Design a multiregion BCDR strategy for [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) to provide high availability and resilience.

### Virtual desktop architectures

These production-ready architectures demonstrate end-to-end virtual desktop solutions that you can deploy and customize:

- **[Deploy Esri ArcGIS Pro in Azure Virtual Desktop](/azure/architecture/example-scenario/data/esri-arcgis-azure-virtual-desktop)**: Deploy Esri ArcGIS Pro in [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) to take advantage of Azure's hyperscale capabilities. This architecture includes back-end components like ArcGIS Enterprise and supports GPU-enabled VMs for demanding 2D and 3D GIS workflows.

## Learn about virtual desktop on Azure

[Microsoft Learn](/training/) provides free online training resources for Azure virtual desktop technologies. The platform offers videos, tutorials, and hands-on labs for specific products and services, along with learning paths organized by job role.

The following resources provide foundational knowledge for virtual desktop implementations on Azure:

**[Azure Virtual Desktop](/azure/virtual-desktop/overview):** Learn how to plan, deploy, and manage [Azure Virtual Desktop](/azure/virtual-desktop/overview) environments:

- **[Deliver remote desktops and apps with Azure Virtual Desktop](/training/paths/m365-wvd)**: Learn the fundamentals of planning and deploying [Azure Virtual Desktop](/azure/virtual-desktop/overview).
- **[Implement an Azure Virtual Desktop infrastructure](/training/paths/implement-azure-virtual-infrastructure/)**: Develop skills for implementing and managing [Azure Virtual Desktop](/azure/virtual-desktop/overview) infrastructure.
- **[Monitor and maintain an Azure Virtual Desktop infrastructure](/training/paths/monitor-maintain-azure-virtual-desktop-infrastructure/)**: Learn how to monitor, maintain, and optimize [Azure Virtual Desktop](/azure/virtual-desktop/overview) environments.
- **[Examine Windows 365](/training/modules/examine-windows-365/)**: Understand the basics of [Windows 365](https://www.microsoft.com/windows-365) Cloud PCs, including editions, architecture, lifecycle, and how they integrate with your environment. Windows 365 provides single-user virtual desktops as an alternative to Azure Virtual Desktop's multi-session model.

## Organizational readiness

Organizations that are beginning their cloud adoption can use the [Cloud Adoption Framework](/azure/cloud-adoption-framework/) for proven guidance designed to accelerate cloud adoption. For virtual desktop migration and deployment guidance, see [Migrate end-user desktops to Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop).

Key [Cloud Adoption Framework](/azure/cloud-adoption-framework/) resources for virtual desktop:

- [Azure Virtual Desktop planning](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/plan): Plan your [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) migration or deployment.
- [Azure Virtual Desktop Azure landing zone review](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/ready): Review your Azure landing zone readiness for [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/).

To help assure the quality of your virtual desktop solution on Azure, we recommend following the [Azure Well-Architected Framework (WAF)](/azure/well-architected/). WAF provides prescriptive guidance for organizations seeking architectural excellence and discusses how to design, provision, and monitor cost-optimized Azure solutions. For virtual desktop-specific guidance, see [Azure Virtual Desktop workloads](/azure/well-architected/azure-virtual-desktop/overview).

## Best practices

Implementing virtual desktop solutions requires attention to security, performance, and cost management. The following resources provide guidance on best practices for your [Azure Virtual Desktop](/azure/virtual-desktop/overview) environment:

- [Security recommendations for Azure Virtual Desktop](/azure/virtual-desktop/security-recommendations): Follow security recommendations to protect your [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) environment.
- [Azure security baseline for Azure Virtual Desktop](/security/benchmark/azure/baselines/azure-virtual-desktop-security-baseline): Apply the Microsoft cloud security benchmark to [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/).
- [Session host virtual machine sizing guidelines](/windows-server/remote/remote-desktop-services/session-host-virtual-machine-sizing-guidelines): Select the appropriate virtual machine sizes for your session host workloads.
- [Peripheral and resource redirection over the Remote Desktop Protocol](/azure/virtual-desktop/redirection-remote-desktop-protocol): Understand which local devices and peripherals users can access in their [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) remote sessions, including redirection methods and supported resource types.
- [Autoscale scaling plans and example scenarios in Azure Virtual Desktop](/azure/virtual-desktop/autoscale-scaling-plan): Use the native Autoscale feature to automatically scale session host VMs in and out based on scaling schedules, optimizing costs and performance for pooled and personal host pools.

## Operations guide

Deploying your workload on Azure is a significant milestone, and this is when [day-2 operations](https://dzone.com/articles/defining-day-2-operations) become critical. <!-- The source document links "day-2 operations" to an external non-Microsoft URL (dzone.com/articles/defining-day-2-operations). This URL could not be verified — the fetch returned no content. The link may be broken, moved, or behind authentication. Additionally, this is a non-Microsoft external link in Microsoft Learn documentation. Do you want to keep this external link, replace it with a Microsoft Learn resource (such as the Cloud Adoption Framework Manage methodology at /azure/cloud-adoption-framework/manage/), or remove the hyperlink and keep "day-2 operations" as plain descriptive text? -->

Key operational areas for your [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) environment:

- [Enable Insights to monitor Azure Virtual Desktop](/azure/virtual-desktop/insights): Use [Azure Virtual Desktop](/azure/virtual-desktop/overview) Insights to track the health, performance, and usage of your Azure Virtual Desktop environment.
- [Autoscale scaling plans and example scenarios in Azure Virtual Desktop](/azure/virtual-desktop/autoscale-scaling-plan): Use the native Autoscale feature to automatically scale session host VMs in and out based on a scaling schedule, optimizing costs and performance.
- [Session host virtual machine sizing guidelines](/windows-server/remote/remote-desktop-services/session-host-virtual-machine-sizing-guidelines): Select the appropriate virtual machine sizes for your session host workloads.
- [Configure device redirection](/azure/virtual-desktop/redirection-remote-desktop-protocol): Configure which local devices users can access in their remote sessions.
- [Monitor and maintain an Azure Virtual Desktop infrastructure](/training/paths/monitor-maintain-azure-virtual-desktop-infrastructure/): Learn how to plan for disaster recovery, configure automation, and optimize session host capacity for [Azure Virtual Desktop](/azure/virtual-desktop/overview).
- [Multiregion Business Continuity and Disaster Recovery (BCDR) for Azure Virtual Desktop](/azure/architecture/example-scenario/azure-virtual-desktop/azure-virtual-desktop-multi-region-bcdr): Design a multiregion BCDR strategy for [Azure Virtual Desktop](/azure/virtual-desktop/overview) to provide high availability and resilience.

## Stay current with virtual desktop

Azure virtual desktop services are evolving to address modern workforce computing challenges. You can get the latest updates on [Azure products and features](https://azure.microsoft.com/updates/).

To stay current with key virtual desktop services, see:

- [What's new in Azure Virtual Desktop](/azure/virtual-desktop/whats-new): Learn about new features and improvements in [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/).
- [What's new in Windows 365 Enterprise and Frontline](/windows-365/enterprise/whats-new): Stay updated on [Windows 365](https://www.microsoft.com/windows-365) Cloud PC features, including virtual desktop capabilities for information workers and developers.

## Other resources

Virtual desktop is a broad category that covers a range of solutions. The following resources can help you discover more about [Azure Virtual Desktop](/azure/virtual-desktop/overview) capabilities across identity, user profiles, networking, and hybrid deployment scenarios.

### Identity

Authentication and identity are foundational to any virtual desktop deployment: 

- [Supported identities and authentication methods](/azure/virtual-desktop/authentication): Understand how [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) authentication works. 
- [Microsoft Entra joined session hosts in Azure Virtual Desktop](/azure/virtual-desktop/azure-ad-joined-session-hosts): Deploy session hosts that use [Microsoft Entra ID](/entra/fundamentals/whatis) for authentication. 
- [Compare self-managed Active Directory Domain Services, Microsoft Entra ID, and managed Microsoft Entra Domain Services](/entra/identity/domain-services/compare-identity-solutions): Compare identity solutions to determine the right fit for your virtual desktop environment. 

### FSLogix

[FSLogix](/fslogix/overview-what-is-fslogix) is designed for roaming profiles in remote computing environments like [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/). It stores a complete user profile in a single container. At sign-in, this container is dynamically attached to the computing environment: 

- [FSLogix configuration examples](/fslogix/concepts-configuration-examples): Review configuration examples for [FSLogix](/fslogix/overview-what-is-fslogix) profile containers. 
- [FSLogix profile containers and Azure Files](/azure/virtual-desktop/fslogix-profile-containers): Use [Azure Files](/azure/storage/files/storage-files-introduction) as a storage solution for [FSLogix](/fslogix/overview-what-is-fslogix) profile containers. 
- [Storage options for FSLogix profile containers in Azure Virtual Desktop](/azure/virtual-desktop/store-fslogix-profile): Compare storage options for [FSLogix](/fslogix/overview-what-is-fslogix) profile containers. 

### Networking

Network connectivity is a key consideration for virtual desktop deployments: 

- [Understanding Azure Virtual Desktop network connectivity](/azure/virtual-desktop/network-connectivity): Review a high-level overview of the network connections used by [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/). 
- [RDP Shortpath for Azure Virtual Desktop](/azure/virtual-desktop/rdp-shortpath): Configure RDP Shortpath to establish a direct UDP-based transport between a client and session host. 

### Hybrid

Organizations often need to integrate cloud-based virtual desktops with on-premises infrastructure. [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) supports hybrid deployment scenarios that extend virtual desktop capabilities to on-premises environments. To connect environments, organizations must [choose a hybrid network architecture](/azure/architecture/reference-architectures/hybrid-networking/index). 

- [Azure Virtual Desktop for Azure Local](/azure/architecture/hybrid/azure-local-workload-virtual-desktop): Deploy [Azure Virtual Desktop](https://azure.microsoft.com/products/virtual-desktop/) on [Azure Local](/azure/azure-local/overview) hardware for scenarios that require on-premises data residency or low-latency connectivity. 

## Amazon Web Services (AWS) or Google Cloud professionals

These articles can help you ramp up quickly by comparing Azure virtual desktop options to other cloud services: 

- [AWS to Azure services comparison - End-user computing](../aws-professional/index.md#end-user-computing) 
- [Google Cloud to Azure services comparison](../gcp-professional/services.md) 
