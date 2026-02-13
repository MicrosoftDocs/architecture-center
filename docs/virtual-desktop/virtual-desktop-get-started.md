---
title: Virtual desktop architecture design
description: Get an overview of Azure virtual desktop technologies, guidance offerings, solution ideas, and reference architectures.
author: claytonsiemens77
ms.author: pnp
ms.date: 02/13/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Virtual desktop architecture design

Migrating end-user desktops to the cloud helps improve employee productivity and enables employees to work from anywhere on a high-security cloud-based virtual desktop infrastructure. Azure provides several virtual desktop solutions to meet different organizational needs:

- [Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop) is a desktop and application virtualization service that runs on Azure. It provides multi-session Windows desktops and published applications, with simplified management and scaling.
- [Windows 365](https://www.microsoft.com/windows-365) is a cloud-based service that automatically creates Cloud PCs for your end users. Each Cloud PC is assigned to an individual user and is their dedicated Windows device.
- [Microsoft Dev Box](https://azure.microsoft.com/services/dev-box) is a service that gives developers access to ready-to-code, project-specific workstations that are preconfigured and centrally managed in the cloud.
- [Omnissa Horizon Cloud on Microsoft Azure](https://www.omnissa.com/products/horizon-cloud/) is an Omnissa service that simplifies the delivery of virtual desktops and applications on Azure by extending Azure Virtual Desktop.
- [Citrix Virtual Apps and Desktops for Azure](https://docs.citrix.com/en-us/citrix-virtual-apps-desktops.html) is a desktop and app virtualization service that you can use to provision Windows desktops and apps on Azure with Citrix and Azure Virtual Desktop.

## Architecture

<!-- [ISSUE: The architecture diagram file virtual-desktop-get-started-diagram.svg needs to be created and placed in docs/virtual-desktop/images/] -->
<!--
:::image type="complex" border="false" source="images/virtual-desktop-get-started-diagram.svg" alt-text="Diagram that shows the virtual desktop solution journey on Azure." lightbox="images/virtual-desktop-get-started-diagram.svg":::
   Diagram showing the solution journey for virtual desktops on Azure. The journey starts with learning and organizational readiness, then moves to choosing appropriate Azure services, followed by implementation best practices and production deployment.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/virtual-desktop-get-started-diagram.vsdx) of this architecture.*
-->

<!-- The diagram above demonstrates a typical basic/baseline virtual desktop implementation. Refer to the [architectures](#architectures) provided in this section to find real-world solutions that you can build in Azure. -->

## Explore virtual desktop architectures and guides

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions and guides. These can help you make important decisions about how you use virtual desktop technologies in Azure.

### Virtual desktop guides

- [Azure Virtual Desktop landing zone design guide](../../landing-zones/azure-virtual-desktop/design-guide.md) - Plan and design your Azure Virtual Desktop deployment aligned with Azure landing zone principles.
- [Windows 365 Azure network connection](windows-365-azure-network-connection.md) - Design and implement Windows 365 Azure network connections to integrate Cloud PCs with your existing network infrastructure.
- [Multiregion Business Continuity and Disaster Recovery (BCDR) for Azure Virtual Desktop](../../example-scenario/azure-virtual-desktop/azure-virtual-desktop-multi-region-bcdr.yml) - Design a multiregion BCDR strategy for Azure Virtual Desktop to provide high availability and resilience.

### Virtual desktop architectures

- [Deploy Esri ArcGIS Pro in Azure Virtual Desktop](../../example-scenario/data/esri-arcgis-azure-virtual-desktop.yml) - Run Esri ArcGIS Pro in Azure Virtual Desktop for GIS workloads that require GPU-accelerated virtual desktops.

## Learn about virtual desktops on Azure

[Microsoft Learn](/training/?WT.mc_id=learnaka) provides free online training resources for Azure virtual desktop technologies. The platform offers videos, tutorials, and hands-on labs for specific products and services, along with learning paths organized by job role.

The following resources provide foundational knowledge for virtual desktop implementations on Azure:

- [Deliver remote desktops and apps with Azure Virtual Desktop](/training/paths/m365-wvd) - Learn the fundamentals of planning and deploying Azure Virtual Desktop.
- [Deploy Azure Virtual Desktop](/training/paths/deploy-azure-virtual-desktop/) - Develop skills for deploying and managing Azure Virtual Desktop environments.
- [Manage Azure Virtual Desktop](/training/paths/manage-azure-virtual-desktop/) - Learn how to monitor, maintain, and optimize Azure Virtual Desktop.
- [Introduction to Windows 365](/training/modules/introduction-to-windows-365/) - Understand the basics of Windows 365 Cloud PCs and how they integrate with your environment.
- [Introduction to Microsoft Dev Box](/training/modules/introduction-to-microsoft-dev-box/) - Learn how Microsoft Dev Box provides self-service developer workstations.

## Organizational readiness

Organizations that are beginning their cloud adoption can use the [Cloud Adoption Framework](/azure/cloud-adoption-framework/) for proven guidance designed to accelerate cloud adoption. For virtual desktop migration and deployment guidance, see [Migrate or deploy Azure Virtual Desktop instances to Azure](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop).

Key Cloud Adoption Framework resources for virtual desktop:

- [Azure Virtual Desktop planning](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/plan) - Plan your Azure Virtual Desktop migration or deployment.
- [Azure Virtual Desktop Azure landing zone review](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/ready) - Review your Azure landing zone readiness for Azure Virtual Desktop.

To help assure the quality of your virtual desktop solution on Azure, we recommend following the [Azure Well-Architected Framework (WAF)](/azure/well-architected/). WAF provides prescriptive guidance for organizations seeking architectural excellence and discusses how to design, provision, and monitor cost-optimized Azure solutions. For virtual desktop-specific guidance, see the [Azure Well-Architected Framework perspective on Azure Virtual Desktop](/azure/well-architected/service-guides/azure-virtual-desktop).

## Best practices

Implementing virtual desktop solutions requires attention to security, performance, and cost management. The following resources provide guidance on best practices for your virtual desktop environment:

- [Security best practices for Azure Virtual Desktop](/azure/virtual-desktop/security-guide) - Follow security recommendations to protect your Azure Virtual Desktop environment.
- [Azure security baseline for Azure Virtual Desktop](/security/benchmark/azure/baselines/virtual-desktop-security-baseline) - Apply the Azure security benchmark to Azure Virtual Desktop.
- [Session host virtual machine sizing guidelines](/windows-server/remote/remote-desktop-services/virtual-machine-recs) - Select the appropriate virtual machine sizes for your session host workloads.
- [Configure device redirection](/azure/virtual-desktop/configure-device-redirections) - Configure which local devices users can access in their remote sessions.
- [Set up scaling tool using Azure Automation and Azure Logic Apps for Azure Virtual Desktop](/azure/virtual-desktop/set-up-scaling-script) - Automatically scale session host VMs based on demand to optimize costs.

## Stay current with virtual desktop technologies

Azure virtual desktop services are evolving to address modern workforce computing challenges. You can get the latest updates on [Azure products and features](https://azure.microsoft.com/updates/).

To stay current with key virtual desktop services, see:

- [What's new in Azure Virtual Desktop](/azure/virtual-desktop/whats-new) - Learn about new features and improvements in Azure Virtual Desktop.
- [What's new in Windows 365](/windows-365/whats-new) - Stay updated on Windows 365 capabilities.
- [What's new in Microsoft Dev Box](/azure/dev-box/whats-new) - Track the latest features in Microsoft Dev Box.

## Additional resources

Virtual desktop is a broad category and covers a range of solutions. The following resources can help you discover more about Azure.

### Identity

Authentication and identity are foundational to any virtual desktop deployment:

- [Authentication in Azure Virtual Desktop](/azure/virtual-desktop/authentication?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) - Understand how Azure Virtual Desktop authentication works.
- [Deploy Microsoft Entra joined virtual machines in Azure Virtual Desktop](/azure/virtual-desktop/azure-ad-joined-session-hosts?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) - Deploy session hosts that use Microsoft Entra ID for authentication.
- [Compare self-managed Active Directory Domain Services, Microsoft Entra ID, and managed Microsoft Entra Domain Services](/entra/identity/domain-services/compare-identity-solutions) - Compare identity solutions to determine the right fit for your virtual desktop environment.

### FSLogix

FSLogix is designed for roaming profiles in remote computing environments like Azure Virtual Desktop. It stores a complete user profile in a single container. At sign-in, this container is dynamically attached to the computing environment:

- [FSLogix configuration examples](/fslogix/concepts-configuration-examples) - Review configuration examples for FSLogix profile containers.
- [FSLogix profile containers and Azure Files](/azure/virtual-desktop/fslogix-containers-azure-files?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) - Use Azure Files as a storage solution for FSLogix profile containers.
- [Storage options for FSLogix profile containers in Azure Virtual Desktop](/azure/virtual-desktop/store-fslogix-profile?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) - Compare storage options for FSLogix profile containers.

### Networking

Network connectivity is a key consideration for virtual desktop deployments:

- [Understanding Azure Virtual Desktop network connectivity](/azure/virtual-desktop/network-connectivity?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) - Review a high-level overview of the network connections used by Azure Virtual Desktop.
- [Azure Virtual Desktop RDP Shortpath for managed networks](/azure/virtual-desktop/shortpath?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) - Configure RDP Shortpath to establish a direct UDP-based transport between a client and session host.

### Hybrid

Organizations often need to integrate cloud-based virtual desktops with on-premises infrastructure. Azure Virtual Desktop supports hybrid deployment scenarios that extend virtual desktop capabilities to on-premises environments. To connect environments, organizations must [choose a hybrid network architecture](../../reference-architectures/hybrid-networking/index.yml).

- [Azure Virtual Desktop for Azure Local](../../hybrid/azure-local-workload-virtual-desktop.yml) - Deploy Azure Virtual Desktop on Azure Local hardware for scenarios that require on-premises data residency or low-latency connectivity.

### AWS professionals

These articles can help you ramp up quickly by comparing Azure virtual desktop options to other cloud services:

- [AWS to Azure services comparison - End-user computing](../../aws-professional/index.md#end-user-computing)


