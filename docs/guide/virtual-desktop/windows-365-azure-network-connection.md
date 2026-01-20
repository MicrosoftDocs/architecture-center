---
title: Windows 365 Azure Network Connection  
description: Design and implement Windows 365 Azure network connections to integrate Cloud PCs with your existing network infrastructure and on-premises resources.
author: PaulCollinge
ms.author: paulcoll
ms.date: 06/05/2025
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Windows 365 Azure network connection  

Windows 365 delivers cloud-based Windows computing instances called *Cloud PCs* that provide users with personalized, optimized desktop experiences. Each Cloud PC integrates with the following Microsoft Cloud services to provide enterprise-grade security, management, and connectivity:

- Intune for device management, security policies, and application deployment

- Microsoft Entra ID for identity management and access control
 
- Azure Virtual Desktop for secure remote connectivity and session management

Cloud PCs run in the Windows 365 service and provide users with consistent Windows desktop experiences that they can access from any device, anywhere. This article focuses on Windows 365 deployments that use Azure network connections to integrate with your existing network infrastructure and on-premises resources.

### The Windows 365 shared responsibility model

Windows 365 is a software as a service (SaaS) solution. Microsoft manages some components in Windows 365 services, and you manage other components. Your level of responsibility depends on your architecture pattern for deployment.

The Windows 365 management responsibilities are divided into three areas:

- **Deployment:** Plan and deploy the component of the service.

- **Life cycle:** Manage the component throughout its life cycle, such as patching and securing.

- **Configuration:** Configure the component to apply required settings for a scenario.

The following diagram shows the responsibility matrix of a Windows 365 deployment that uses the recommended Microsoft-hosted network, Microsoft Entra join, and gallery images with Microsoft Windows Autopatch. This configuration doesn't require you to manage many components and life cycle stages, and it provides [many benefits](#recommended-architecture-pattern).

> [!NOTE]
> The following diagram represents the responsibilities from the infrastructure perspective, such as setting up the hardware and network and maintaining them. It doesn't include the Windows 365 or Intune tenant subscription setup.

:::image type="complex" source="./images/windows-365-placement-diagrams-updated-1.svg" alt-text="A diagram of the responsibility matrix that shows a deployment that uses the Microsoft-hosted network." lightbox="./images/windows-365-placement-diagrams-updated-1.svg" border="false":::
This matrix shows that Microsoft manages all aspects of the deployment, life cycle, and configuration steps for the following components: Virtual Desktop, Windows 365, Cloud PC infrastructure, Cloud PC VMs, Intune, Cloud PC virtual NICs, Azure subscription, resource groups, Azure Storage, Virtual Network, and routing configuration. The one exception is the configuration step of Intune, which is the customer's responsibility. Azure Storage is marked as optional. The customer manages all steps of Microsoft Entra ID, Azure DNS, guest OS, applications, and Cloud PC security.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/windows-365-placement-diagrams-updated-1.pptx) of this architecture.*

The following diagram shows a typical Windows 365 deployment that uses an Azure network connection. It shows the components that Microsoft manages and the components that you manage across the life cycle stages of a Cloud PC.

:::image type="complex" source="./images/windows-365-placement-diagrams-updated-2.svg" alt-text="A diagram of the responsibility matrix that shows a deployment that uses an Azure network connection." lightbox="./images/windows-365-placement-diagrams-updated-2.svg" border="false":::
This matrix shows that Microsoft manages all aspects of the deployment, life cycle, and configuration steps for the following components: Virtual Desktop, Windows 365, Cloud PC infrastructure, Cloud PC VMs, Intune, and Cloud PC virtual NICs. The one exception is the configuration step of Intune, which is the customer's responsibility. The customer manages all steps of the Azure subscription, resource groups, Azure Storage, Virtual Network, routing configuration, VPN or Azure ExpressRoute, Microsoft Entra ID, Azure DNS, guest OS, applications, and Cloud PC security. Azure Storage is marked as optional.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/windows-365-placement-diagrams-updated-2.pptx) of this architecture.*

### Recommended architecture pattern

We recommend that you deploy Windows 365 with the following components to get a SaaS experience:

- Microsoft Entra join
- A Microsoft-hosted network
- Gallery images
- An Intune-based mobile device management (MDM) service with app and OS configuration
- A Windows 365 app for Cloud PC access

This pattern provides the maximum benefits of the service.

