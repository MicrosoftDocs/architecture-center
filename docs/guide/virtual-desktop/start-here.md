---
title: Virtual desktop architecture design
description: Get an overview of Azure virtual desktop technologies, guidance offerings, solution ideas, and reference architectures. 
author: martinekuan
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

If you're new to virtual desktops on Azure, the best way to learn more is [Microsoft Learn training](/training/?WT.mc_id=learnaka), a free online platform. Here's a learning path to get you started:

- [Deliver remote desktops and apps with Azure Virtual Desktop](/training/paths/m365-wvd)

## Path to production

Cloud Adoption Framework for Azure provides an end-to-end scenario to guide you through your virtual desktop migration or deployment. Start with [Migrate or deploy Azure Virtual Desktop instances to Azure](/azure/cloud-adoption-framework/scenarios/wvd), and check out the other articles below that one in the table of contents.

These are two more key Cloud Adoption Framework articles:

- [Azure Virtual Desktop planning](/azure/cloud-adoption-framework/scenarios/wvd/plan)
- [Azure Virtual Desktop Azure landing zone review](/azure/cloud-adoption-framework/scenarios/wvd/ready)

See [Understanding Azure Virtual Desktop network connectivity](/azure/virtual-desktop/network-connectivity?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json) for a high-level overview of the network connections used by Azure Virtual Desktop.

## Best practices

- [Security best practices for Azure Virtual Desktop](/azure/virtual-desktop/security-guide)
- [Azure security baseline for Azure Virtual Desktop](/security/benchmark/azure/baselines/virtual-desktop-security-baseline)
- [Session host virtual machine sizing guidelines](/windows-server/remote/remote-desktop-services/virtual-machine-recs)
- [Configure device redirection](/azure/virtual-desktop/configure-device-redirections)
- [Set up scaling tool using Azure Automation and Azure Logic Apps for Azure Virtual Desktop](/azure/virtual-desktop/set-up-scaling-script)

## More virtual desktop resources

The following sections, organized by category, provide links to example scenarios and other articles.

### Identity

- [Authentication in Azure Virtual Desktop](/azure/virtual-desktop/authentication?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Azure AD join for Azure Virtual Desktop](../../example-scenario/wvd/azure-virtual-desktop-azure-active-directory-join.md)
- [Multiple forests with AD DS and Azure AD](../../example-scenario/wvd/multi-forest.yml)
- [Multiple forests with AD DS, Azure AD, and Azure AD DS](../../example-scenario/wvd/multi-forest-azure-managed.yml)

### Azure Virtual Desktop for the enterprise

- [Azure Virtual Desktop for the enterprise](../../example-scenario/wvd/windows-virtual-desktop.yml)

### FSLogix

FSLogix is designed for roaming profiles in remote computing environments like Azure Virtual Desktop. It stores a complete user profile in a single container. At sign-in, this container is dynamically attached to the computing environment. For more information, see these resources:

- [FSLogix configuration examples](/fslogix/concepts-configuration-examples)
- [FSLogix profile containers and Azure Files](/azure/virtual-desktop/fslogix-containers-azure-files?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Storage options for FSLogix profile containers in Azure Virtual Desktop](/azure/virtual-desktop/store-fslogix-profile?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)

## Stay current with virtual desktop technologies on Azure

Get the [latest updates on Azure virtual desktop technologies](https://azure.microsoft.com/updates/?category=windows-virtual-desktop).

## Additional resources

### Example solutions

These are some additional articles about Azure Virtual Desktop:

- [Azure Virtual Desktop RDP Shortpath for managed networks](/azure/virtual-desktop/shortpath?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Multiregion Business Continuity and Disaster Recovery (BCDR) for Azure Virtual Desktop](../../example-scenario/wvd/azure-virtual-desktop-multi-region-bcdr.yml)
- [Deploy Esri ArcGIS Pro in Azure Virtual Desktop](../../example-scenario/data/esri-arcgis-azure-virtual-desktop.yml)

### AWS professionals

- [AWS to Azure services comparison - End-user computing](../../aws-professional/services.md#end-user-computing)
