Windows 365 is a cloud-based service that you can use to deliver highly optimized and personalized Windows computing instances called Cloud PCs that are purpose-built for each user's requirements. Cloud PCs use a combination of the following services:

- Intune to customize, secure, and manage Cloud PCs
- Entra ID for identity and access control
- Azure Virtual Desktop for remote connectivity

A Cloud PC is a highly available, optimized, and personalized computing instance that provides you with a rich Windows desktop experience. It's hosted in the Windows 365 service and is accessible from anywhere, on any device.

### The Windows 365 shared responsibility model

Windows 365 is a software as a service (SaaS) solution. Microsoft manages some components in Windows 365 services, and you manage other components. The amount of responsibility you have depends on the architecture pattern you choose for deployment. The responsibilities to manage Windows 365 are split into three parts:

- **Deployment**: Planning and deploying the components of the service.
- **Lifecycle**: Management of the component throughout its lifecycle, such as patching and securing.
- **Configuration**: Configuring the component to apply settings as needed for a scenario.

The following diagram shows the responsibility matrix of a Windows 365 deployment by using the recommended Microsoft-hosted network, Microsoft Entra join, and gallery images with Windows Autopatch. With this configuration, you don't have to manage many components and lifecycle stages. This configuration translates to the benefits listed in [Recommended architecture patterns](#recommended-architecture-pattern).

> [!NOTE]
> The following diagram represents the responsibilities from the infrastructure perspective, such as setting up the hardware and network, and maintaining them. It doesn't include the Windows 365 or Intune tenant subscription setup.

:::image type="content" source="./images/windows-365-placement-diagrams-updated-1.svg" alt-text="A diagram of the responsibility matrix that shows a deployment that uses the Microsoft-hosted network." lightbox="./images/windows-365-placement-diagrams-updated-1.svg" border="false":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/windows-365-placement-diagrams-updated-1.pptx) of this architecture.*

The following diagram shows a typical Windows 365 deployment that uses an Azure network connection and shows the components that Microsoft manages and the components that you manage across the lifecycle stages of a Cloud PC.

:::image type="content" source="./images/windows-365-placement-diagrams-updated-2.svg" alt-text="A diagram of the responsibility matrix, showing a deployment using an Azure network connection." lightbox="./images/windows-365-placement-diagrams-updated-2.svg" border="false":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/windows-365-placement-diagrams-updated-2.pptx) of this architecture.*

### Recommended architecture pattern

Microsoft recommends deploying Windows 365 with the following components to get a SaaS experience, enabling you to have the maximum benefits of the service:

- Microsoft Entra join
- A Microsoft-hosted network
- Gallery images
- Intune-based mobile device management (MDM) service with app and OS configuration
- A Windows 365 app for Cloud PC access

:::image type="content" source="./images/windows-365-placement-diagrams-updated-3.svg" alt-text="A diagram of an architecture pattern, showing benefits of the Windows 365 service." lightbox="./images/windows-365-placement-diagrams-updated-3.svg" border="false":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/windows-365-placement-diagrams-updated-3.pptx) of this architecture.*

The preceding architecture pattern allows you to get the most out of the Windows 365 service and provides the following benefits:

- Simplified and faster deployment
- Minimal to zero dependencies
- Full Zero Trust framework support
- Simplified troubleshooting flows
- Self-service user troubleshooting
- Low overhead and management
- Highest maturity model of software and application delivery

### The Windows 365 service architecture

The following diagram is a representation of all the components that are part of the Windows 365 service. This architecture uses Intune and Microsoft Entra ID, which are core requirements of Windows 365. There are also optional components such as Azure Virtual Network.

:::image type="content" source="./images/windows-365-placement-diagrams-updated-4.svg" alt-text="A diagram of the Azure network connection and Microsoft Hosted Network options." lightbox="./images/windows-365-placement-diagrams-updated-4.svg" border="false":::
*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/w365-azure-network-connection-4.vsdx) of this architecture.*

