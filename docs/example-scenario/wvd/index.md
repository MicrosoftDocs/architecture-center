---
title: Title
titleSuffix: Azure Example Scenarios
description: Description
author: GitHubAlias
ms.date: 05/01/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---
# Title: Windows Virtual Desktop at enterprise scale

## Purpose

This architecture guide is for Desktop Infrastructure Architects, Cloud Architects, Desktop Administrators, or System Administrators who are exploring the Windows Virtual Desktop.

The aim of this guide is to help you understand how Windows Virtual Desktop works, while providing architectural considerations for building virtual desktop infrastructure solutions at larger **Enterprise scale**.

_ **Note** __: The numbers in this document are based on common practices at a variety of large customer deployments and do not represent one way of doing a deployment. This document will be constantly updated._

## Relevant use cases

Consider this scenario for the following use cases from 1000 virtual desktops and above. Most of our demand is coming from either one of the scenarios below.

- **Security and regulation**
  - Financial Services, healthcare and government
- **Elastic workforce**
  - Remote Working (work from home), Mergers and acquisition, short term employees, contractor and partner access
- **Specific**** employees**
  - BYOD and mobile, call centers and branch workers
- **Specialized workloads**
  - Design and engineering, legacy apps and software dev test

## Architecture

As you might expect, the architecture of the Windows Virtual Desktop service is like that of Windows Server Remote Desktop Services. Microsoft manages the infrastructure and brokering components, while you manage the desktop host virtual machines, data, and clients.

## Microsoft-managed components

The following Windows Virtual Desktop services are managed by Microsoft as part of Azure:

- **Web Access.** The Web Access service within Window Virtual Desktop lets users access virtual desktops and remote apps through an HTML5-compatible web browser like they would with a local PC—from anywhere and any device. You can secure Web Access using multifactor authentication in Azure Active Directory.
- **Gateway**. The Remote Connection Gateway service connect remote users access to Windows Virtual Desktop remote apps and desktops from any internet-connected device that can run a Windows Virtual Desktop client. The WVD client connects to a Gateway which then orchestrates a connection from the VM back to the same gateway.
- **Connection Broker**. The Connection Broker service manages user connections to virtual desktops and remote apps. It provides load balancing and reconnection to existing sessions.
- **Diagnostics**. Remote Desktop Diagnostics is an event-based aggregator that marks each user or administrator action on the Windows Virtual Desktop deployment as a success or failure. Administrators can query the aggregation of events to identify failing components.
- **Extensibility components**. Windows Virtual Desktop includes several extensibility components. You can manage Windows Virtual Desktop using Windows PowerShell or with the provided REST APIs, which also enable support from third-party tools.

![](WVD_html_6ac41888a9a69888.png)

## Components you manage

You manage these components of your Windows Virtual Desktop solution:

- **Azure Virtual Network.** A virtual network (vNET) enables Azure resources, such as virtual machines, to communicate privately with each other and with the internet. By connecting Windows Virtual Desktop host pools to the Active Directory domain, you can define network topology to access virtual desktop and virtual apps from the intranet or internet based on organizational policy. Connect your Windows Virtual Desktop vNET to your on-premises network using a virtual private network. Or use Azure ExpressRoute to extend your on-premises networks into the Microsoft cloud platform over a private connection, facilitated by a connectivity provider.
- **Active Directory.** Windows Virtual Desktop requires Active Directory Domain Services (AD DS). VMs must domain-join this AD DS. This AD DS must be in sync with Azure AD so users can be associated between the two.
- **Azure Active Directory**. Windows Virtual Desktop uses Azure Active Directory for identity and access management. This lets you take advantage of Azure Active Directory security features, such as conditional access, Multi-Factor Authentication, and the Intelligent Security Graph. It also helps you maintain app compatibility in your environment when your virtual machines are Active Directory domain.
- **Windows Virtual Desktop session hosts** objects. A host pool can run one of several operating systems—including Windows 7 Enterprise, Windows 10 Enterprise, Windows 10 Enterprise Multi-session, Windows Server 2012 R2 and above, including custom Windows system images with pre-loaded apps, group policies, or any other customizations. You also have your choice of virtual machine sizes, including GPU-enabled virtual machines. Each session host has a Windows Virtual Desktop host agent installed, which registers the virtual machine as part of your Windows Virtual Desktop workspace (tenant). And each host pool can have one or more app groups, which are collections of remote applications or desktop sessions that users can access.
- **Windows Virtual Desktop** **workspace (tenant)** Your Windows Virtual Desktop workspace (tenant) is a management construct to manage and publish host pool resources.

## Cost considerations

Here are five different options to take into consideration to manage costs for enterprises. Architect your solution to realize cost savings.

- **Use Windows 10 multi-session**. By delivering a multi-session desktop experience, you can enable more users (with identical compute requirements) to log onto a single virtual machine at the same time, which can result in considerable cost savings.
- **Azure Hybrid Benefit**. If you have Software Assurance, you can use Azure Hybrid Benefit for Windows Server to save on the cost of your Azure infrastructure.
- **Azure Reserved Instances**. Prepay for your virtual machine usage and save money. Combine with Azure Hybrid benefit for up to 80 percent savings over list prices.
- **Session host load-balancing**.
  - **Breadth-first**   **mode**  is the standard – default mode. With Breadth mode, the users will spread randomly across session hosts – as part of the host pool.
  - **Depth-first**** mode** automatically fills up the first session host server maximum amount of users before moving on to a next session host, and so on.

## Enterprise architectural considerations

The Windows Virtual Desktop service proofed to be scalable to up to sizes of more than 10.000 session hosts per Workspace. However, the Azure platform as well as the control-plane managed service has some limitations that you need to address while designing your platform that could avoid changes in the scaling phase.