:::image type="complex" source="./images/windows-365-placement-diagrams-updated-3.svg" alt-text="A diagram of an architecture pattern that shows benefits of the Windows 365 service." lightbox="./images/windows-365-placement-diagrams-updated-3.svg" border="false":::
This diagram shows an Azure network that contains customer subscriptions and Azure subscriptions. The customer subscription section contains Intune and Microsoft Entra ID. The Azure subscription section contains Windows 365 and a virtual network. The following components reside outside the Azure network: A Windows 365 app, Windows 11 gallery images for Windows 365, direct internet traffic, and a customer corporate network. The Windows 365 app points to Windows 365 in the Azure subscription. Windows 365 connects to the gallery images. The virtual network points to the direct internet traffic, which is an optional routing path. The virtual network points to the customer corporate network via an optional VPN or private access connection.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/windows-365-placement-diagrams-updated-3.pptx) of this architecture.*

The preceding architecture pattern maximizes the value of Windows 365 and provides the following benefits:

- Simplified and faster deployment
- Minimal to zero dependencies
- Full Zero Trust framework support
- Simplified troubleshooting flows
- Self-service user troubleshooting
- Low overhead and management
- Highest maturity model of software and application delivery

### The Windows 365 service architecture

The following diagram represents the components in the Windows 365 service. This architecture uses Intune and Microsoft Entra ID, which are core requirements of Windows 365. It also includes optional components such as Azure Virtual Network. It shows Azure network connection and Microsoft-hosted network options, which are mutually exclusive. 

:::image type="complex" source="./images/windows-365-placement-diagrams-updated-4.svg" alt-text="A diagram of the Azure network connection and Microsoft-hosted network options." lightbox="./images/windows-365-placement-diagrams-updated-4.svg" border="false":::
This diagram has six main sections: Windows 365 clients, Windows 365 service, Azure Virtual Desktop, Microsoft Entra ID, Intune, and a customer Azure subscription. The Windows 365 clients, Virtual Desktop, and a virtual network in the Windows 365 service connect to the internet. Microsoft Entra ID connects to clients. Intune connects to Microsoft Entra ID via the Intune web console. Clients connect to the user portal in Windows 365. The customer Azure subscription has an optional connection to a non-Microsoft VPN and to the virtual network in Windows 365. The VPN has an optional connection to an on-premises network, which also connects to ExpressRoute in the subscription. Active Directory and Configuration Manager connect to that on-premises network. The Intune section includes three subsections: Configure devices, protect data, and manage apps. It also contains Autopilot and Autopatch, co-management, and Azure role-based access control (Azure RBAC). The Intune section points to Windows Update for business and Microsoft Defender for Endpoint. The virtual network in Windows 365 contains a Microsoft Hosted Network and an Azure network connection. Both of these components point to the Virtual Desktop section, which contains a gateway, broker, and web. The Azure network connection also has an optional connection to a Cloud PC. The Microsoft Hosted has a default connection to a Cloud PC.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/w365-azure-network-connection-4.vsdx) of this architecture.*

The following sections expand on the Azure network connection options.

### Virtual Desktop

Virtual Desktop is an Azure-based virtual desktop infrastructure solution. Microsoft manages Virtual Desktop. It provides a platform as a service (PaaS)-style solution. Windows 365 uses the network management components of Virtual Desktop to enable connectivity to Microsoft-hosted Cloud PCs. These components include the Virtual Desktop gateway service, a connection broker service, and a web client service. They provide seamless connection to Windows 365 Cloud PCs.

:::image type="complex" source="./images/windows-365-placement-diagrams-updated-5.svg" alt-text="A diagram that shows Virtual Desktop control plane components." lightbox="./images/windows-365-placement-diagrams-updated-5.svg" border="false":::
This diagram contains three main sections, an Azure subscription, an on-premises network, and Azure Files and Azure NetApp Files. The subscription contains a hub virtual network and spoke virtual network. The hub virtual network contains a gateway subnet, perimeter zone subnet, desktop subnet, and Active Directory subnet. The Active Directory subnet connects to a desktop spoke virtual network via peering. The hub desktop subnet connects to a storage account in the Azure Files section. All subnets except the gateway subnet have network security groups. The on-premises network contains a Microsoft Entra Connect server, an optional AD DS server, a network gateway, and endpoints. It connects to the Azure subscription via an ExpressRoute connection. And it connects to Microsoft Entra ID via Microsoft Entra Connect. The network gateway points to the network virtual appliance in the perimeter network subnet. The Virtual Desktop control plane is at the top of the diagram, under Microsoft Entra ID. It includes web access, a gateway, a broker, diagnostics, and a REST API.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/w365-azure-network-connection-5.vsdx) of this architecture.*

