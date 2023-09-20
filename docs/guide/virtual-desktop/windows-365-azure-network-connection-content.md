Windows 365 is a cloud-based service that delivers highly optimized and personalized Windows computing instances called Cloud PCs that are purpose built for each user's requirements by using a combination of the following services:

- Microsoft Intune to customize, secure and manage Cloud PCs.
- Entra ID for identity and access control.
- Azure Virtual Desktop for remote connectivity.

A Cloud PC is a highly available, optimized, and personalized computing instance providing end users with a rich Windows desktop experience. It's hosted in the Windows 365 service and is accessible from anywhere, on any device.

### Windows 365 shared responsibility model

Windows 365 is delivered in a Software as a Service (SaaS) model and as such there are components in Windows 365 services that are managed by Microsoft, and some are managed by the customer. Depending on the architecture pattern you choose for Windows 365 deployment, the number of responsibility areas increases for the customer to manage. The responsibilities to manage Windows 365 are split into three parts:

1. **Deployment** – Planning and deploying the components of the service.
2. **Lifecycle** – Management of the component throughout its lifecycle, such as patching, securing, etc.
3. **Configuration** – Configuring the component to apply settings as needed for a scenario.

The following diagram shows the responsibility matrix of a Windows 365 deployment by using the recommended Microsoft Hosted Network (MHN), Azure AD Join (AADJ), and gallery images with Windows Autopatch. The number of components and lifecycle stages that a customer manages is reduced drastically in this configuration, which translates to the benefits listed in [Recommended architecture patterns](#recommended-architecture-pattern).

> [!NOTE]
> The diagrams represent the responsibilities from the infrastructure perspective, such as setting up the hardware, network, maintaining them etc., not the Windows 365 or Intune tenant subscription setup.

![Diagram of the responsibility matrix, showing a deployment using the Microsoft Hosted Network.](RackMultipart20230915-1-7a5xf3_html_87260256609b236b.png)
*Download a [PowerPoint file](https://arch-center.azureedge.net/W365-Placement-Diagrams.pptx) of this architecture.*

The following diagram shows a typical Windows 365 deployment by using an Azure Network Connection (ANC) and shows the various components that Microsoft manages and those that are the customer's responsibility to manage across the various lifecycle stages of a Cloud PC.

![Diagram of the responsibility matrix, showing a deployment using an Azure Network Connection.](RackMultipart20230915-1-7a5xf3_html_9132951794e0900.png)
*Download a [PowerPoint file](https://arch-center.azureedge.net/W365-Placement-Diagrams.pptx) of this architecture.*

### Recommended architecture pattern

Microsoft recommends deploying Windows 365 with the following components to get a SaaS experience, enabling you to enjoy the maximum benefits of the service:

- Azure AD Join
- Microsoft Hosted Network (MHN)
- Gallery Images
- Intune based MDM with App and OS configuration.
- Windows 365 App for Cloud PC access

![Diagram of an architecture pattern, showing beneftis of the Windows 365 service.](RackMultipart20230915-1-7a5xf3_html_cedec8695b1fc12a.png)
*Download a [PowerPoint file](https://arch-center.azureedge.net/W365-Placement-Diagrams.pptx) of this architecture.*

This architecture pattern offers the following benefits, while allowing customer admins and users to get the maximum benefits out of Windows 365 service:

1. Simplified and faster deployment
1. Minimal to Zero dependencies
1. Full Zero Trust framework support
1. Simplified troubleshooting flows
1. Self-service user troubleshooting
1. Least admin overhead and management
1. Highest maturity model of software and application delivery

### Windows 365 service architecture

The following diagram is a representation of all the components that are part of a Windows 365 service. This architecture contains Intune, Azure AD etc., which are core requirements of Windows 365, as well as the optional components such as Azure Virtual Network that customers can bring.

![Diagram of the Azure Network Connection and Microsfot Hosted Network options.](RackMultipart20230915-1-7a5xf3_html_da4af9279ecbc3d2.png)
*Download a [PowerPoint file](https://arch-center.azureedge.net/W365-Placement-Diagrams.pptx) of this architecture.*

> [!NOTE]
> The previous diagram shows both Azure Network Connection and Microsoft Hosted Network options, while they are mutually exclusive architecture options. The following sections further elaborate on the Azure Network Connection architecture options.

### Azure Virtual Desktop

Azure Virtual Desktop (AVD) is an Azure based VDI solution that allows customers to use a VDI Service that's managed by Microsoft and provided in a Platform-as-a-Service style (PaaS). Windows 365 uses the network management components required for Windows 365 customers to connect to their Cloud PCs, such as the AVD gateway service, connection broker service, web client service, etc. These services allow for seamless connection to Windows 365 Cloud PCs.

Learn more about [Azure Virtual Desktop for the enterprise](/azure/architecture/example-scenario/wvd/windows-virtual-desktop)

![Diagram of Windows Virtual Desktop Controle Plane components.](RackMultipart20230915-1-7a5xf3_html_f53cbfcdaea2814a.png)
*Download a [PowerPoint file](https://arch-center.azureedge.net/W365-Placement-Diagrams.pptx) of this architecture.*

> [!NOTE]
> Windows 365 utilizes the components entitled "Windows Virtual Desktop Control Plane" in the previous diagram for facilitating user and Cloud PC connections and as such inherits most of the connection related capabilities of Azure Virtual Desktop. Familiarizing with how AVD networking operates then becomes essential to designing the Azure Network Connection architecture detailed in this document.

### Microsoft Intune

Microsoft Intune is a cloud-based endpoint management solution that allows Windows 365 admins to view and consume reporting and also to manage:

- App delivery
- Windows updates
- Device management configurations
- Security policies

Intune simplifies app and device management across many devices, including mobile devices, desktop computers, and virtual endpoints.

You can protect access and data on organization-owned and users' personal devices. Intune also has compliance and reporting features that support the Zero Trust security model. Learn more about Cloud PC device management by using Intune. Learn more about [Create a device configuration profile](/windows-365/enterprise/create-device-configuration-profile).

## Architecture patterns

Architecture pattern refers to the combination of components and their configurations with which a service or product is deployed. Learn more about the ["Hosted on behalf of" architecture](/windows-365/enterprise/architecture#hosted-on-behalf-of-architecture).

The following are two types of Azure Network Connection patterns:

**ANC with Azure AD Join** – In this pattern, Azure AD Joined Cloud PCs use ANC to connect to resources in on-premises, such as line of business applications, file shares, and more that don't need Kerberos/NTLM authentication.

**ANC with Hybrid Azure AD Join** – In this pattern, Hybrid Azure AD Joined Cloud PCs use ANC to domain join with an on-premises Active Directory Domain Controller (DC) and to authenticate with on-premises DC when users access the Cloud PC and on-premises and/or cloud apps that need Kerberos/NTLM authentication.

### Azure Network Connection architecture patterns

One set of patterns allows for Windows 365 service to connect to on-premises via Azure Virtual Network by using ExpressRoute or Site-to-Site VPN. This connectivity method is represented by an Intune object called Azure Network Connection (ANC) that allows the Cloud PCs to connect to on-premises resources such as Active Directory, line of business apps, etc.

This network connection represented by ANC is used by the Windows 365 service during Cloud PC provisioning for on-premises AD domain joining, [First health checks](/windows-365/enterprise/azure-network-connections#first-health-check) for Cloud PC provisioning readiness, etc.

The following is a list of dependencies for Azure Network Connection, for which Windows 365 runs automatic checks in the form of health checks.

| **Dependency** | Azure AD Sync – Checks if AAD Sync is setup and completed successfully |
| --- | --- |
| **Architecture Patterns** | ANC for Hybrid Azure AD Join |
| **Recommendations** | - Setup Azure AD Connect sync interval with default or lowest value, as longer sync intervals increase the possibility of Cloud PC provisioning failing in production due to timeout. Learn more about [Microsoft Entra hybrid join failing](/windows-365/enterprise/provisioning-errors#hybrid-azure-ad-join-failed). <br> - Setup AD Domain Controller replication from a server in the same datacenter as Windows 365 Azure Network Connection location to provide faster replication. <br> - Setup AD DC replication with default value |

| **Dependency** | Azure tenant readiness – Azure subscription is enabled, no restrictions blocking and ready for use |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join |
| **Recommendations** | - Use an account with the right privileges to manage Azure subscription, Intune and Windows 365 subscription. Learn more about [Role-based access control](/windows-365/enterprise/role-based-access). <br> - Disable/modify any Azure policies that can prevent creation of Cloud PCs. Learn more about how to [Restrict allowed VM SKUs](/azure/lab-services/how-to-use-restrict-allowed-virtual-machine-sku-sizes-policy) <br> - Make sure the subscription has sufficient resource quotas for networking and general limits based on the maximum number of Cloud PCs to be created, such as network gateway size, IP address space size of VNET, bandwidth required etc. Learn more about [Networking limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-resource-manager-virtual-networking-limits) and [General limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#general-limits). |

| **Dependency** | Azure VNET readiness – VNET is in a supported Windows 365 region |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join |
| **Recommendations** | - Create the Azure Virtual Network (VNET) in Windows 365 [Supported Azure regions for Cloud PC provisioning](/windows-365/enterprise/requirements?tabs=enterprise%2Cent#supported-azure-regions-for-cloud-pc-provisioning). <br> - Create at least one subnet, in addition to the default subnet, to deploy Cloud PC virtual network adaptors (vNIC). <br> - Where possible, create shared network services such as Firewall, VPN/ExpressRoute gateways, etc. in a separate VNET to allow for routing controls and expansion of deployment. <br> Apply VNET Network Security Group (NSG) with appropriate exclusions to allow required URLs for Windows 365 service as documented in the [Networking requirements](/windows-365/enterprise/requirements-network). Learn more about [Network security groups](/azure/virtual-network/network-security-groups-overview). |

| **Dependency** | Azure subnet IP address usage – Sufficient IP addresses available |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join |
| **Recommendations** | - Create the VNET with sufficient IP addresses to handle Cloud PC creation and temporary IP address reservation during reprovision. We recommend you use an IP address space that's 1.5 to 2 times the maximum Cloud PCs that will be deployed. Learn more about [General network requirements](/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent#general-network-requirements). <br> - Treat the Azure VNET as a logical extension of your on-premises network(s) and assign unique IP address space across all your networks to avoid routing conflicts. |

| **Dependency** | Endpoint connectivity – External URLs needed for CPC provisioning are reachable from the VNET |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join |
| **Recommendations** | - Allow all the URLs needed for Cloud PC provisioning via Azure VNET. Learn more about how to [Allow network connectivity](/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent#allow-network-connectivity). <br> - Use Azure Firewall to take advantage of Windows 365, Azure Virtual Desktop and Intune [FQDN tags](/azure/firewall/fqdn-tags) to create application rules and allow URLs needed for Windows 365 Cloud PC provisioning. Learn more about how to [Use Azure Firewall to manage and secure Windows 365 environments](/windows-365/enterprise/azure-firewall-windows-365). <br> - Bypass/Exclude RDP traffic from any network inspection, proxying or manipulation device, to avoid additional latency and routing issues. Learn more about [Traffic interception technologies](/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent#traffic-interception-technologies). <br> - Allow Windows 365 service URLs and ports from proxy, network inspection etc., from the end user device and network side. <br> - Allow Azure internal IP addresses 168.63.129.16 and 169.254.169.254, as these IP addresses are used for communication with Azure platform services such as meta data, heartbeat etc. Learn more about [What is IP address 168.63.129.16?](/azure/virtual-network/what-is-ip-address-168-63-129-16), [Azure Instance Metadata Service](/azure/virtual-machines/instance-metadata-service?tabs=windows) and [Azure Virtual Network FAQ](/azure/virtual-network/virtual-networks-faq). |

| **Dependency** | Intune enrollment – Checks Intune allows Windows enrollment |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join |
| **Recommendations** | - Ensure that Intune device type enrollment restrictions are set to Allow Windows (MDM) platform for corporate enrollment. <br> - For Hybrid Azure AD Join, setup devices automatically by configuring service connection point (SCP) for each domain in Azure AD Connect or by using the targeted deployment model. Learn more about how to [Configure hybrid Azure Active Directory join](/azure/active-directory/devices/howto-hybrid-azure-ad-join#prerequisitese) and [Hybrid Azure AD join targeted deployment](/azure/active-directory/devices/hybrid-azuread-join-control). |

| **Dependency** | First party app permissions – Checks Windows 365 app for permissions on the customer Azure subscription, resource group and VNET levels |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join |
| **Recommendations** | - Ensure the account used for setting up Azure Network Connection has at least read permissions on the Azure subscription in which Azure VNET is created. <br> - Ensure in the Azure subscription, there are no policies in place that block permissions for Windows 365 first party app to provide itself permissions at subscription, resource group and VNET. Learn more about [Azure requirements](/windows-365/enterprise/requirements?tabs=enterprise%2Cent#azure-requirements). |

| **Dependency** | Localization language pack – Verifies the language pack download locations are reachable |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join |
| **Recommendations** | - Ensure the URLs needed for the appropriate version of Windows images are allowed via firewall rules used in the Azure VNET. Learn more about how to [Provide a localized Windows experience](/windows-365/enterprise/provide-localized-windows-experience). |

| **Dependency** | RDP Shortpath – Checks if UDP configurations are in place for users to connect |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join |
| **Recommendations** |- Enable RDP shortpath for Cloud PC access to take advantage of UDP's resilience. Learn more about how to [Use RDP Shortpath for public networks with Windows 365](/windows-365/enterprise/rdp-shortpath-public-networks) and how to [Use RDP Shortpath for private networks with Windows 365](/windows-365/enterprise/rdp-shortpath-private-networks). |

| **Dependency** | Intune License – Checks if the tenant has appropriate Intune licenses to use Windows |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join |
| **Recommendations** | - Ensure Intune licenses are assigned for the users as described in [Licensing requirements](/windows-365/enterprise/requirements?tabs=enterprise%2Cent#licensing-requirements). |

| **Dependency** | SSO Check – Verifies Kerberos server object is created in AD and synced to AAD |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join (Future) |
| **Recommendations** | - Ensure Single Sign-on (SSO) option is selected in the provisioning policy. This option enables users to connect to their Cloud PC by using logged in credentials in from an Intune managed physical device that's domain joined or AAD joined. Learn more about how to [Continue creating provisioning policies](/windows-365/enterprise/create-provisioning-policy#continue-creating-a-provisioning-policy). |

| **Dependency** | DNS Name Resolution – Checks DNS in ANC can resolve on-premises AD domain |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join |
| **Recommendations** | - Ensure the Azure VNET is configured with name resolution of on-premises AD domain by using (a) Custom DNS OR (b) Private DNS OR (c) Private resolver. Learn more about [What is Azure DNS?](/azure/dns/dns-overview). <br> - Ensure the DNS servers configured in the VNET are in the same geography and has the ability to register newly provisioned Cloud PCs without delays. Avoid DNS referral/redirections to prevent propagation delays, which can result in provisioning delays or failures. |

| **Dependency** | AD Domain Join – Checks the credentials provided for AD domain join are valid and Cloud PCs can be domain joined. |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join |
| **Recommendations** | - Ensure the account provided for AD domain join has permissions on the AD OU specified in the ANC configuration. <br> - Ensure the account provided isn't a standard user account with domain join limitation. Learn more about the [Default limit to number of workstations a user can join to the domain](/troubleshoot/windows-server/identity/default-workstation-numbers-join-domain). <br> - Ensure the account specified is synced to Azure AD as well. <br> - Ensure the OU specified in the ANC doesn't have any object limits. Learn more about how to [Increase the computer account limit in the Organizational Unit](/mem/autopilot/windows-autopilot-hybrid#increase-the-computer-account-limit-in-the-organizational-unit). |

Learn more about [Azure Network Connection health checks in Windows 365](/windows-365/enterprise/health-checks#supported-checks).

## ANC building blocks recommendations

This section provides the breakdown of various building blocks of a Windows 365 ANC architecture pattern.

### Azure subscription

Windows 365 usage in ANC architecture pattern involves two types of Azure subscriptions:

- Microsoft subscription
- Customer subscription

Windows 365 uses the "Hosted on behalf of" model to deliver services to Windows 365 customers. In this model, the Cloud PC is provisioned and run in Azure subscriptions owned by Microsoft, while the network adapter of the Cloud PC is provisioned in a customer's Azure subscription. The following are the two ANC based architecture patterns where customers bring their own Azure subscription and VNET.

![Diagram of the architecture pattern using the Azure AD Join identity.](RackMultipart20230915-1-7a5xf3_html_72efd7c21bab9075.png)
*Download a [PowerPoint file](https://arch-center.azureedge.net/W365-Placement-Diagrams.pptx) of this architecture.*

The previous architecture pattern uses the Azure AD Join identity to manage the Cloud PC.

![Diagram of the architecture pattern using the Hybrid Azure AD Join identity.](RackMultipart20230915-1-7a5xf3_html_479ef4bf96800535.png)
*Download a [PowerPoint file](https://arch-center.azureedge.net/W365-Placement-Diagrams.pptx) of this architecture.*

The previous architecture pattern uses Hybrid Azure AD Join identity to manage the Cloud PC and hence requires a "line of sight" network communication with AD DS Domain Controllers in on-premises.

| Component | Azure Subscription – Azure subscription that hosts the VNET used for providing connectivity for Cloud PC to on-premises and Internet. |
| --- | --- |
| **Architecture Patterns** | ANC for Azure AD Join & ANC for Hybrid Azure AD Join |
| **Recommendations** | - Create or use a subscription that has VNET, ExpressRoute/VPN gateways to provide connection back to on-premises. <br> - Create a dedicated resource group for Cloud PC to provide better control on permission and resources management. <br> - Exclude Cloud PC resource group(s) and VNET(s) from Azure policies that prevent auto creation and deletion of vNIC objects, IP address assignment/release, etc. For example, [Lock your resources to protect your infrastructure](/azure/azure-resource-manager/management/lock-resources?tabs=json). Read more about other [Azure requirements](/windows-365/enterprise/requirements?tabs=enterprise%2Cent#azure-requirements). <br> - Create dedicated VNET(s) for better IP address management and routing controls. |

### Azure Virtual Network and hybrid connection

Windows 365 Azure Network Connection (ANC) based architecture patterns require one or more Azure VNETs to provide connectivity on-premises and over the Internet for the Cloud PC provisioned. The virtual network (vNIC) adapter of the Cloud PC is provisioned in the Azure VNET of the customer-owned subscription as shown in the [Azure subscription](#azure-subscription) section.

Azure networking can be deployed with varying design sophistication, based on the existing on-premises networking, Azure networking, etc. To get started with a basic hybrid network design, see [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz?tabs=portal).

The following are design factors to consider while designing an Azure VNET architecture:

1. **IP Address Space** – The size of IP address space depends on the number of Cloud PCs to support. Plan for at least 1.5x of the maximum number of Cloud PCs that will be deployed. The additional IP addresses are to account for IP addresses used during provisioning and deprovisioning of Cloud PCs.

1. **Name Resolution**

    - The DNS service used by the Cloud PC to resolve on-premises domain name in a Hybrid AADJ deployment or Internet/Azure resources in a AADJ deployment model.
    - To use your existing on-premises DNS infrastructure, you can configure IP addresses of one or more DNS servers for name resolution as described in [DNS requirements](/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent#dns-requirements).
    - Ensure the DNS server(s) IP used in Azure VNET belong to the same geography as Cloud PC and that it doesn't redirect DNS registration requests to another region or else it results in delayed and/or failed deployments and ANC health checks.
    - For an Azure native option, you can use the Azure public DNS or Azure private DNS or the private resolver option, for Azure DNS based name resolution. Learn more about [Azure DNS documentation](/azure/dns/).

1. **Network Topology** – Azure networking supports various topologies to accommodate different use cases.

    - **Hub-Spoke topology with VNET peering** – This is the simplest topology to provide isolation of services with their own spoke VNET and hub VNET with shared services such as firewall, network gateways etc. Choose this topology, if you have a simple, single site design, to deploy a Cloud PC in one or more spoke VNET. Learn more about [Hub-and-spoke network topology](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology).
    - **Hub-Spoke topology with vWAN** – Azure Virtual WAN (vWAN) is a Azure networking service that brings together various networking, security, and management capabilities that enable complex network requirements. Use this topology for multi-site, multi-region deployments with specific firewalling and routing requirements. Learn more about [Hub-spoke network topology with Azure Virtual WAN](/azure/architecture/networking/hub-spoke-vwan-architecture).

1. **Network Gateway** - Azure network gateways provide connectivity from VNET to on-premises. There are VPN and ExpressRoute (ER) network gateways. Ensure the bandwidth requirements of maximum Cloud PC is considered before deciding on ExpressRoute or VPN method of connectivity. Both VPN and ER gateways are offered in various tiers (SKUs) that differ in the amount of bandwidth provided and other metrics. Learn more about how to [Extend an on-premises network using ExpressRoute](/azure/architecture/reference-architectures/hybrid-networking/expressroute) and how to [Connect an on-premises network to Azure using ExpressRoute](/azure/architecture/reference-architectures/hybrid-networking/expressroute-vpn-failover).

## Routing configurations

Windows 365 ANC service uses automated health checks to determine the health and readiness of the customer's environment to provision AADJ or HAADJ Cloud PCs in an ANC based architecture. Without proper routing configurations in your Azure VNET and associated networking services, there's a high likelihood of failures and/or delays in your Cloud PC deployment. The following are some of the recommendations to optimize routing for a Windows 365 network architecture:

1. **Whitelist/Allowlist required URLs** – Each Cloud PC deployed in Hybrid Azure AD Join and Azure AD Join ANC model requires several URLs to be allowed through OS anti-virus, network firewalls, load balancers etc. Ensure all the URLs are allowed. Learn more about how to [Allow network connectivity](/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent#allow-network-connectivity).

1. **Use Azure FQDN Tags** – When you use Azure firewall service, use Azure FQDN tags to allow required URLs for Azure Virtual Desktop, Windows 365 and Intune. Learn more about how to [Use Azure Firewall to manage and secure Windows 365 environments](/windows-365/enterprise/azure-firewall-windows-365).

1. **Enable pass through** – Windows 365 uses RDP protocol, which is sensitive to latency introduced by traffic inspection devices such as firewall, SSL decryption appliance etc. Such latency can result in end users having poor user experience, so disable traffic inspection of these URLs and instead enable pass through. Learn more about [Traffic interception technologies](/windows-365/enterprise/requirements-network?tabs=enterprise%2Cent#traffic-interception-technologies).

1. **Bypass proxy** – Cloud and traditional proxy services, while suitable for internet access, introduce latency in RDP connections when the connection from the end user's physical or from Cloud PC is forced through them. This results in frequent disconnections, lags, and sluggish response times. Ensure the following key traffic URLs are set to bypass proxy services on the user's physical device, the network the physical device is connected to, and in the Cloud PC. <br>
    a. \*.wvd.microsoft.com <br>
    b. Windows 365 gateway IP ranges - [Windows365-PSScripts/Windows365GatewayIPLookup](https://github.com/microsoft/Windows365-PSScripts/tree/main/Windows%20365%20Gateway%20IP%20Lookup)

Learn more about [Optimizing RDP connectivity for Windows 365](https://techcommunity.microsoft.com/t5/windows-365/optimizing-rdp-connectivity-for-windows-365/m-p/3554327)

1. **Shortest path routing** – Ensure RDP traffic from Cloud PC reaches Azure Virtual Desktop (AVD) service endpoints via the shortest path, which ideally is from VNET, directly to AVD gateway IP via Internet. Also ensure RDP traffic from the end user's physical device reaches the AVD gateway IP directly. This configuration ensures optimal routing and no degradation in user experience. Avoid routing RDP traffic to the Internet via cloud proxy services or via on-premises networks.

1. **RDP Shortpath** – Enable RDP shortpath based access for end user networks, Azure network and Cloud PC. RDP shortpath uses UDP to transmit RDP traffic and unlike TCP, it's very resilient to high latency network connections. UDP also takes maximum advantage of the available network bandwidth to efficiently transfer RDP packets, which leads to an improved user experience. Learn more about how to [Use RDP Shortpath for public networks with Windows 365](/windows-365/enterprise/rdp-shortpath-public-networks)

1. **Cloud PC placement** – For an optimal user experience and routing performance, decide where the users are in relation to the work apps or network they will access. Also consider the time users spend accessing the LOB apps as an overall time of accessing other apps. See the following two possible deployment options:

   a. If the users spend the majority of their work time accessing the LOB apps rather than work on locally installed apps, like M365 apps, the following deployment model might be optimal. This model optimizes latency for LOB apps vs. Cloud PC access latency by placing the Cloud PC in the same region as the LOB app (Geography B), even though the gateway is geographically closer to the end user (Geography A). The following diagram shows the possible traffic flow from the end user to the LOB apps.

![Diagram of a flow chart, showing a possible traffic flow from users to apps.](RackMultipart20230915-1-7a5xf3_html_2f0b12191906ba2c.png)
*Download a [PowerPoint file](https://arch-center.azureedge.net/W365-Placement-Diagrams.pptx) of this architecture.*

   b. If the users occasionally access the LOB apps in Geography B, then deploying Cloud PC closer to the users might be optimal because it optimizes the Cloud PC access latency over LOB apps access latency. The following diagram shows how the traffic might flow in such a scenario.

![Diagram of a flow chart that shows a possible traffic flow from users to apps.](RackMultipart20230915-1-7a5xf3_html_e0a3f3d64c42a3a1.png)
*Download a [PowerPoint file](https://arch-center.azureedge.net/W365-Placement-Diagrams.pptx) of this architecture.*

## AD DS recommendations

In a Hybrid Azure AD Join architecture, on-premises AD DS infrastructure is a big dependency, as it acts as the Identity source of authority. Having a properly configured and healthy AD DS infrastructure is crucial step to make the Windows 365 deployment successful.

On-premises AD DS supports a variety of configurations and varying levels of complexity, so the recommendation provided here only cover the baseline best practices.

- For Hybrid Azure AD Join scenario, you can either deploy AD DS in Azure VMs as described in the architecture reference in [Deploy AD DS in an Azure virtual network](/azure/architecture/example-scenario/identity/adds-extend-domain?source=recommendations), or you can use a hybrid network connection to provide direct line of sight to your on-premises AD domain controller. Learn more about how to [Implement a secure hybrid network](/azure/architecture/reference-architectures/dmz/secure-vnet-dmz?tabs=portal).
- For Azure AD Join deployment, follow the reference architecture in [Integrate on-premises Active Directory domains with Azure Active Directory](/azure/architecture/reference-architectures/identity/azure-ad).
- Windows 365 uses a watchdog service as part of automated testing that creates a test VM account. That account shows as disabled in the OU specified in ANC configuration; don't delete this account.
- Any Cloud PC decommissioned in the Hybrid Azure AD Join model leaves behind a disabled computer account which needs to be cleaned manually in AD DS.
- Azure AD Domain Service isn't supported as an identity source because it doesn't support Hybrid Azure AD Join.

## DNS recommendations

In an ANC deployment architecture, DNS servers or another DNS service used by Azure VNET is a crucial dependency. It's important to have a healthy infrastructure in place.

- For HAADJ configuration, DNS should be able to resolve the domain to which Cloud PC needs to be joined. There are multiple configuration options available, the simplest of them being specifying your DNS server IP in the Azure VNET configuration. Learn more about how to [Name resolution that uses your own DNS server](/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances?tabs=redhat#name-resolution-that-uses-your-own-dns-server).
- Depending on the complexity of the infrastructure, such as multi-region, multi-domain setup in Azure and on-premises, you should use a service like Azure private zones or private resolver. Learn more about [Azure DNS Private Resolver](/azure/architecture/example-scenario/networking/azure-dns-private-resolver).

## Cloud PC connection recommendations

Deployed Cloud PCs should be configured to allow uninterrupted connection flow to and from the AVD gateway service. Consider the following recommendations while deploying various apps as part of Windows OS configuration:

- VPN Clients – Ensure the VPN client isn't setup to launch on user logon because it could result in session disconnection when the VPN tunnel is established, forcing the user to connect a second time.
- Configure VPN, proxy, firewall and Anti-virus or Anti-malware apps to allow or bypass traffic bound for IP addresses 168.63.129.16 and 169.254.169.254, as these IP addresses are used for communication with Azure platform services such as meta data, heartbeat, etc. Learn more about [What is IP address 168.63.129.16?](/azure/virtual-network/what-is-ip-address-168-63-129-16), [Azure Instance Metadata Service for virtual machines](/azure/virtual-machines/instance-metadata-service?tabs=windows) and [Azure Virtual Network FAQ](/azure/virtual-network/virtual-networks-faq).
- Don't modify the IP addresses of Cloud PCs manually because it might result in permanent disconnection. IP addresses are assigned with an indefinite lease and managed throughout the lifecycle of Cloud PC by Azure networking service. Learn more about [Allocation methods](/azure/virtual-network/ip-services/virtual-network-network-interface-addresses?tabs=nic-address-portal#allocation-methods).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- Bob Roudabush
- [Claus Emerich](https://www.linkedin.com/in/claus-bavaria) | Principal Product Manager
- [David Falkus](https://www.linkedin.com/in/david-falkus) | Principal Product Manager
- [Matt Shadbolt](https://www.linkedin.com/in/mattshadbolt) | Principal Product Manager, Windows Cloud Experiences (Windows 365, AVD, RDS)
- [Paul Collinge](https://www.linkedin.com/in/paul-collinge-5159b729) | Principal Product Manager - Windows Cloud Experiences (Windows 365 & Azure Virtual Desktop)
- Ravishankar Nandagopalan | Senior Product Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

[Plan your Cloud PC deployment](/windows-365/enterprise/planning-guide)

## Related resources

Read more about the architecture options and various technical components of [Windows 365 architecture](/windows-365/enterprise/architecture)

[Windows 365 identity and authentication](/windows-365/enterprise/identity-authentication)

[Cloud PC lifecycle in Windows 365](/windows-365/enterprise/lifecycle)