_ **Note** __: The numbers in this category can vary overtime and are constantly updated to improve the experience for our customers._

## Servicing session hosts

### Personal Desktops

Personal desktop solutions, sometimes called persistent desktops, allow users to connect to a specific session host each time they connect. Users can typically modify the desktop experience to meet their personal preferences and save files in the desktop environment. Personal desktop solutions are appropriate when you need to:

- Allow users to customize the desktop environment, including user installed applications and saving files within the desktop environment.
- Assign dedicated resources to a specific user that are not being shared with others. This could be beneficial for some e.g. manufacturing or development use-cases.

### Pooled Desktops

Pooled desktop solutions, also called non-persistent desktops, assign users to whichever session host is currently available, depending on the load-balancing algorithm chosen. Because the user isn't always returned to the same session host each time they connect, they have limited ability to customize the desktop environment and are not typically given administrator access.

### Windows Servicing

Updating your Windows Virtual Desktop personal or pooled desktops can be done in different ways. Deployment of an updated image every month guarantees compliance and state.

- **Microsoft Endpoint Configuration Manager** (MECM) for server and desktop operating systems
- **Windows Updates for Business** for desktop operating systems e.g. Windows 10 multi-session
- **Azure Update Management** for server operating systems
- **Azure Log Analytics** compliance checks only
- **Deploy a new (custom) image** (re-deploy session hosts) every month from our gallery (or a [custom Azure managed](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/capture-image-resource) image) with the latest Windows and applications updates.

## Host pools

- We recommend deploying not more than 5000 session hosts per host pool. Those session host could be active in different Azure subscriptions.

## Azure subscription limitations

- We suggest deploying no more than 5000 VMs per Azure subscription has a limit per Azure. To manage your enterprise size environment, you could stack your environment by creating multiple Azure subscription (hub - spoke approach) to increase the amount of VMs and connect them altogether via VNET peering. See [Azure subscription and service limits, quotas, and constraints for more information](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits). _ **Note:** _ _The vast majority of customer use Windows 10 Enterprise multi-session which allows more users to logon. 5000 VMs doesn't mean that you are limited to that same number of session. This only apply to personal host pools based on e.g. Windows 10 Enterprise single-session._

- When you are using automated session host scaling tools the numbers are smaller than mentioned above, as VM status interaction is consuming more interaction on the ARM subscription regarding limits. Most likely that number will be around 2000 VMs per Azure subscription. We will share more accurate new numbers based on this scenario later.
- We recommend to not reboot more than **600 Azure virtual machines per hour via** the Azure portal. This is due to the Azure ARM subscription API throttling limits. _ **Note** __: Here's a good [Microsoft docs article](https://docs.microsoft.com/en-us/azure/virtual-machines/troubleshooting/troubleshooting-throttling-errors#call-rate-informational-response-headers) that you could use to count and troubleshoot API throttling limits based on your own Azure subscription._
  - You can reboot all your machines at once while doing it via the Operating System. You are not consuming any Azure ARM subscription API calls via this procedure.
- 399 is the current virtual machines limit per WVD ARM template deployments with Availability Sets not being used.
- You can only deploy 200 virtual machines per Availability sets. You can increase the amount of machines per deployment by switching of the creation and assignment of Availability Sets in either the ARM template or the Azure Marketplace – host pool enrolment.
- With availability sets disabled we recommend to deploy not more than 399 VMs per deployment job p/hour whether it's via the Azure Marketplace or via ARM templates to avoid hitting any subscription limits on the Azure platform. Making this a total amount of 5000 VMs per subscription.
- Limitations are active on the virtual machines per Azure subscription. You could increase the resources of your individual session host VMs in your Azure subscription to accommodate more user session without hitting the maximum limit of virtual machines per Azure subscription as described above.
- There are no Azure Compute limitations active on [resource groups](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resources-without-resource-group-limit) that limit you to deploy virtual machines – in a single Azure subscription.

## Azure Virtual Machines – session hosts

- Azure VMs – session host names prefix cannot exceed 11 characters. This is due to the auto-count that comes on top as well as the NetBIOS limit of 15 characters per computer account. _For example, when_ _ **WVDABCDEFGH** _ _is your VM prefix and you deploy 999 VMs in your host pool the last customer account name will become_ _ **WVDABCDEFGH-999** _ _which effectively consumes all the 15 characters in total to hit the Kerberos limit._

## Sizing recommendations per session host

The following three articles lists the maximum suggested number of users per virtual central processing unit (vCPU) and the minimum VM configuration for each workload. This could be helpful to see what your first estimation of VMs as part of your host pool.

- [Multi-session recommendations](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/virtual-machine-recs?context=/azure/virtual-desktop/context/context#multi-session-recommendations)
- [Single-session recommendations](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/virtual-machine-recs?context=/azure/virtual-desktop/context/context#single-session-recommendations)
- [General virtual machine recommendations](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/virtual-machine-recs?context=/azure/virtual-desktop/context/context#general-virtual-machine-recommendations)

We recommend you use simulation tools to test your deployment with both stress tests and real-life usage simulations. Make sure your system is responsive and resilient enough to meet user needs, and remember to vary the load size to avoid surprises. Find here a [list](https://aka.ms/wvdpartner) of partner solutions that can help.

You could also optimize the performance of your Windows 10 Enterprise environment as well with one of the optimization resources for different builds listed over [here](https://github.com/TheVDIGuys/Windows_10_VDI_Optimize).

_The_ _ **next** __ **topic** _ _we cover is Microsoft FSLogix Profile Container at scale._