> [!NOTE]
> Windows 365 uses the components in the **Virtual Desktop control plane** to facilitate user and Cloud PC connections. Therefore, it inherits most of the connection-related capabilities of Azure Virtual Desktop. Familiarize yourself with how Virtual Desktop networking operates when you design the Azure network connection architecture in this article.

### Intune

Intune is a cloud-based endpoint management solution that you can use to view and consume reports and manage the following elements:

- App delivery
- Windows updates
- Device management configurations
- Security policies

Intune simplifies app and device management across many devices, including mobile devices, desktop computers, and virtual endpoints.

You can use Intune to protect the access and data on organization-owned and personal devices. Intune also has compliance and reporting features that support the Zero Trust security model. For more information, see [Create a device configuration profile](/windows-365/enterprise/create-device-configuration-profile).

## Architecture patterns

An architecture pattern describes components and shows configurations that you can use to deploy a service or product. For more information, see ["Hosted on behalf of" architecture](/windows-365/enterprise/architecture#hosted-on-behalf-of-architecture).

See the following Azure network connection patterns:

**Azure network connection with Microsoft Entra join:** In this pattern, Microsoft Entra-joined Cloud PCs use an Azure network connection to connect to resources in on-premises environments that don't require Kerberos or Windows New Technology LAN Manager (NTLM) authentication. For example, Cloud PCs might connect to line-of-business (LOB) applications, file shares, or other applications.

**Azure network connection with Microsoft Entra hybrid join:** In this pattern, Microsoft Entra hybrid-joined Cloud PCs use an Azure network connection to domain join with an on-premises Microsoft Entra ID domain controller. The Cloud PC authenticates with the on-premises domain controller when users access the Cloud PC, on-premises apps, or cloud apps that require Kerberos or NTLM authentication.

### Azure network connection architecture patterns

For some patterns, the Windows 365 service connects to on-premises environments via Virtual Network by using Azure ExpressRoute or a site-to-site VPN. An Azure network connection, which is an Intune object, represents this connectivity method. The Azure network connection enables Cloud PCs to connect to on-premises resources such as Windows Server Active Directory or LOB apps.

The Windows 365 service uses this connection during Cloud PC provisioning to join Cloud PCs to an on-premises Microsoft Entra domain and perform [health checks](/windows-365/enterprise/azure-network-connections#first-health-check) to ensure provisioning readiness.

The following table lists a dependency for an Azure network connection for Microsoft Entra hybrid join architecture. Windows 365 runs an automatic health check on this dependency.

| Dependency | Windows 365 check | Recommendations |
| --- | --- | --- |
| Microsoft Entra Connect | Checks if Microsoft Entra Connect is set up and finishes successfully | - Set up the Microsoft Entra Connect sync interval with the default or lowest value. Longer sync intervals increase the possibility of a Cloud PC provisioning failure in production because of a timeout. For more information, see [Microsoft Entra hybrid join failure](/windows-365/enterprise/provisioning-errors#hybrid-azure-ad-join-failed). <br><br> - Set up domain controller replication for Windows Server Active Directory from a server in the same datacenter as the Windows 365 Azure network connection. This method provides faster replication. <br><br> - Set up Microsoft Entra ID domain controller replication with a default value.|

The following table lists dependencies for an Azure network connection for Microsoft Entra hybrid join or Microsoft Entra join architecture. Windows 365 runs automatic health checks on these dependencies.

| Dependency | Windows 365 check | Recommendations |
| --- | --- | --- |
| Azure tenant readiness | Checks if Azure subscription is enabled, with no blocking restrictions, and is ready for use | - Use an account that has the right privileges to manage the Azure, Intune, and Windows 365 subscriptions. For more information, see [Role-based access control](/windows-365/enterprise/role-based-access). <br><br> - Disable or modify Azure policies that prevent the creation of Cloud PCs. For more information, see [Restrict allowed virtual machine (VM) SKUs](/azure/lab-services/how-to-use-restrict-allowed-virtual-machine-sku-sizes-policy). <br><br> - Make sure the subscription has sufficient resource quotas for networking and general limits based on the maximum number of Cloud PCs that you want to create. Examples include the network gateway size, IP address space, size of the virtual network, and bandwidth required. For more information, see [Networking limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-resource-manager-virtual-networking-limits) and [General limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#general-limits). |
| Azure virtual network readiness | Checks if the virtual network is in a supported Windows 365 region | - Create the virtual network in a [Windows 365-supported Azure region for Cloud PC provisioning](/windows-365/enterprise/requirements#supported-azure-regions-for-cloud-pc-provisioning). <br><br> - Create at least one subnet, in addition to the default subnet, to deploy the Cloud PC virtual network adaptors. <br><br> - Create shared network services, such as Azure Firewall, VPN gateways, or ExpressRoute gateways, in a separate virtual network to allow for routing controls and expansion of deployment. <br><br> In virtual networks, apply network security groups (NSGs) that have appropriate exclusions to allow the required URLs for the Windows 365 service. For more information, see [Networking requirements](/windows-365/enterprise/requirements-network) and [NSGs](/azure/virtual-network/network-security-groups-overview). |
| Azure subnet IP address usage | Checks if there are sufficient IP addresses available | - Create the virtual network with sufficient IP addresses to handle the Cloud PC creation and temporary IP address reservation during reprovisioning. We recommend that you use an IP address space that's 1.5 to 2 times the maximum Cloud PCs that you deploy for the cloud. For more information, see [General network requirements](/windows-365/enterprise/requirements-network#general-network-requirements). <br><br> - Treat the Azure virtual network as a logical extension of your on-premises network. Assign unique IP address space across all your networks to avoid routing conflicts. |
| Endpoint connectivity | Checks if the external URLs needed for the Cloud PC provisioning are reachable from the virtual network | - Allow all URLs required for Cloud PC provisioning via the Azure virtual network. For more information, see [Allow network connectivity](/windows-365/enterprise/requirements-network#allow-network-connectivity). <br><br> - Use Azure Firewall to take advantage of Windows 365, Azure Virtual Desktop, and Intune [fully qualified domain name (FQDN) tags](/azure/firewall/fqdn-tags). Use the tags to create application rules and allow URLs required for Windows 365 Cloud PC provisioning. For more information, see [Use Azure Firewall to manage and secure Windows 365 environments](/windows-365/enterprise/azure-firewall-windows-365). <br><br> - Bypass or exclude Remote Desktop Protocol (RDP) traffic from any network inspection, proxying, or manipulation device to avoid latency and routing problems. For more information, see [Traffic interception technologies](/windows-365/enterprise/requirements-network#traffic-interception-technologies). <br><br> - From the user device and network side, allow the Windows 365 service URLs and ports for proxy and network inspections. <br><br> - Allow Azure internal IP addresses `168.63.129.16` and `169.254.169.254`. These IP addresses provide communication with Azure platform services such as metadata or heartbeat. <br><br> For more information, see the following resources: <br> - [IP address 168.63.129.16](/azure/virtual-network/what-is-ip-address-168-63-129-16) <br> - [Azure Instance Metadata Service](/azure/virtual-machines/instance-metadata-service) <br> - [Virtual Network FAQ](/azure/virtual-network/virtual-networks-faq) |
| Intune enrollment | Checks if Intune allows Windows enrollment | - Ensure that you set Intune device type enrollment restrictions to allow the Windows MDM platform for corporate enrollment. <br><br> - For Microsoft Entra hybrid join, set up devices automatically by configuring the service connection point for each domain in Microsoft Entra Connect or by using the targeted deployment model. For more information, see [Configure Microsoft hybrid join](/entra/identity/devices/how-to-hybrid-join#prerequisites) and [Microsoft Entra hybrid join targeted deployment](/entra/identity/devices/hybrid-join-control). |
| Microsoft app permissions | Checks the Windows 365 app for permissions on the customer Azure subscription, resource group, and virtual network levels | - Ensure that the account you use to set up the Azure network connection has read permissions on the Azure subscription where you create the Azure virtual network. <br><br> - Ensure that the Azure subscription doesn't have policies that block permissions for the Windows 365 Microsoft-managed app. The app must have permissions at the subscription, resource group, and virtual network levels. For more information, see [Azure requirements](/windows-365/enterprise/requirements#azure-requirements). |
| Localization language pack | Checks if the language pack download locations are reachable | - Ensure that the firewall rules in the Azure virtual network allow URLs required for the appropriate version of Windows images. For more information, see [Provide a localized Windows experience](/windows-365/enterprise/provide-localized-windows-experience). |
| RDP Shortpath | Checks if the User Datagram Protocol (UDP) configurations are set up for you to connect | - Enable RDP Shortpath for Cloud PC access to take advantage of UDP's resilience. For more information, see [Use RDP Shortpath for public networks with Windows 365](/windows-365/enterprise/rdp-shortpath-public-networks) and [Use RDP Shortpath for private networks with Windows 365](/windows-365/enterprise/rdp-shortpath-private-networks). |
| Intune license | Checks if the tenant has appropriate Intune licenses to use Windows | - Ensure that you have the proper Intune licenses assigned to you in accordance with the [licensing requirements](/windows-365/enterprise/requirements#licensing-requirements). |
| Single sign-on (SSO) check | Checks if the Kerberos server object is created in Windows Server Active Directory and synced to Microsoft Entra ID | - Ensure that you select the SSO option in the provisioning policy. This option enables you to connect to the policy's Cloud PC by using sign-in credentials from an Intune-managed physical device that's domain joined or Microsoft Entra joined. For more information, see [Continue creating provisioning policies](/windows-365/enterprise/create-provisioning-policy#continue-creating-a-provisioning-policy). |
| Domain Name System (DNS) name resolution | Checks if the DNS in the Azure network connection can resolve on-premises Active Directory domain | - Configure Azure virtual network with the name resolution of an on-premises Microsoft Entra domain by using a custom DNS, private DNS, or private resolver. For more information, see [Azure DNS](/azure/dns/dns-overview). <br><br> - Ensure that the DNS servers that you configure in the virtual network reside in the same region and can register newly provisioned Cloud PCs without delay. Avoid DNS referral or redirections to prevent propagation delays, which can result in provisioning delays or failures. |
|  Microsoft Entra domain join | Checks that the credentials provided for Microsoft Entra domain join are valid and Cloud PCs can be domain joined | - Ensure that the account for Microsoft Entra domain join has permissions on the Microsoft Entra organizational unit specified in the Azure network connection configuration. <br><br> - Ensure that the account isn't a standard user account with a domain join limitation. For more information, see [Default limit for the number of workstations that a user can join to the domain](/troubleshoot/windows-server/identity/default-workstation-numbers-join-domain). <br><br> - Ensure that the account syncs to Microsoft Entra ID. <br><br> - Ensure that the organizational unit specified in the Azure network connection doesn't have object limits. For more information, see [Increase the computer account limit in the organizational unit](/mem/autopilot/windows-autopilot-hybrid#increase-the-computer-account-limit-in-the-organizational-unit). |

For more information, see [Azure network connection health checks in Windows 365](/windows-365/enterprise/health-checks#supported-checks).

## Azure network connection building blocks recommendations

This section describes the building blocks of the Windows 365 Azure network connection architecture pattern.

### Azure subscription

Windows 365 usage in an Azure network connection architecture pattern involves two types of Azure subscriptions, a Microsoft subscription and a customer subscription.

Windows 365 uses the *hosted on behalf of* model to deliver services to Windows 365 customers. This model provisions and runs the Cloud PC in Azure subscriptions that Microsoft owns. The network adapter of the Cloud PC is provisioned in a customer's Azure subscription. The following diagrams show two Azure network connection architecture patterns. You use your own Azure subscription and virtual network.

The following architecture pattern uses a Microsoft Entra join identity to manage the Cloud PC.

:::image type="complex" source="./images/windows-365-placement-diagrams-updated-6.svg" alt-text="A diagram of the architecture pattern that uses the Microsoft Entra join identity." lightbox="./images/windows-365-placement-diagrams-updated-6.svg" border="false":::
This diagram shows a network flow. A Microsoft-managed component in a virtual network of the customer subscription connects to an on-premises customer environment and Microsoft Entra ID. The component points to user connectivity and has a two-way connection to user devices.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/w365-azure-network-connection-6.vsdx) of this architecture.*

The following architecture pattern uses Microsoft Entra hybrid join identity to manage the Cloud PC. This architecture requires *line-of-sight* network communication with Active Directory Domain Services (AD DS) domain controllers in on-premises environments.

:::image type="complex" source="./images/windows-365-placement-diagrams-updated-7.svg" alt-text="A diagram of the architecture pattern that uses the Microsoft Entra hybrid join identity." lightbox="./images/windows-365-placement-diagrams-updated-7.svg" border="false":::
This diagram shows the same network flow as the previous diagram except a domain controller replaces the customer environment. A Microsoft-managed component in a virtual network of the customer subscription connects to an on-premises domain controller and Microsoft Entra ID. The component points to user connectivity and has a two-way connection to user devices.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/w365-azure-network-connection-7.vsdx) of this architecture.*

| Component | An Azure subscription that hosts the virtual network that provides connectivity for a Cloud PC to an on-premises environment and the internet. |
| --- | --- |
| Architecture patterns | - Azure network connection for Microsoft Entra join <br> - Azure network connection for Microsoft Entra hybrid join|
| Recommendations | - Create or use a subscription that has a virtual network and ExpressRoute or VPN gateways to provide a connection back to an on-premises environment. <br><br> - Create a dedicated resource group for a Cloud PC to provide permission and resource management. <br><br> - Exclude Cloud PC resource groups and virtual networks from Azure policies that prevent automatic creation and deletion of virtual network interface card objects or the assignment and release of IP addresses. For more information, see [Lock your resources to protect your infrastructure](/azure/azure-resource-manager/management/lock-resources) and [Azure requirements](/windows-365/enterprise/requirements#azure-requirements). <br><br> - Create dedicated virtual networks for better IP address management and routing controls. |

### Virtual Network and hybrid connection

Windows 365 architecture patterns that are based on an Azure network connection require one or more Azure virtual networks. These virtual networks provide connectivity to both on-premises environments and the internet for Cloud PC provisioning. The virtual network adapter of the Cloud PC is [provisioned in the Azure virtual network of the customer-owned subscription](#azure-subscription).

You can deploy Azure networking with varying design sophistication based on your existing on-premises networking or Azure networking. For more information about a basic hybrid network design, see [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz).

Consider the following factors when you design an Azure virtual network architecture:

- *IP address space:* The size of IP address space depends on the number of Cloud PCs. Plan for at least 1.5 times the maximum number of Cloud PCs that you deploy. You use the extra IP addresses when you provision and deprovision Cloud PCs.

- *Name resolution:* Cloud PCs use a DNS process to resolve the on-premises domain name in a Microsoft Entra hybrid join deployment or to resolve internet resources or Azure resources in a Microsoft Entra join deployment model.
  - To use your existing on-premises DNS infrastructure, configure the IP addresses of one or more DNS servers for name resolution. For more information, see [DNS requirements](/windows-365/enterprise/requirements-network#dns-requirements).

  - Ensure that the DNS server IP addresses that you configure in the Azure virtual network reside in the same region as the Cloud PC. Avoid redirecting DNS registration requests to other regions. Redirection can result in delayed or failed deployments and Azure network connection health checks.
  - For Azure DNS-based name resolution, use the public or private Azure DNS option or the Azure DNS Private Resolver option. For more information, see [Azure DNS documentation](/azure/dns/).

- *Network topology:* Azure networking supports topologies to accommodate different use cases.

  - *Hub-spoke topology with virtual network peering:* This simple topology isolates services within dedicated hub and spoke virtual networks. Shared services include Azure Firewall and network gateways. Use this topology if you deploy Cloud PCs in one or more spoke virtual networks within a simple, single-site environment. For more information, see [Hub-spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology).

  - *Hub-spoke topology with Azure Virtual WAN:* Virtual WAN is an Azure networking service that combines networking, security, and management capabilities for complex network requirements. Use this topology for multi-site, multiple-region deployments that have specific firewalling and routing requirements. For more information, see [Hub-spoke network topology with Virtual WAN](/azure/architecture/networking/architecture/hub-spoke-vwan-architecture).

- *Network gateways:* Azure network gateways provide connectivity from a virtual network to an on-premises network. You can choose between VPN and ExpressRoute network gateways. Before you determine your method of connectivity, consider your Cloud PC's maximum bandwidth requirements. Both VPN and ExpressRoute gateways have various tiers, or SKUs, that provide different amounts of bandwidth and other metrics. For more information, see [Connect an on-premises network to Azure by using ExpressRoute](/azure/architecture/reference-architectures/hybrid-networking/expressroute-vpn-failover).

## Routing configurations

Windows 365 uses automated health checks to determine the health and readiness of your environment to provision Microsoft Entra join or Microsoft Entra hybrid join Cloud PCs in an Azure network connection-based architecture. Without proper routing configurations in your Azure virtual network and associated networking services, Cloud PC deployments are likely to experience delays or failure.

To optimize routing for the Windows 365 network architecture, follow these recommendations:

- *Add required URLs to the allowlist:* In Microsoft Entra hybrid join and Microsoft Entra join Azure network connection models, ensure that OS antivirus, network firewalls, and load balancers allow the required URLs for each Cloud PC. For more information, see [Allow network connectivity](/windows-365/enterprise/requirements-network#allow-network-connectivity).

- *Use Azure FQDN tags:* When you use the Azure Firewall service, apply Azure FQDN tags to allow required URLs for Azure Virtual Desktop, Windows 365, and Intune. For more information, see [Use Azure Firewall to manage and secure Windows 365 environments](/windows-365/enterprise/azure-firewall-windows-365).

- *Enable pass-through:* Windows 365 uses RDP, which is sensitive to latency from traffic inspection devices, such as a firewall or a Secure Sockets Layer (SSL) decryption appliance. Latency can result in a poor experience. Disable traffic inspection of these URLs and enable pass-through. For more information, see [Traffic interception technologies](/windows-365/enterprise/requirements-network#traffic-interception-technologies).

- *Bypass proxy:* Cloud and traditional proxy services are useful for internet access but introduce latency in RDP connections. This latency occurs when the connection from the user's physical device or from the Cloud PC is forced through a proxy. It results in frequent disconnections, lags, and sluggish response times. Set **.wvd.microsoft.com** and [Windows 365 gateway IP address ranges](https://github.com/microsoft/Windows365-PSScripts/tree/main/Windows%20365%20Gateway%20IP%20Lookup) to bypass proxy services on the following components:

  - The user's physical device
  - The network that the physical device connects to
  - The Cloud PC

  For more information, see [Optimize RDP connectivity for Windows 365](https://techcommunity.microsoft.com/t5/windows-365/optimizing-rdp-connectivity-for-windows-365/m-p/3554327).

- *Ensure shortest path routing:* Ensure that RDP traffic from a Cloud PC follows the most direct route to Virtual Desktop service endpoints. The ideal path is from a virtual network to the Virtual Desktop gateway IP address via the internet. Also ensure that RDP traffic from the user's physical device reaches the Virtual Desktop gateway IP address directly. This configuration ensures optimal routing and doesn't degrade the user experience. Avoid routing RDP traffic to the internet via cloud proxy services or on-premises networks.

- *Enable RDP Shortpath:* Enable RDP Shortpath-based access for user networks, Azure networks, and Cloud PCs. RDP Shortpath uses UDP to transmit RDP traffic. Unlike Transmission Control Protocol (TCP), UDP is resilient to high-latency network connections. UDP also takes maximum advantage of the available network bandwidth to efficiently transfer RDP packets, which leads to an improved user experience. For more information, see [Use RDP Shortpath for public networks with Windows 365](/windows-365/enterprise/rdp-shortpath-public-networks).

- *Evaluate Cloud PC placement:* For an optimal user experience and routing performance, determine where customers reside in relation to the work apps or network that they access. Also consider the time that customers spend accessing LOB apps compared to the overall time that they access other apps.

  Consider the following deployment options for Cloud PC placement:

  - **Deployment option 1:** When customers primarily work in LOB apps, such as Microsoft 365 apps, this model reduces latency for those apps by placing the Cloud PC in the same region as the LOB apps (Geography B). This setup prioritizes performance for LOB access, even if the gateway is physically closer to a user in a different region (Geography A). The following diagram shows a traffic flow from the user to the LOB apps.

    :::image type="complex" source="./images/windows-365-placement-diagrams-updated-8.svg" alt-text="A diagram of a traffic flow from users to apps." lightbox="./images/windows-365-placement-diagrams-updated-8.svg" border="false":::
    The diagram has two sections, geography A and B. Geography A contains Azure region A and a user network, which connect to each other via the internet and a Virtual Desktop gateway. Geography B contains Azure region B and LOB apps. Azure region B contains Virtual Desktop and a virtual network. LOB apps connect to the virtual network via a VPN or ExpressRoute connection. A user flow goes from a user in Geography A, to a user network, to the internet, to the Virtual Desktop gateway, over the Azure backbone to Geography B, to Virtual Desktop, to a virtual network, and finally to the LOB apps.
    :::image-end:::

    *Download a [PowerPoint file](https://arch-center.azureedge.net/windows-365-placement-diagrams-updated-8.pptx) of this architecture.*

  - **Deployment option 2:** If customers occasionally access LOB apps in Geography B, deploying a Cloud PC closer to the customers optimizes the Cloud PC access latency over LOB apps access latency. The following diagram shows a traffic flow for this scenario.

    :::image type="complex" source="./images/windows-365-placement-diagrams-updated-9.svg" alt-text="A diagram of a different traffic flow option from users to apps." lightbox="./images/windows-365-placement-diagrams-updated-9.svg" border="false":::
    The diagram has two sections, geography A and B. Geography A contains Azure region A and a user network, which connect to each other via a Virtual Desktop gateway and a VPN or ExpressRoute connection. Geography B contains Azure region B and LOB apps. Azure region B contains a virtual network. LOB apps connect to the virtual network via a VPN or ExpressRoute connection. A user flow goes from a user in Geography A, to a user network, to the VPN or ExpressRoute connection, to the Virtual Desktop gateway, over the Azure backbone to Geography B, to a virtual network, and finally to the LOB apps.
    :::image-end:::

    *Download a [PowerPoint file](https://arch-center.azureedge.net/windows-365-placement-diagrams-updated-9.pptx) of this architecture.*

## AD DS recommendations

In a Microsoft Entra hybrid join architecture, an on-premises AD DS infrastructure serves as the identity source of authority. A properly configured and healthy AD DS infrastructure improves the success of a Windows 365 deployment.

On-premises AD DS supports many configurations that have various levels of complexity. The following recommendations cover only the baseline best practices.

- For a Microsoft Entra hybrid join scenario, you can [deploy AD DS in Azure VMs](/azure/architecture/example-scenario/identity/adds-extend-domain). You can also use a hybrid network connection to provide a direct line of sight to your on-premises Microsoft Entra domain controller. For more information, see [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz).

- For a Microsoft Entra join scenario, follow the [reference architecture that integrates on-premises Active Directory domains with Microsoft Entra ID](/azure/architecture/reference-architectures/identity/azure-ad).
- Windows 365 uses a watchdog service as part of automated testing. The service creates a test VM account that shows as disabled in the organizational unit that the Azure network connection configuration specifies. Don't delete this account.
- Decommissioned Cloud PCs in the Microsoft Entra hybrid join model leave behind disabled computer accounts that require manual cleanup in AD DS.
- Microsoft Entra Domain Services doesn't support Microsoft Entra hybrid join, so it can't function as the identity source in that setup.

## DNS recommendations

In an Azure network connection deployment architecture, DNS servers or a DNS service in an Azure virtual network serve as crucial dependencies. A healthy infrastructure ensures reliable operation.

- For a Microsoft Entra hybrid join configuration, DNS must resolve the domain that the Cloud PC joins. You have several configuration options. The simplest option is to specify your DNS server IP address in the Azure virtual network configuration. For more information, see [Name resolution that uses your own DNS server](/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances#name-resolution-that-uses-your-own-dns-server).

- For complex infrastructures, such as multiple-region or multiple-domain setups in Azure and on-premises environments, use a service like Azure DNS private zones or [DNS Private Resolver](/azure/architecture/networking/architecture/azure-dns-private-resolver).

## Cloud PC connection recommendations

Set up deployed Cloud PCs to allow uninterrupted connection flow to and from the Virtual Desktop gateway service. When you deploy apps as part of a Windows OS configuration, consider the following recommendations:

- Ensure that the VPS client doesn't launch when the user signs in because it can disconnect the session when the VPN tunnel establishes. Then the user must sign in again.

- Configure the VPN, proxy, firewall, and antivirus and anti-malware apps to allow or bypass traffic for IP addresses `168.63.129.16` and `169.254.169.254`. This architecture uses these IP addresses for communication with Azure platform services, such as metadata and heartbeat.

  For more information, see the following resources:
  - [IP address 168.63.129.16](/azure/virtual-network/what-is-ip-address-168-63-129-16)
  - [Azure Instance Metadata Service for virtual machines](/azure/virtual-machines/instance-metadata-service)
  - [Virtual Network FAQ](/azure/virtual-network/virtual-networks-faq)
- Don't manually modify the IP addresses of Cloud PCs because it might result in permanent disconnection. Azure networking services assign IP addresses with an indefinite lease and manage them throughout the Cloud PC life cycle. For more information, see [Allocation methods](/azure/virtual-network/ip-services/virtual-network-network-interface-addresses?tabs=nic-address-portal#allocation-methods).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Ravishankar Nandagopalan](https://www.linkedin.com/in/ravisn) | Senior Product Manager

Other contributors:

- [Paul Collinge](https://www.linkedin.com/in/paul-collinge-5159b729) | Principal Product Manager
- [Claus Emerich](https://www.linkedin.com/in/claus-bavaria) | Principal Product Manager
- [David Falkus](https://www.linkedin.com/in/david-falkus) | Principal Product Manager
- [Bob Roudebush](https://www.linkedin.com/in/bobroudebush) | Technical Leader and Cloud/Developer Technologist
- [Matt Shadbolt](https://www.linkedin.com/in/mattshadbolt) | Principal Product Manager, Windows Cloud Experiences

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Plan your Cloud PC deployment](/windows-365/enterprise/planning-guide)
- [Windows 365 architecture](/windows-365/enterprise/architecture)
- [Windows 365 identity and authentication](/windows-365/enterprise/identity-authentication)
- [Cloud PC life cycle in Windows 365](/windows-365/enterprise/lifecycle)
- [AD DS overview](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview)
- [Data encryption in Windows 365](/windows-365/enterprise/encryption)
- [Understand Virtual Desktop network connectivity](/azure/virtual-desktop/network-connectivity)

## Related resource

- [Web applications architecture design](/azure/architecture/web-apps/)