The previous diagram shows Azure network connection and Microsoft-hosted network options. They're mutually exclusive architecture options. The following sections elaborate on the Azure network connection options.

### Virtual Desktop

Virtual Desktop is an Azure-based virtual desktop infrastructure (VDI) solution. Microsoft manages Virtual Desktop. It provides a platform-as-a-service (PaaS) style solution. Windows 365 uses the network management components required for you to connect to their Cloud PCs. Components include the Virtual Desktop gateway service, a connection broker service, and a web client service. These services allow for seamless connection to Windows 365 Cloud PCs.

For more information, see [Azure Virtual Desktop for the enterprise](../../example-scenario/azure-virtual-desktop/azure-virtual-desktop.yml).

:::image type="content" source="./images/windows-365-placement-diagrams-updated-5.svg" alt-text="A diagram of Windows Virtual Desktop Control Plane components." lightbox="./images/windows-365-placement-diagrams-updated-5.svg" border="false":::
*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/w365-azure-network-connection-5.vsdx) of this architecture.*

> [!NOTE]
> Windows 365 utilizes the components entitled "Windows Virtual Desktop Control Plane" in the previous diagram for facilitating user and Cloud PC connections and as such inherits most of the connection related capabilities of Azure Virtual Desktop. Familiarizing with how Virtual Desktop networking operates then becomes essential to designing the Azure network connection architecture detailed in this document.

### Microsoft Intune

Intune is a cloud-based endpoint management solution that allows you to view and consume reports and manage:

- App delivery
- Windows updates
- Device management configurations
- Security policies

Intune simplifies app and device management across many devices, including mobile devices, desktop computers, and virtual endpoints.

You can protect access and data on organization-owned and personal devices. Intune also has compliance and reporting features that support the Zero Trust security model. For more information, see [Create a device configuration profile](/windows-365/enterprise/create-device-configuration-profile).

## Architecture patterns

