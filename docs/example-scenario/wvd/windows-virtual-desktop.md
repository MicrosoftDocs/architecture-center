---
title: Windows Virtual Desktop for the enterprise
titleSuffix: Azure Example Scenarios
description: Explore Windows Virtual Desktop, and learn to build virtual desktop infrastructure solutions at enterprise scale.
author: doodlemania2
ms.date: 07/16/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.category: 
    - windows-virtual-desktop
ms.custom:
- fcp
---
# Windows Virtual Desktop for the enterprise

[Windows Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop/) is a desktop and application virtualization service that runs in the Azure cloud. This article helps Desktop Infrastructure Architects, Cloud Architects, Desktop Administrators, or System Administrators explore Windows Virtual Desktop and build virtualized desktop infrastructure (VDI) solutions at enterprise scale. Enterprise-scale solutions generally cover 1,000 virtual desktops and above.

## Relevant use cases

Most demand for enterprise virtual desktop solutions comes from:

- Security and regulation applications like financial services, healthcare, and government.
- Elastic workforce needs like remote work, mergers and acquisition, short-term employees, contractors, and partner access.
- Specific employees like bring your own device (BYOD) and mobile users, call centers, and branch workers.
- Specialized workloads like design and engineering, legacy apps, and software development test.

## Architecture

![Diagram of a Windows Virtual Desktop service architecture.](images/windows-virtual-desktop.png)

This diagram shows a typical architectural setup for Windows Virtual Desktop.

- The application endpoints are in the customer's on-premises network. ExpressRoute extends the on-premises network into the Azure cloud, and Azure AD Connect integrates the customer's Active Directory Domain Services (AD DS) with Azure Active Directory (Azure AD).
- The Windows Virtual Desktop control plane handles Web Access, Gateway, Broker, Diagnostics, and extensibility components like REST APIs.
- The customer manages AD DS and Azure AD, Azure subscriptions, virtual networks, [Azure Files or Azure NetApp Files](/azure/virtual-desktop/store-fslogix-profile), and the Windows Virtual Desktop host pools and workspaces.
- To increase capacity, the customer uses two Azure subscriptions in a hub-spoke architecture, and connects them via virtual network peering.

For more information about FSLogix Profile Container - Azure Files and Azure NetApp Files best practices, see [FSLogix for the enterprise](./windows-virtual-desktop-fslogix.md)

## Components

[Windows Virtual Desktop](/azure/virtual-desktop/overview) service architecture is similar to [Windows Server Remote Desktop Services](/windows-server/remote/remote-desktop-services/welcome-to-rds). Microsoft manages the infrastructure and brokering components, while enterprise customers manage their own desktop host virtual machines (VMs), data, and clients.

### Components Microsoft manages

Microsoft manages the following Windows Virtual Desktop services as part of Azure:

- **Web Access:** The [Web Access](/azure/virtual-desktop/connect-web) service within Window Virtual Desktop lets users access virtual desktops and remote apps through an HTML5-compatible web browser as they would with a local PC, from anywhere on any device. You can secure Web Access using multifactor authentication in Azure Active Directory.
- **Gateway:** The Remote Connection Gateway service connects remote users to Windows Virtual Desktop apps and desktops from any internet-connected device that can run a Windows Virtual Desktop client. The client connects to a gateway, which then orchestrates a connection from a VM back to the same gateway.
- **Connection Broker:** The Connection Broker service manages user connections to virtual desktops and remote apps. The Connection Broker provides load balancing and reconnection to existing sessions.
- **Diagnostics**: Remote Desktop Diagnostics is an event-based aggregator that marks each user or administrator action on the Windows Virtual Desktop deployment as a success or failure. Administrators can query the event aggregation to identify failing components.
- **Extensibility components**: Windows Virtual Desktop includes several extensibility components. You can manage Windows Virtual Desktop using Windows PowerShell or with the provided REST APIs, which also enable support from third-party tools.

### Components you manage

Customers manage these components of Windows Virtual Desktop solutions:

