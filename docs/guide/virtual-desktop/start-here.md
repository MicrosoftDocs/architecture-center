---
title: Virtual desktop architecture design
description: Get an overview of Azure virtual desktop technologies, guidance offerings, solution ideas, and reference architectures. 
author: EdPrice-MSFT
ms.author: architectures
ms.date: 08/29/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-virtual-desktop
  - azure-lab-services
categories:
  - azure-virtual-desktop
---

# Virtual desktop architecture design

Migrating end-user desktops to the cloud helps improve employee productivity and enables employees to work from anywhere on a high-security cloud-based virtual desktop infrastructure.

Azure provides these virtual desktop solutions:

- [Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop) is a desktop and application virtualization service.
- [VMware Horizon Cloud on Microsoft Azure](https://azure.microsoft.com/services/virtual-desktop/vmware-horizon-cloud) is a VMware service that simplifies the delivery of virtual desktops and applications on Azure by extending Azure Virtual Desktop.
- [Citrix Virtual Apps and Desktops for Azure](https://azure.microsoft.com/services/virtual-desktop/citrix-virtual-apps-desktops-for-azure) is a desktop and app virtualization service that you can use to provision Windows desktops and apps on Azure with Citrix and Azure Virtual Desktop.
- [Azure Lab Services](https://azure.microsoft.com/services/lab-services) provides computer labs in the cloud.
- [Microsoft Dev Box Preview](https://azure.microsoft.com/services/dev-box) is a service that gives developers access to ready-to-code, project-specific workstations that are preconfigured and centrally managed in the cloud.

## Introduction to virtual desktop architecture on Azure

If you're new to virtual desktops on Azure, the best way to learn more is with [Microsoft Learn](/learn/?WT.mc_id=learnaka), a free online training platform. 
Here's a learning path to get you started:

- [Deliver remote desktops and apps with Azure Virtual Desktop](https://docs.microsoft.com/learn/paths/m365-wvd)

## Path to production

Cloud Adoption Framework for Azure provides an end-to-end scenario to guide you through your virtual desktop migration or deployment. Start with 
[Migrate or deploy Azure Virtual Desktop instances to Azure](/azure/cloud-adoption-framework/scenarios/wvd), and check out the other articles in the table of contents.

These are two more key Cloud Adoption Framework articles:

- [Azure Virtual Desktop planning](/azure/cloud-adoption-framework/scenarios/wvd/plan)
- [Azure Virtual Desktop Azure landing zone review](/azure/cloud-adoption-framework/scenarios/wvd/ready)

See [Understanding Azure Virtual Desktop network connectivity](/azure/virtual-desktop/network-connectivity?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json) for a high-level overview of the network connections used by Azure Virtual Desktop.

For information about authentication and Azure Virtual Desktop, see [Authentication in Azure Virtual Desktop](/azure/virtual-desktop/authentication?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json) and [Azure AD join for Azure Virtual Desktop](/azure/architecture/example-scenario/wvd/azure-virtual-desktop-azure-active-directory-join).

## Best practices

- [Security best practices for Azure Virtual Desktop](/azure/virtual-desktop/security-guide)
- [Azure security baseline for Azure Virtual Desktop](/security/benchmark/azure/baselines/virtual-desktop-security-baseline)
- [Session host virtual machine sizing guidelines](/windows-server/remote/remote-desktop-services/virtual-machine-recs)
- [Configure device redirection](/azure/virtual-desktop/configure-device-redirections)
- [Set up scaling tool using Azure Automation and Azure Logic Apps for Azure Virtual Desktop](/azure/virtual-desktop/set-up-scaling-script)

## More virtual desktop resources

The following sections, organized by category, provide links to more example scenarios and articles.

### Identity

In addition to the resources about authentication noted earlier in the [Path to production](#path-to-production) section, see these articles:

- [Multiple forests with AD DS and Azure AD](/azure/architecture/example-scenario/wvd/multi-forest-azure-managed)
- [Multiple forests with AD DS, Azure AD, and Azure AD DS](/azure/architecture/example-scenario/wvd/multi-forest-azure-managed)

### Azure Virtual Desktop for the enterprise

- [Azure Virtual Desktop for the enterprise](/azure/architecture/example-scenario/wvd/windows-virtual-desktop)
- [FSLogix for the enterprise](/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix)

### FSLogix 

FSLogix is a set of solutions that enhance, enable, and simplify non-persistent Windows computing environments. FSLogix solutions are appropriate for virtual environments in public and private clouds. For more information, see these resources:

- [FSLogix for the enterprise](/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix)
- [FSLogix profile containers and Azure files](/azure/virtual-desktop/fslogix-containers-azure-files?toc=https%3A%2F%2Fdocs.microsoft.com%%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Storage options for FSLogix profile containers in Azure Virtual Desktop](/azure/virtual-desktop/store-fslogix-profile?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

## Stay current with virtual desktop technologies on Azure

Get the latest updates on [Azure virtual desktop technologies](https://azure.microsoft.com/updates/?category=windows-virtual-desktop).

## Additional resources

### Example solutions

These are some additional articles about Azure Virtual Desktop:

- [Azure Virtual Desktop RDP Shortpath for managed networks](/azure/virtual-desktop/shortpath?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Multiregion Business Continuity and Disaster Recovery (BCDR) for Azure Virtual Desktop](/azure/architecture/example-scenario/wvd/azure-virtual-desktop-multi-region-bcdr)
- [Deploy Esri ArcGIS Pro in Azure Virtual Desktop](/azure/architecture/example-scenario/data/esri-arcgis-azure-virtual-desktop)

### AWS professionals

- [AWS to Azure services comparison - End-user computing](/azure/architecture/aws-professional/services#end-user-computing)