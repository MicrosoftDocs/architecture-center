[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

You can build an entire IT infrastructure to run your organization by using various Azure services. Azure also offers security services to protect your infrastructure. By using Azure security services, you can improve the security posture of your IT environment. You can mitigate vulnerabilities and avoid breaches by implementing a well-architected solution that follows recommendations from Microsoft. 

Some security services incur fees while others have no additional charges. Free services include network security groups (NSGs), storage encryption, TLS/SSL, shared access signature tokens, and many others. This article covers such services.

This article is the third in a series of five. To review the previous two articles in this series, including the introduction and a review of how you can map threats against an IT environment, see the following articles:

- [Use Azure monitoring to integrate security components](../../guide/security/azure-monitor-integrate-security-components.yml)
- [Map threats to your IT environment](./map-threats-it-environment.yml)

## Potential use cases

This article presents Azure security services according to each Azure service. In this way, you can think of a specific threat against resource—a virtual machine (VM), an operating system, an Azure network, an application—or an attack that might compromise users and passwords. Then use the diagram in this article to help you understand which Azure security services to use to protect resources and user identities from that type of threat.

## Architecture

:::image type="content" alt-text="A diagram of on-premises resources, services from Microsoft 365 and Azure, and 16 types of threats as classified by the MITRE ATTACK matrix." source="../media/azure-security-build-first-layer-defense-architecture.png" lightbox="../media/azure-security-build-first-layer-defense-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components.vsdm) of this architecture.*

*©2021 The MITRE Corporation. This work is reproduced and distributed with the permission of The MITRE Corporation.*

The Azure security layer in this diagram is based on Azure Security Benchmark (ASB) v3, which is a set of security rules that are implemented through Azure policies. ASB is based on a combination of rules from [CIS Center for Internet Security](https://www.cisecurity.org) and [National Institute of Standards and Technology](https://www.nist.gov). For more information about ASB, see [Overview of the Azure Security Benchmark v3](/security/benchmark/azure/overview).

The diagram doesn't contain all the Azure security services that are available, but it shows the security services that are most commonly used by organizations. All the security services that are identified in the architectural diagram can work together in any combination according to your IT environment and your organization's security requirements.


### Workflow

This section describes the components and services that appear in the diagram. Many of those are labeled with their ASB control codes, in addition to their abbreviated labels. The control codes correspond to the control domains that are listed in [Controls](/security/benchmark/azure/overview#controls). 

1.  **AZURE SECURITY BENCHMARK**

    Each security control refers to one or more specific Azure security services. The architecture reference in this article shows some of them and their control numbers according to the ASB documentation. The controls include:

    - Network security
    - Identity management
    - Privileged access
    - Data protection
    - Asset management
    - Logging and threat detection
    - Incident response
    - Posture and vulnerability management
    - Endpoint security
    - Backup and recovery
    - DevOps security
    - Governance and strategy

    For more information about security controls, see [Overview of the Azure Security Benchmark (v3)](/security/benchmark/azure/overview).

2.  **NETWORK**

    The following table describes the network services in the diagram.
    
    | Label | Description | Documentation |
    |---|---|---|
    | **NSG** | A free service that you attach to a network interface or subnet. An NSG allows you to filter TCP or UDP protocol traffic by using IP address ranges and ports for inbound and outbound connections. | [Network security groups](/azure/virtual-network/network-security-groups-overview) |
    | **VPN** | A virtual private network (VPN) gateway that delivers a tunnel with IPSEC (IKE v1/v2) protection. | [VPN Gateway](https://azure.microsoft.com/services/vpn-gateway) |
    | **AZURE FIREWALL** | A platform as a service (PaaS) that delivers protection in layer 4 and is attached to an entire virtual network. | [What is Azure Firewall](/azure/firewall/overview)? |
    | **APP GW + WAF** | Azure Application Gateway with Web Application Firewall (WAF). Application Gateway is a load balancer for web traffic that works in layer 7 and adds WAF to protect applications that use HTTP and HTTPS. | [What is Azure Application Gateway](/azure/application-gateway/overview)? |
    | **NVA** | Network Virtual Appliance (NVA), a virtual security services from the marketplace that is provisioned on VMs on Azure. | [Network Virtual Appliances](https://azure.microsoft.com/solutions/network-appliances) |
    | **DDOS** | DDoS protection implemented on the virtual network to help you mitigate different types of DDoS attacks. | [Azure DDoS Network Protection overview](/azure/ddos-protection/ddos-protection-overview) |
    | **TLS/SSL** | TLS/SSL deliver encryption in transit for most Azure services that exchange information, such as Azure Storage and Web Apps. | [Configure end-to-end TLS by using Application Gateway with PowerShell](/azure/application-gateway/application-gateway-end-to-end-ssl-powershell) |
    | **PRIVATE LINK** | Service that allows you to create a private network for an Azure service that initially is exposed to the internet. | [What is Azure Private Link](/azure/private-link/private-link-overview)? |
    | **PRIVATE ENDPOINT** | Creates a network interface and attaches it to the Azure service. Private Endpoint is part of Private Link. This configuration lets the service, by using a private endpoint, be part of your virtual network. | [What is a private endpoint](/azure/private-link/private-endpoint-overview)? |

3.  **INFRASTRUCTURE AND ENDPOINTS**

    The following table describes infrastructure and endpoint services that are shown in the diagram.

    | Label | Description | Documentation |
    |---|---|---|
    | **BASTION** | Bastion provides jump server functionality. This service allows you to access your VMs through remote desktop protocol (RDP) or SSH without exposing your VMs to the internet. | [What is Azure Bastion](/azure/bastion/bastion-overview)? |
    | **ANTIMALWARE** | Microsoft Defender provides anti-malware service and is part of Windows 10, Windows 11, Windows Server 2016, and Windows Server 2019. | [Microsoft Defender Antivirus in Windows](/microsoft-365/security/defender-endpoint/microsoft-defender-antivirus-windows?view=o365-worldwide) |
    | **DISK ENCRYPT** | Disk Encryption allows you to encrypt the disk of a VM. | [Azure Disk Encryption for Windows VMs](/azure/virtual-machines/windows/disk-encryption-overview) |
    | **KEYVAULT** | Key Vault, a service to store keys, secrets, and certificates with FIPS 140-2 Level 2 or 3. | [Azure Key Vault basic concepts](/azure/key-vault/general/basic-concepts) |
    | **RDP SHORT** | Azure Virtual Desktop RDP Shortpath. This feature allows remote users to connect to the Virtual Desktop service from a private network. | [Azure Virtual Desktop RDP Shortpath for managed networks](/azure/virtual-desktop/shortpath) |
    | **REVERSE CONNECT** | A built-in security feature from Azure Virtual Desktop. Reverse connect guarantees that remote users receive only pixel streams and don't reach the host VMs. | [Understanding Azure Virtual Desktop network connectivity](/azure/virtual-desktop/network-connectivity) |

4.  **APPLICATION AND DATA**

    The following table describes application and data services that are shown in the diagram.

    | Label | Description | Documentation |
    |---|---|---|
    | **FRONTDOOR + WAF** | A content delivery network (CDN). Front Door combines multiple points of presence to deliver a better connection for users who access the service and adds WAF. | [What is Azure Front Door](/azure/frontdoor/front-door-overview)? |
    | **API MANAGEMENT** | A service that delivers security for API calls and manages APIs across environments. | [About API Management](/azure/api-management/api-management-key-concepts) |
    | **PENTEST** | A set of best practices to execute a penetration test in your environment, including Azure resources. | [Penetration testing](/azure/security/fundamentals/pen-testing) |
    | **STORAGE SAS TOKEN** | A shared access token to allow others to access your Azure storage account. | [Grant limited access to Azure Storage resources using shared access signatures (SAS)](/azure/storage/common/storage-sas-overview) |
    | **PRIVATE ENDPOINT** | Create a network interface and attach it to your storage account to configure it inside a private network on Azure. | [Use private endpoints for Azure Storage](/azure/storage/common/storage-private-endpoints) |
    | **STORAGE FIREWALL** | Firewall that allows you to set a range of IP addresses that can access your storage account. | [Configure Azure Storage firewalls and virtual networks](/azure/storage/common/storage-network-security?tabs=azure-portal) |
    | **ENCRYPTION**<br/>(Azure Storage) | Protects your storage account with encryption at rest. | [Azure Storage encryption for data at rest](/azure/storage/common/storage-service-encryption) |
    | **SQL AUDIT** | Tracks database events and writes them to an audit log in your Azure storage account. | [Auditing for Azure SQL Database and Azure Synapse Analytics](/azure/azure-sql/database/auditing-overview) |
    | **VULNERABILITY ASSESSMENT** | Service that helps you discover, track, and remediate potential database vulnerabilities. | [SQL vulnerability assessment helps you identify database vulnerabilities](/azure/azure-sql/database/sql-vulnerability-assessment?tabs=azure-powershell) |
    | **ENCRYPTION**<br/>(Azure SQL) | Transparent data encryption (TDE) helps protect Azure SQL database services by encrypting data at rest. | [Transparent data encryption for SQL Database, SQL Managed Instance, and Azure Synapse Analytics](/azure/azure-sql/database/transparent-data-encryption-tde-overview?tabs=azure-portal) |

5.  **IDENTITY**

    The following table describes identity services that are shown in the diagram.

    | Label | Description | Documentation |
    |---|---|---|
    | **RBAC** | Azure role-based access control (Azure RBAC) helps you manage access to Azure services by using granular permissions that are based on users' Azure Active Directory (Azure AD) credentials. | [What is Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview)? |
    | **MFA** | Multi-factor authentication offers additional types of authentication beyond user names and passwords. | [How it works: Azure AD Multi-Factor Authentication](/azure/active-directory/authentication/concept-mfa-howitworks) |
    | **ID PROTECTION** | Identity Protection, a security service from Azure AD, analyzes trillions of signals per day to identify and protect users from threats. | [What is Identity Protection](/azure/active-directory/identity-protection/overview-identity-protection)? |
    | **PIM** | Privileged Identity Management (PIM), a security service from Azure AD. It helps you to provide superuser privileges temporarily for Azure AD (for example, Global Admin) and Azure subscriptions (for example, owner or contributor). | [What is Azure AD Privileged Identity Management](/azure/active-directory/privileged-identity-management/pim-configure)? |
    | **COND ACC** | Conditional Access is an intelligent security service that uses policies that you define for various conditions to block or grant access to users. | [What is Conditional Access?](/azure/active-directory/conditional-access/overview) |

### Components

The example architecture in this article uses the following Azure components:

- [Azure AD](https://azure.microsoft.com/services/active-directory) is a cloud-based identity and access management service. Azure AD helps your users to access external resources, such as Microsoft 365, the Azure portal, and thousands of other SaaS applications. It also helps them access internal resources, like apps on your corporate intranet network.

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for your private network in Azure. Virtual Network enables many types of Azure resources to securely communicate with each other, the internet, and on-premises networks. Virtual Network provides a virtual network that benefits from Azure's infrastructure, such as scale, availability, and isolation.

- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer) is a high-performance, low-latency Layer 4 load-balancing service (inbound and outbound) for all UDP and TCP protocols. It's built to handle millions of requests per second while ensuring that your solution is highly available. Azure Load Balancer is zone-redundant, ensuring high availability across Availability Zones.

- [Virtual machines](https://azure.microsoft.com/services/virtual-machines) is one of several types of on-demand, scalable computing resources that Azure offers. An Azure virtual machine (VM) gives you the flexibility of virtualization without having to buy and maintain the physical hardware that runs it.

- [Azure Kubernetes service](https://azure.microsoft.com/services/kubernetes-service) (AKS) is a fully managed Kubernetes service for deploying and managing containerized applications. AKS provides serverless Kubernetes, continuous integration/continuous delivery (CI/CD), and enterprise-grade security and governance.

- [Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop) is a desktop and app virtualization service that runs on the cloud to provide desktops for remote users.

- [Web Apps](https://azure.microsoft.com/services/app-service/web) is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. You can develop in your favorite language, and applications run and scale with ease on both Windows and Linux-based environments.

- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is highly available, massively scalable, durable, and secure storage for various data objects in the cloud, including object, blob, file, disk, queue, and table storage. All data written to an Azure storage account is encrypted by the service. Azure Storage provides you with fine-grained control over who has access to your data.

- [Azure SQL database](https://azure.microsoft.com/products/azure-sql/database) is a fully managed PaaS database engine that handles most of the database management functions such as upgrading, patching, backups, and monitoring. It provides these functions without user involvement. SQL Database provides a range of built-in security and compliance features to help your application meet security and compliance requirements.


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author: 

 * [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-r-oliveira-69443523) | Senior Customer Engineer

Other contributors: 

 * [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
 * [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager


## Next steps

Microsoft has more documentation that can help you secure your IT environment, and the following articles can be particularly helpful:

- [Security in the Microsoft Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/secure). The Cloud Adoption Framework provides security guidance for your cloud journey by clarifying the processes, best practices, models, and experience.
- [Microsoft Azure Well-Architected Framework](/azure/architecture/framework). The Azure Well-Architected Framework is a set of guiding tenets that you can use to improve the quality of a workload. The framework is based on five pillars: reliability, security, cost optimization, operational excellence, and performance efficiency.
- [Microsoft Security Best Practices](/security/compass/compass). Microsoft Security Best Practices (formerly known as the *Azure Security Compass* or *Microsoft Security Compass*) is a collection of best practices that provide clear, actionable guidance for security-related decisions.
- [Microsoft Cybersecurity Reference Architectures](/security/cybersecurity-reference-architecture/mcra) (MCRA). MCRA is a compilation of various Microsoft security reference architectures. 

In the following resources, you can find more information about the services, technologies, and terminologies that are mentioned in this article:

- [What are public, private, and hybrid clouds?](https://azure.microsoft.com/overview/what-are-private-public-hybrid-clouds)
- [Overview of the Azure Security Benchmark (v3)](/security/benchmark/azure/overview)
- [Embrace proactive security with Zero Trust](/security/zero-trust/)
- [Microsoft 365](/microsoft-365) subscription information
- [Microsoft 365 Defender](/microsoft-365/security/defender/microsoft-365-defender)

## Related resources

For more details about this reference architecture, see the other articles in this series:

- Part 1: [Use Azure monitoring to integrate security components](../../guide/security/azure-monitor-integrate-security-components.yml)
- Part 2: [Map threats to your IT environment](./map-threats-it-environment.yml)
- Part 4: [Build the second layer of defense with Microsoft 365 Defender Security services](./microsoft-365-defender-build-second-layer-defense.yml)
- Part 5: [Integration between Azure and Microsoft 365 Defender security services](./microsoft-365-defender-security-integrate-azure.yml)