- **Azure Virtual Network:** [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) lets Azure resources like VMs communicate privately with each other and with the internet. By connecting Windows Virtual Desktop host pools to an Active Directory domain, you can define network topology to access virtual desktops and virtual apps from the intranet or internet, based on organizational policy. You can connect a Windows Virtual Desktop to an on-premises network using a virtual private network (VPN), or use [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute/) to extend the on-premises network into the Azure cloud over a private connection.
- **Azure AD:** Windows Virtual Desktop uses [Azure AD](https://azure.microsoft.com/services/active-directory/) for identity and access management. Azure AD integration applies Azure AD security features like conditional access, multi-factor authentication, and the [Intelligent Security Graph](https://www.microsoft.com/security/business/intelligence), and helps maintain app compatibility in domain-joined VMs.
- **AD DS:** Windows Virtual Desktop VMs must domain-join an [AD DS](https://azure.microsoft.com/services/active-directory-ds/) service, and the AD DS must be in sync with Azure AD to associate users between the two services. You can use [Azure AD Connect](/azure/active-directory/hybrid/whatis-azure-ad-connect) to associate AD DS with Azure AD.
- **Windows Virtual Desktop session hosts:** A host pool can run the following operating systems:
  - Windows 7 Enterprise
  - Windows 10 Enterprise
  - Windows 10 Enterprise Multi-session
  - Windows Server 2012 R2 and above
  - Custom Windows system images with pre-loaded apps, group policies, or other customizations
  
  You can choose VM sizes, including GPU-enabled VMs. Each session host has a Windows Virtual Desktop host agent, which registers the VM as part of the Windows Virtual Desktop workspace or tenant. Each host pool can have one or more app groups, which are collections of remote applications or desktop sessions that users can access.
- **Windows Virtual Desktop workspace:** The Windows Virtual Desktop workspace or tenant is a management construct to manage and publish host pool resources.

### Personal and pooled desktops

Personal desktop solutions, sometimes called persistent desktops, allow users to always connect to the same specific session host. Users can typically modify their desktop experience to meet personal preferences, and save files in the desktop environment. Personal desktop solutions:

- Let users customize their desktop environment, including user-installed applications and saving files within the desktop environment.
- Allow assigning dedicated resources to a specific user, which can be helpful for some manufacturing or development use cases.

Pooled desktop solutions, also called non-persistent desktops, assign users to whichever session host is currently available, depending on the load-balancing algorithm. Because the users don't always return to the same session host each time they connect, they have limited ability to customize the desktop environment and don't usually have administrator access.

### Windows servicing

There are several options for updating Windows Virtual Desktop desktops. Deploying an updated image every month guarantees compliance and state.

- [Microsoft Endpoint Configuration Manager (MECM)](/mem/configmgr/) updates server and desktop operating systems.
- [Windows Updates for Business](/windows/deployment/update/waas-manage-updates-wufb) updates desktop operating systems like Windows 10 multi-session.
- [Azure Update Management](/azure/automation/automation-update-management) updates server operating systems.
- [Azure Log Analytics](/azure/azure-monitor/platform/log-analytics-agent) checks compliance.
- Deploy a new (custom) image to session hosts every month for the latest Windows and applications updates. You can use an image from the Azure Marketplace or a [custom Azure managed image](/azure/virtual-machines/windows/capture-image-resource).

## Considerations

Numbers in the following sections are approximate. The numbers are based on a variety of large customer deployments, and they might change over time.

Also, note that:

- You can't create more than 200 application groups per single Azure AD tenant.
- We recommend that you don't publish more than 50 applications per application group. 

### Azure limitations

The Windows Virtual Desktop service is scalable to more than 10,000 session hosts per workspace. You can address some Azure platform and Windows Virtual Desktop control plane limitations in the design phase to avoid changes in the scaling phase.

- We recommend to deploy not more than 5,000 VMs per Azure subscription per region, this recommendation applies to both personal and pooled host pools based on Windows 10 Enterprise single and multi-session. Most customers use Windows 10 Enterprise multi-session, which allows multiple users to log on to each VM. You can increase the resources of individual session host VMs to accommodate more user sessions.
- For automated session host scaling tools, the limits are around 1,200 VMs per Azure subscription per region, because VM status interaction consumes more resources.
- To manage enterprise environments with more than 5,000 VMs per Azure subscription in the same region, you can create multiple Azure subscriptions in a hub-spoke architecture and connect them via virtual network peering, as in the preceding example architecture. You could also deploy VMs in a different region in the same subscription to increase the number of VMs.
- Azure Resource Manager (ARM) subscription API throttling limits don't allow more than 600 Azure VM reboots per hour via the Azure portal. You can reboot all your machines at once via the operating system, which doesn't consume any Azure Resource Manager subscription API calls. For more information about counting and troubleshooting throttling limits based on your Azure subscription, see [Troubleshoot API throttling errors](/azure/virtual-machines/troubleshooting/troubleshooting-throttling-errors).
- You can currently deploy 399 VMs per Windows Virtual Desktop ARM template deployment without [Availability Sets](/azure/virtual-machines/availability#availability-sets), or 200 VMs per Availability Set. You can increase the number of VMs per deployment by switching off Availability Sets in either the ARM template or the Azure portal host pool enrollment.
- Azure VM session host name prefixes can't exceed 11 characters, due to auto-assigning of instance names and the NetBIOS limit of 15 characters per computer account.
- By default, you can deploy up to 800 instances of most resource types in a resource group. Azure Compute doesn't have this limit.

For more information about Azure subscription limitations, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).

### VM sizing

[Virtual machine sizing guidelines](/windows-server/remote/remote-desktop-services/virtual-machine-recs) lists the maximum suggested number of users per virtual central processing unit (vCPU) and minimum VM configurations for different workloads. This data helps estimate the VMs you need in your host pool.

Use simulation tools to test deployments with both stress tests and real-life usage simulations. Make sure the system is responsive and resilient enough to meet user needs, and remember to vary the load sizes when testing.

### Pricing

Architect your Windows Virtual Desktop solution to realize cost savings. Here are five different options to help manage costs for enterprises:

- **Windows 10 multi-session**: By delivering a multi-session desktop experience for users that have identical compute requirements, you can let more users log onto a single VM at once, resulting in considerable cost savings.
- **Azure Hybrid Benefit**: If you have Software Assurance, you can use [Azure Hybrid Benefit for Windows Server](/azure/virtual-machines/windows/hybrid-use-benefit-licensing) to save on the cost of your Azure infrastructure.
- **Azure Reserved Instances:** You can prepay for your VM usage and save money. Combine [Azure Reserved Instances](https://azure.microsoft.com/pricing/reserved-vm-instances/) with Azure Hybrid Benefit for up to 80 percent savings over list prices.
- **Session host load-balancing**: When setting up session hosts, **Breadth-first** is the standard default mode, which spreads users randomly across session hosts. **Depth-first** mode fills up a  session host server with the maximum number of users before it moves on to the next session host. You can adjust this setting for maximum cost benefits.

## Next steps

- FSLogix for the enterprise - best practices [documentation](./windows-virtual-desktop-fslogix.md)
- Use the new [ARM templates](https://github.com/Azure/RDS-Templates/tree/master/ARM-wvd-templates) to automate the deployment of your Windows Virtual Desktop environment. These ARM templates support only Azure Resource Manager Windows Virtual Desktop objects. These ARM templates don't support Windows Virtual Desktop (classic). 
- For multiple AD forests architecture, read [Multiple AD Forests Architecture in Windows Virtual Desktop](./multi-forest.md).
- [Windows Virtual Desktop partner integrations](https://aka.ms/wvdpartner) lists approved Windows Virtual Desktop partner providers and independent software vendors.
- Use the resources at [Windows_10_VDI_Optimize](https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool) to help optimize performance in a Windows 10 Enterprise VDI environment.