An architecture pattern describes components and illustrates the configurations with which a service or product is deployed. For more information, see [*Hosted on behalf of* architecture](/windows-365/enterprise/architecture#hosted-on-behalf-of-architecture).

See the following Azure network connection patterns:

**Azure network connection with Microsoft Entra join** – In this pattern, Microsoft Entra joined Cloud PCs use Azure network connection to connect to resources in on-premises environments, such as line-of-business (LOB) applications, file shares, and other applications that don't need Kerberos or Windows New Technology LAN Manager (NTLM) authentication.

**Azure network connection with Microsoft Entra hybrid join** – In this pattern, Microsoft Entra hybrid joined Cloud PCs use Azure network connection to domain join with an on-premises Microsoft Entra ID domain controller.  The Cloud PC authenticates with the on-premises domain controller when users access the Cloud PC, on-premises apps, or cloud apps that need Kerberos or NTLM authentication.

### Azure network connection architecture patterns

For some patterns, the Windows 365 service connects to on-premises environments via Virtual Network by using Azure ExpressRoute or a site-to-site VPN. This connectivity method is represented by Azure network connection, which is an Intune object. This connection allows the Cloud PCs to connect to on-premises resources such as Active Directory or LOB apps.

This network connection, that's represented by Azure network connection, is used by the Windows 365 service during Cloud PC provisioning for on-premises Microsoft Entra domain joining, [health checks](/windows-365/enterprise/azure-network-connections#first-health-check) for Cloud PC provisioning readiness.

The following tables list dependencies for Azure network connection. Windows 365 runs automatic health checks on these dependencies.

| Dependency | Microsoft Entra Connect - Checks if Microsoft Entra Connect is set up and finishes successfully. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra hybrid join|
| Recommendations | - Set up the Microsoft Entra Connect sync interval with the default or lowest value. Longer sync intervals increase the possibility of the Cloud PC provisioning failing in production due to a timeout. For more information, see [Microsoft Entra hybrid join failing](/windows-365/enterprise/provisioning-errors#hybrid-azure-ad-join-failed). <br> - Set up Active Directory Domain Controller replication from a server in the same datacenter as the Windows 365 Azure network connection to provide faster replication. <br> - Set up Microsoft Entra ID domain controller replication with a default value. |

| Dependency | Azure tenant readiness - Checks if Azure subscription is enabled, with no blocking restrictions, and is ready for use. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join|
| Recommendations | - Use an account with the right privileges to manage the Azure, Intune, and Windows 365 subscriptions. For more information, see [Role-based access control(RBAC)](/windows-365/enterprise/role-based-access). <br> - Disable or modify any Azure policies that prevent the creation of Cloud PCs. For more information, see [Restrict allowed VM SKUs](/azure/lab-services/how-to-use-restrict-allowed-virtual-machine-sku-sizes-policy). <br> - Make sure the subscription has sufficient resource quotas for networking and general limits based on the maximum number of Cloud PCs to be created. Examples include the network gateway size, IP address space, size of the virtual network, and bandwidth required. For more information, see [Networking limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-resource-manager-virtual-networking-limits) and [General limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#general-limits). |

| Dependency | Azure virtual network readiness – Checks if the virtual network is in a supported Windows 365 region. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join|
| Recommendations | - Create the virtual network in a Windows 365 [Supported Azure regions for Cloud PC provisioning](/windows-365/enterprise/requirements?tabs=enterprise%2Cent#supported-azure-regions-for-cloud-pc-provisioning). <br> - Create at least one subnet, in addition to the default subnet, to deploy the Cloud PC virtual network adaptors. <br> - Where possible, create shared network services, such as Azure Firewall, VPN gateways, or ExpressRoute gateways, in a separate virtual network to allow for routing controls and expansion of deployment. <br> In virtual networks, apply network security groups (NSG) with appropriate exclusions to allow the required URLs for the Windows 365 service. For more information, see [Networking requirements](/windows-365/enterprise/requirements-network) and [Network security groups](/azure/virtual-network/network-security-groups-overview). |

| Dependency | Azure subnet IP address usage – Checks if there are sufficient IP addresses available. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join|
| Recommendations | - Create the virtual network with sufficient IP addresses to handle the Cloud PC creation and temporary IP address reservation during reprovision. It's recommended that you use an IP address space that's 1.5 to 2 times the maximum Cloud PCs that you deploy for the cloud. For more information, see [General network requirements](/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent#general-network-requirements). <br> - Treat the Azure virtual network as a logical extension of your on-premises network, and assign unique IP address space across all your networks to avoid routing conflicts. |

| Dependency | Endpoint connectivity – Checks if the external URLs needed for the Cloud PC provisioning are reachable from the virtual network. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join|
| Recommendations | - Allow all the URLs needed for the Cloud PC provisioning via the Azure virtual network. For more information, see [Allow network connectivity](/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent#allow-network-connectivity). <br> - Use Azure Firewall to take advantage of Windows 365, Azure Virtual Desktop, and Intune [FQDN tags](/azure/firewall/fqdn-tags) to create application rules and allow URLs needed for the Windows 365 Cloud PC provisioning. For more information, see [Use Azure Firewall to manage and secure Windows 365 environments](/windows-365/enterprise/azure-firewall-windows-365). <br> - Bypass or exclude Remote Desktop Protocol (RDP) traffic from any network inspection, proxying, or manipulation device to avoid latency and routing issues. For more information, see [Traffic interception technologies](/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent#traffic-interception-technologies). <br> - From the end user device and network side, allow the Windows 365 service URLs and ports for proxy and network inspections. <br> - Allow Azure internal IP addresses 168.63.129.16 and 169.254.169.254, as these IP addresses are used for communication with Azure platform services such as metadata or heartbeat. For more information, see [What is IP address 168.63.129.16?](/azure/virtual-network/what-is-ip-address-168-63-129-16), [Azure Instance Metadata Service](/azure/virtual-machines/instance-metadata-service?tabs=windows), and [Virtual Network FAQ](/azure/virtual-network/virtual-networks-faq). |

| Dependency | Intune enrollment – Checks if Intune allows Windows enrollment. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join|
| Recommendations | - Ensure that Intune device type enrollment restrictions are set to allow the Windows mobile device management (MDM) platform for corporate enrollment. <br> - For Microsoft Entra hybrid join, set up devices automatically by configuring the service connection point (SCP) for each domain in Microsoft Entra Connect or by using the targeted deployment model. For more information, see [Configure Microsoft hybrid join](/entra/identity/devices/how-to-hybrid-join#prerequisites) and [Microsoft Entra hybrid join targeted deployment](/entra/identity/devices/hybrid-join-control). |

| Dependency | First-party app permissions – Checks the Windows 365 app for permissions on the customer Azure subscription, resource group, and virtual network levels. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join|
| Recommendations | - Ensure the account used for setting up the Azure network connection has read permissions on the Azure subscription in which the Azure virtual network is created. <br> - Ensure in the Azure subscription that there are no policies in place that block permissions for the Windows 365 first-party app. The app must have permissions at the subscription, resource group, and virtual network level. For more information, see [Azure requirements](/windows-365/enterprise/requirements?tabs=enterprise%2Cent#azure-requirements). |

| Dependency | Localization language pack – Checks if the language pack download locations are reachable. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join|
| Recommendations | - Ensure the URLs needed for the appropriate version of Windows images are allowed via firewall rules used in the Azure virtual network. For more information, see [Provide a localized Windows experience](/windows-365/enterprise/provide-localized-windows-experience). |

| Dependency | RDP Shortpath – Checks if the User Datagram Protocol (UDP) configurations are in place for you to connect. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join|
| Recommendations |- Enable RDP Shortpath for Cloud PC access to take advantage of UDP's resilience. For more information, see [Use RDP Shortpath for public networks with Windows 365](/windows-365/enterprise/rdp-shortpath-public-networks) and [Use RDP Shortpath for private networks with Windows 365](/windows-365/enterprise/rdp-shortpath-private-networks). |

| Dependency | Intune license – Checks if the tenant has appropriate Intune licenses to use Windows. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join|
| Recommendations | - Ensure Intune licenses are assigned to you in accordance with the [licensing requirements](/windows-365/enterprise/requirements?tabs=enterprise%2Cent#licensing-requirements). |

| Dependency | Single sign-on (SSO) check – Checks if the Kerberos server object is created in Active Directory and synced to Microsoft Entra ID. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join |
| Recommendations | - Ensure that the SSO option is selected in the provisioning policy. This option enables you to connect to the policy's Cloud PC by using sign in credentials from an Intune-managed physical device that's domain joined or Microsoft Entra joined. For more information, see [Continue creating provisioning policies](/windows-365/enterprise/create-provisioning-policy#continue-creating-a-provisioning-policy). |

| Dependency | DNS name resolution – Checks if the DNS in the Azure network connection can resolve on-premises Active Directory domain. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join|
| Recommendations | - Ensure the Azure virtual network is configured with the name resolution of an on-premises Microsoft Entra domain by using a custom DNS, a private DNS, or a private resolver. For more information, see [What is Azure DNS?](/azure/dns/dns-overview) <br> - Ensure the DNS servers configured in the virtual network are in the same geography and have the ability to register newly provisioned Cloud PCs without delays. Avoid DNS referral or redirections to prevent propagation delays, which can result in provisioning delays or failures. |

| Dependency | Microsoft Entra domain join – Checks that the credentials provided for Microsoft Entra domain join are valid and Cloud PCs can be domain joined. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join |
| Recommendations | - Ensure the account provided for Microsoft Entra domain join has permissions on the Microsoft Entra organizational unit specified in the Azure network connection configuration. <br> - Ensure the account provided isn't a standard user account with a domain join limitation. For more information, see [Default limit to number of workstations a user can join to the domain](/troubleshoot/windows-server/identity/default-workstation-numbers-join-domain). <br> - Ensure the account specified is synced to Microsoft Entra ID. <br> - Ensure the OU specified in the Azure network connection doesn't have any object limits. For more information, see [Increase the computer account limit in the organizational unit](/mem/autopilot/windows-autopilot-hybrid#increase-the-computer-account-limit-in-the-organizational-unit). |

For more information, see [Azure network connection health checks in Windows 365](/windows-365/enterprise/health-checks#supported-checks).

## Azure network connection building blocks recommendations

This section provides the breakdown of building blocks of the Windows 365 Azure network connection architecture pattern.

### Azure subscription

Windows 365 usage in an Azure network connection architecture pattern involves two types of Azure subscriptions, a Microsoft subscription and a customer subscription

Windows 365 uses the *Hosted on behalf of* model to deliver services to Windows 365 customers. In this model, the Cloud PC is provisioned and run in Azure subscriptions owned by Microsoft, while the network adapter of the Cloud PC is provisioned in a customer's Azure subscription. The following diagrams show two Azure network connection architecture patterns. Customers use their own Azure subscription and virtual network.

:::image type="content" source="./images/windows-365-placement-diagrams-updated-6.svg" alt-text="A diagram of the architecture pattern using the Microsoft Entra join identity." lightbox="./images/windows-365-placement-diagrams-updated-6.svg" border="false":::
*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/w365-azure-network-connection-6.vsdx) of this architecture.*

The previous architecture pattern uses the Microsoft Entra join identity to manage the Cloud PC.

:::image type="content" source="./images/windows-365-placement-diagrams-updated-7.svg" alt-text="A diagram of the architecture pattern using the Microsoft Entra hybrid join identity." lightbox="./images/windows-365-placement-diagrams-updated-7.svg" border="false":::
*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/w365-azure-network-connection-7.vsdx) of this architecture.*

The previous architecture pattern uses Microsoft Entra hybrid join identity to manage the Cloud PC and requires a *line of sight* network communication with Active Directory Domain Services (AD DS) domain controllers in on-premises environments.

| Component | Azure subscription – Azure subscription that hosts the virtual network used for providing connectivity for a Cloud PC to an on-premises environment and the internet. |
| --- | --- |
| Architecture patterns | Azure network connection for Microsoft Entra join, Azure network connection for Microsoft Entra hybrid join|
| Recommendations | - Create or use a subscription that has a virtual network and ExpressRoute or VPN gateways to provide a connection back to an on-premises environment. <br> - Create a dedicated resource group for a Cloud PC to provide permission and resources management. <br> - Exclude Cloud PC resource groups and virtual network from Azure policies that prevent automatic creation and deletion of virtual network interface card (vNIC) objects, and IP address assignment or release. For more information, see [Lock your resources to protect your infrastructure](/azure/azure-resource-manager/management/lock-resources?tabs=json) and [Azure requirements](/windows-365/enterprise/requirements?tabs=enterprise%2Cent#azure-requirements). <br> - Create dedicated virtual networks for better IP address management and routing controls. |

### Virtual Network and hybrid connection

Windows 365 Azure network connection-based architecture patterns require one or more Azure virtual networks. The virtual networks provide connectivity to on-premises environments and over the internet for provisioning a Cloud PC. The virtual network adapter of the Cloud PC is provisioned in the Azure virtual network of the customer-owned subscription as described in the [Azure subscription](#azure-subscription) section.

Azure networking can be deployed with varying design sophistication, based on the existing on-premises networking or Azure networking. To get started with a basic hybrid network design, see [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz?tabs=portal).

Consider the following factors when you design an Azure virtual network architecture:

- *IP address space*: The size of IP address space depends on the number of Cloud PCs to support. Plan for at least 1.5 times the maximum number of Cloud PCs that are deployed. The additional IP addresses account for IP addresses used during provisioning and deprovisioning of Cloud PCs.

- *Name resolution*: The DNS process used by the Cloud PC to resolve the on-premises domain name in a Microsoft Entra hybrid join deployment or to resolve internet resources or Azure resources in a Microsoft Entra join deployment model.
  - To use your existing on-premises DNS infrastructure, configure the IP addresses of one or more DNS servers for name resolution. For more information, see [DNS requirements](/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent#dns-requirements).
  - Ensure the DNS server IP used in the Azure virtual network belong to the same geography as the Cloud PC and that it doesn't redirect DNS registration requests to another region. Otherwise, it results in delayed or failed deployments and Azure network connection health checks.
  - For Azure DNS-based name resolution, use the public or private Azure DNS or the private resolver option. For more information, see [Azure DNS documentation](/azure/dns/).

- *Network topology*: Azure networking supports topologies to accommodate different use cases.

  - *Hub-spoke topology with virtual network peering*: This topology is the simplest way to provide an isolation of services with their own spoke and hub virtual networks. Shared services include Azure Firewall and network gateways. Choose this topology if you have a simple, single-site design to deploy a Cloud PC in one or more spoke virtual networks. For more information, see [Hub-and-spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology).
  - *Hub-spoke topology with Azure Virtual WAN*: Virtual WAN is an Azure networking service that brings together networking, security, and management capabilities that enable complex network requirements. Use this topology for multi-site, multi-region deployments with specific firewalling and routing requirements. For more information, see [Hub-spoke network topology with Virtual WAN](/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture).

- *Network gateway*: Azure network gateways provide connectivity from a virtual network to an on-premises network. There are VPN and ExpressRoute network gateways. Ensure that the maximum bandwidth requirements of a Cloud PC are considered before deciding on the ExpressRoute or VPN method of connectivity. Both VPN and ExpressRoute gateways are offered in tiers, or SKUs, that differ in the amount of bandwidth provided and other metrics. For more information, see [Extend an on-premises network using ExpressRoute](/azure/architecture/reference-architectures/hybrid-networking/expressroute) and [Connect an on-premises network to Azure using ExpressRoute](/azure/architecture/reference-architectures/hybrid-networking/expressroute-vpn-failover).

## Routing configurations

Windows 365 Azure network connection service uses automated health checks to determine the health and readiness of the customer's environment to provision Microsoft Entra join or Microsoft Entra hybrid join Cloud PCs in an Azure network connection-based architecture. Without proper routing configurations in your Azure virtual network and associated networking services, there's a high likelihood of failures or delays in your Cloud PC deployment. Consider the following recommendations to optimize routing for the Windows 365 network architecture:

- *Allowlist required URLs*: Each Cloud PC deployed in Microsoft Entra hybrid join and Microsoft Entra join Azure network connection model requires several URLs to be allowed through OS anti-virus, network firewalls, and load balancers. Ensure all the URLs are allowed. For more information, see [Allow network connectivity](/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent#allow-network-connectivity).

- *Use Azure FQDN tags*: When you use the Azure Firewall service, use Azure FQDN tags to allow required URLs for Azure Virtual Desktop, Windows 365, and Intune. For more information, see [Use Azure Firewall to manage and secure Windows 365 environments](/windows-365/enterprise/azure-firewall-windows-365).

- *Enable pass-through*: Windows 365 uses the RDP protocol, which is sensitive to latency introduced by traffic inspection devices such as a firewall or an SSL decryption appliance. Such latency can result in a poor experience, so disable traffic inspection of these URLs and instead enable pass-through. For more information, see [Traffic interception technologies](/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent#traffic-interception-technologies).

- *Bypass proxy*: Cloud and traditional proxy services, while suitable for internet access, introduce latency in RDP connections. This latency happens when the connection from the end user's physical device or from the Cloud PC is forced through a proxy and results in frequent disconnections, lags, and sluggish response times. Set **.wvd.microsoft.com* and [Windows 365 gateway IP ranges](https://github.com/microsoft/Windows365-PSScripts/tree/main/Windows%20365%20Gateway%20IP%20Lookup) to bypass proxy services on the user's physical device, the network the physical device is connected to, and in the Cloud PC. <br>

For more information, see [Optimizing RDP connectivity for Windows 365](https://techcommunity.microsoft.com/t5/windows-365/optimizing-rdp-connectivity-for-windows-365/m-p/3554327).

- *Shortest path routing*: Ensure RDP traffic from a Cloud PC reaches Virtual Desktop service endpoints via the shortest path. The ideal path is from a virtual network, directly to the Virtual Desktop gateway IP via the internet. Also ensure RDP traffic from the end user's physical device reaches the Virtual Desktop gateway IP directly. This configuration ensures optimal routing and doesn't degrade the user experience. Avoid routing RDP traffic to the internet via cloud proxy services or on-premises networks.

- *RDP Shortpath*: Enable RDP Shortpath-based access for end user networks, Azure networks, and Cloud PCs. RDP Shortpath uses UDP to transmit RDP traffic. Unlike TCP, it's resilient to high latency network connections. UDP also takes maximum advantage of the available network bandwidth to efficiently transfer RDP packets, which leads to an improved user experience. For more information, see [Use RDP Shortpath for public networks with Windows 365](/windows-365/enterprise/rdp-shortpath-public-networks).

- *Cloud PC placement*: For an optimal user experience and routing performance, determine where customers are in relation to the work apps or network they access. Also consider the time customers spend accessing the LOB apps compared to the overall time that they access other apps. See the following two possible deployment options:

  - The following deployment model might be optimal if customers spend most of their work time accessing the LOB apps rather than work on locally installed apps, like apps in Microsoft 365. This model optimizes latency for LOB apps vs. Cloud PC access latency by placing the Cloud PC in the same region as the LOB app (Geography B). This optimization occurs even though the gateway is geographically closer to the end user (Geography A). The following diagram shows the possible traffic flow from the end user to the LOB apps.

    :::image type="content" source="./images/windows-365-placement-diagrams-updated-8.svg" alt-text="A diagram of a flow chart, showing a possible traffic flow from users to apps." lightbox="./images/windows-365-placement-diagrams-updated-8.svg" border="false":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/windows-365-placement-diagrams-updated-8.pptx) of this architecture.*

  - If customers occasionally access the LOB apps in Geography B, then deploying a Cloud PC closer to the customers might be optimal because it optimizes the Cloud PC access latency over LOB apps access latency. The following diagram shows how the traffic might flow in such a scenario.

    :::image type="content" source="./images/windows-365-placement-diagrams-updated-9.svg" alt-text="A diagram of a flow chart that shows a possible traffic flow from users to apps." lightbox="./images/windows-365-placement-diagrams-updated-9.svg" border="false":::
*Download a [PowerPoint file](https://arch-center.azureedge.net/windows-365-placement-diagrams-updated-9.pptx) of this architecture.*

## AD DS recommendations

In a Microsoft Entra hybrid join architecture, an on-premises AD DS infrastructure acts as the identity source of authority. Having a properly configured and healthy AD DS infrastructure is a crucial step to make the Windows 365 deployment successful.

On-premises AD DS supports many configurations and varying levels of complexity, so the recommendations provided only cover the baseline best practices.

- For Microsoft Entra hybrid join scenario, you can deploy AD DS in Azure VMs as described in the architecture reference in [Deploy AD DS in a virtual network](/azure/architecture/example-scenario/identity/adds-extend-domain?source=recommendations). You can also use a hybrid network connection to provide a direct line of sight to your on-premises Microsoft Entra domain controller. For more information, see [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz?tabs=portal).
- For Microsoft Entra join deployment, follow the reference architecture in [Integrate on-premises Microsoft Entra domains with Microsoft Entra ID](/azure/architecture/reference-architectures/identity/azure-ad).
- Windows 365 uses a watchdog service as part of automated testing that creates a test VM account. That account shows as disabled in the organizational unit specified in Azure network connection configuration. Don't delete this account.
- Any Cloud PC that's decommissioned in the Microsoft Entra hybrid join model leaves behind a disabled computer account, which needs to be cleaned manually in AD DS.
- Microsoft Entra Domain Services isn't supported as an identity source because it doesn't support Microsoft Entra hybrid join.

## DNS recommendations

In an Azure network connection deployment architecture, DNS servers or another DNS service used by an Azure virtual network is a crucial dependency. It's important to have a healthy infrastructure in place.

- For a Microsoft Entra hybrid join configuration, DNS should be able to resolve the domain to which the Cloud PC needs to be joined. There are multiple configuration options available, the simplest of them being specifying your DNS server IP in the Azure virtual network configuration. For more information, see [Name resolution that uses your own DNS server](/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances?tabs=redhat#name-resolution-that-uses-your-own-dns-server).
- Depending on the complexity of the infrastructure, such as a multi-region, multi-domain setup in Azure and on-premises environments, you should use a service like Azure DNS private zones or [Azure DNS Private Resolver](/azure/architecture/networking/architecture/azure-dns-private-resolver).

## Cloud PC connection recommendations

Deployed Cloud PCs should be configured to allow uninterrupted connection flow to and from the Virtual Desktop gateway service. Consider the following recommendations when you deploy apps as part of a Windows operating system configuration:

- Ensure that the VPS client doesn't launch when the user signs in because it can disconnect the session when the VPN tunnel establishes. The user would have to sign in a second time.
- Configure the VPN, proxy, firewall, and antivirus and antimalware apps to allow or bypass traffic bound for IP addresses 168.63.129.16 and 169.254.169.254. These IP addresses are used for communication with Azure platform services such as metadata and heartbeat. For more information, see [What is IP address 168.63.129.16?](/azure/virtual-network/what-is-ip-address-168-63-129-16), [Azure Instance Metadata Service for virtual machines](/azure/virtual-machines/instance-metadata-service?tabs=windows), and [Virtual Network FAQ](/azure/virtual-network/virtual-networks-faq).
- Don't manually modify the IP addresses of Cloud PCs because it might result in permanent disconnection. IP addresses are assigned with an indefinite lease and managed throughout the lifecycle of the Cloud PC by Azure networking services. For more information, see [Allocation methods](/azure/virtual-network/ip-services/virtual-network-network-interface-addresses?tabs=nic-address-portal#allocation-methods).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Ravishankar Nandagopalan](https://www.linkedin.com/in/ravisn) | Senior Product Manager

Other contributors:

- [Paul Collinge](https://www.linkedin.com/in/paul-collinge-5159b729) | Principal Product Manager
- [Claus Emerich](https://www.linkedin.com/in/claus-bavaria) | Principal Product Manager
- [David Falkus](https://www.linkedin.com/in/david-falkus) | Principal Product Manager
- [Bob Roudebush](https://www.linkedin.com/in/bobroudebush) | Technical Leader and Cloud/Developer Technologist
- [Matt Shadbolt](https://www.linkedin.com/in/mattshadbolt) | Principal Product Manager, Windows Cloud Experiences

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

[Plan your Cloud PC deployment](/windows-365/enterprise/planning-guide)

[Windows 365 architecture](/windows-365/enterprise/architecture)

[Windows 365 identity and authentication](/windows-365/enterprise/identity-authentication)

[Cloud PC lifecycle in Windows 365](/windows-365/enterprise/lifecycle)

## Related resources

[Active Directory Domain Services overview](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview)

[Data encryption in Windows 365](/windows-365/enterprise/encryption)

[Understanding virtual desktop network connectivity](/azure/virtual-desktop/network-connectivity)

[Web applications architecture design](/azure/architecture/web-apps/)