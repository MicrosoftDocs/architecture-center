Every business IT infrastructure running on-premises or on the Cloud may have vulnerabilities and breaches that may compromise your information and make it fail. Azure public cloud has many services available so that you may build an entire IT infrastructure to run your business leveraging a variety of infrastructure and platform services. Those components contain resources for your network, compute, storage, applications, databases, and identity services.

Microsoft Azure offers a great list of security services to protect those resources and then allow you to improve your security posture by avoiding and mitigating vulnerabilities and breaches. These security services need to be well architected and follow some recommendations from Microsoft to work correctly.

Interestingly, some of those security services are free of cost, such as NSG (Network Security Group), Storage encryption, TLS/SSL, SAS token, and many others that we will cover with more details in this document.

This is the third document that is part of a series of 5. To review the other two documents with an introduction and a review about how threats can be mapped against a business IT Environment, please, take a look at those links:

-   Microsoft cloud security integration map against Threats -- Introduction \<link\>

-   Business IT environment VS Attackers \<link\>

## Potential use cases

This document presents Azure Security services according to each Azure service. In this way, you may think of a specific threat against a VM, an operating system, an Azure network, Applications, or an attack that may try to compromise your users and passwords, and then use the diagram in this document to help you understand what Azure security services you may consider to protect some specific Azure resources.

The Azure security layer on this diagram was built based on the Azure Security Benchmark V3 ([Overview of the Azure Security Benchmark v3](https://docs.microsoft.com/en-us/security/benchmark/azure/overview)), that is a set of security rules implemented through Azure policies based on a combination of CIS ([CIS Center for Internet Security (cisecurity.org)](https://www.cisecurity.org/) and NIST ([National Institute of Standards and Technology \| NIST](https://www.nist.gov/)) rules.

The diagram below doesn't contain all of the Azure security services available, but it presents some of many companies\' most used Security services. Some of them have the Control code according to the Azure Security Benchmark V3 documentation so that you may have a reference about it.

:::image type="content" alt-text="Image alt text." source="images/azure-security-build-first-layer-defense-architecture.png" lightbox="images/azure-security-build-first-layer-defense-architecture.png":::

As stated earlier, Azure security services may be found in different documents such as Azure Security benchmarks and Azure Security Baselines ([Azure Security Benchmark overview](https://docs.microsoft.com/en-us/security/benchmark/azure/security-baselines-overview)). In this document, we will highlight only the Azure security services presented in the diagram.

Let's review some details presented in the diagram.

1.  **Azure Security Benchmark**

    On Azure Security Benchmark, each security control will refer to one or more specific Azure security services. The architecture reference on this document shows some of them and their control number according to the Azure Security benchmark v3 documentation.

    Those are the controls you find on Azure Security Benchmark.

    - Network security
    - Identity management
    - Privileged Access
    - Data protection
    - Asset management
    - Logging and threat detection
    - Incident response
    - Posture and vulnerability management
    - Endpoint security
    - Backup and recovery
    - DevOps Security
    - Governance and Strategy

    Review all security controls details in the link below:

    [Overview of the Azure Security Benchmark v3](https://docs.microsoft.com/en-us/security/benchmark/azure/overview)

2.  **Network security services**
 
    1.  **Network Security Group (NSG)** -- This is a free service that you attach on a network card or subnet and allows you to filter TCP or UDP protocol with IP ranges and ports for inbound and outbound connections.

        [Azure network security groups overview \| Microsoft > Docs](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)

    1.  **VPN** -- A Virtual Private Network gateway that delivers a tunnel with IPSEC (IKE v1/v2) protection.

        [VPN Gateway - Virtual Networks \| Microsoft Azure](https://azure.microsoft.com/en-us/services/vpn-gateway/)

    1.  **Azure Firewall** -- A PaaS that delivers protection in layer four
    and is attached to an entire VNET.

        [What is Azure Firewall?](https://docs.microsoft.com/en-us/azure/firewall/overview)

    1.  **Application Gateway with WAF** -- a load balancer that works in layer seven and adds a Web Application Firewall to protect HTTP and HTTPS applications.

        [What is Azure Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview)

    1.  **NVA** -- Network Virtual Appliance are virtual security services from the marketplace provisioned on VMs on Azure.

        [Network Virtual Appliances \| Microsoft Azure](https://azure.microsoft.com/en-us/solutions/network-appliances/)

    1.  **DDOS standard** --DDOS protection implemented on the VNET to help you mitigate different types of DDOS attacks.

        [Azure DDoS Protection Standard Overview](https://docs.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview)

    1.  **TLS/SSL** -- encryption in transit is delivered through TLS/SSL for most Azure services that exchange information, such as Azure Storage and Web Apps.

        [Configure end-to-end TLS with Azure Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-end-to-end-ssl-powershell)

    1.  **Private Link** -- this service allows you to create a private network for an Azure service that initially is exposed to the internet.

        [What is Azure Private Link?](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview)

    1.  **Private Endpoint** -- part of Private Link, Private endpoint create a network card and attach it to the azure service. This setup lets the service with a private endpoint be part of your VNET.

        [What is a private endpoint?](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview)

3.  **Infrastructure and Endpoint**

    1.  **Bastion** -- in a simple word, Bastion works as "Jump Server" as a Service. This service allows you to access your VMs through RDP or SSH without exposing your VMs to the internet.

        <https://aka.ms/AAg3er8>

    1.  **Anti-malware** -- Windows Defender, part of Windows 10, 11 and Windows Server 2016, 2019.

        [Microsoft Defender Antivirus in Windows](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/microsoft-defender-antivirus-windows?view=o365-worldwide)

    1.  **VM disk encryption** -- this is a feature from VM that allows you to encrypt VM disk.

        [Enable Azure Disk Encryption for Windows VMs - Azure Virtual Machines](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/disk-encryption-overview)

    1.  **Key Vault** -- a service to store keys, secrets, and certificates with FIPS 140-2 Level 2 or 3.

        [What is Azure Key Vault?](https://docs.microsoft.com/en-us/azure/key-vault/general/basic-concepts)

    1.  **AVD RDP Short path** -- part of AVD architecture, this feature allows remote users to connect on the Virtual Desktop service from a private network.

        [Azure Virtual Desktop RDP Shortpath for managed networks - Azure](https://docs.microsoft.com/en-us/azure/virtual-desktop/shortpath)

    1.  **AVD Reverse Connect** -- a built-in security feature from AVD. Reverse connect guarantees that remote users only receive pixel streams and don't reach the host VMs.

        [Understanding Azure Virtual Desktop network connectivity - Azure](https://docs.microsoft.com/en-us/azure/virtual-desktop/network-connectivity)

4.  **Application and Data**

    1.  **Front Door + WAF** -- It is an Application Content Deliver type of service. It combines multiple points of presence to deliver a better connection for users that access the service, plus a Web Application Firewall.

        [Azure Front Door](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-overview)

    1.  **API Management** -- a service that delivers security for API calls.

        [Azure API Management overview and key concepts](https://docs.microsoft.com/en-us/azure/api-management/api-management-key-concepts)

    1.  **Penetration test** is a set of best practices to execute a penetration test in your environment.

        [Penetration testing](https://docs.microsoft.com/en-us/azure/security/fundamentals/pen-testing)

    1.  **Storage SAS Token** -- a temporary key to allow others to access your Azure storage account.

        [Grant limited access to data with shared access signatures (SAS) - Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-sas-overview)

    1.  **Storage Private endpoint** -- create a network card and attach it to your storage account to configure it inside a private network on     Azure.

        [Use private endpoints - Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-private-endpoints)

    1.  **Storage Firewall** -- allows you to set a range of IP addresses to access your storage account.

        [Configure Azure Storage firewalls and virtual networks](https://docs.microsoft.com/en-us/azure/storage/common/storage-network-security?tabs=azure-portal)

    1.  **Storage encryption** -- set your storage account with encryption at rest.

        [Azure Storage encryption for data at rest](https://docs.microsoft.com/en-us/azure/storage/common/storage-service-encryption)

    1.  **SQL Audit** -- tracks database events and writes them to an audit log in your Azure storage account.

        [Azure SQL Auditing for Azure SQL Database and Azure Synapse Analytics - Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/auditing-overview)

    1.  **SQL Vulnerability Assessment** is a service that helps you discover, track, and remediate potential database vulnerabilities.

        [SQL vulnerability assessment - Azure SQL Database & SQL Managed Instance & Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/azure-sql/database/sql-vulnerability-assessment?tabs=azure-powershell)

    1.  **SQL Encryption --** Transparent data encryption helps protect Azure SQL database services by encrypting data at rest.

        [Transparent data encryption - Azure SQL Database & SQL Managed Instance & Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-tde-overview?tabs=azure-portal)

5.  **Identity**

    1.  **RBAC** -- Role-Based Access Control helps you provide granular permissions to different Azure services based on Azure AD user's credentials.

        [What is Azure role-based access control (Azure RBAC)?](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview)

    1.  **MFA** -- Multi-Factor Authentication offers additional authentication types on top of traditional user and password authentication.

        [Azure AD Multi-Factor Authentication overview](https://docs.microsoft.com/en-us/azure/active-directory/authentication/concept-mfa-howitworks)

    1.  **ID Protection** -- this is a security service from Azure AD. It analyses trillions of signals per day to identify and protect users from threats.

        [What is Azure Active Directory Identity Protection?](https://docs.microsoft.com/en-us/azure/active-directory/identity-protection/overview-identity-protection)

    1.  **Privileged Identity Management** -- this is another security service from Azure AD. It helps you to provide "super" user privileges temporarily for Azure AD (e.g., Global Admin) and Azure subscriptions (e.g., owner or contributor).

        [What is Privileged Identity Management? - Azure AD](https://docs.microsoft.com/en-us/azure/active-directory/privileged-identity-management/pim-configure)

    1.  **Conditional Access** is an intelligent security service based on policies that you define to create rules that will allow or deny users to access Azure based on different conditions.

        [What is Conditional Access in Azure Active Directory?](https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/overview)

All those security services mentioned above that are part of the diagram may work together in any combination according to your business IT environment and your security requirements.

Anyway, Microsoft has other documents that may help you in your Security journey for your business IT environment. Here are some of them:

- **Cloud Adoption Framework**

  The Cloud Adoption, also called CAF, provides security guidance for your cloud journey by clarifying the processes, best practices, models, and experience. More about CAF:

  [Security in the Microsoft Cloud Adoption Framework for Azure - Cloud Adoption Framework](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/secure/)

- **Azure Well-Architected Framework**

  From Microsoft documentation, "The Azure Well-Architected Framework is a set of guiding tenets that can be used to improve the quality of a workload." Also called WAF, It is based on five pillars: Reliability, **Security,** Cost Optimization, Operational Excellence, and Performance Efficiency. More about WAF:

  [Microsoft Azure Well-Architected Framework -- Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/framework/)

- **Microsoft Security Best Practices**

  This is one of the best Microsoft security documents available. Microsoft documentation states, "Microsoft Security Best Practices (formerly known as the Azure Security Compass or Microsoft Security Compass) is a collection of best practices that provide clear, actionable guidance for security-related decisions." It is complete documentation about Microsoft security. See more information about it:

  [Microsoft Security Best Practices](https://docs.microsoft.com/en-us/security/compass/compass)

- **Microsoft Cybersecurity Reference Architectures (MCRA)**

  This is a compilation of a variety of Microsoft security Reference architectures.

  <https://aka.ms/mcra>

## Next step

To get all details regarding this Architecture reference, you may review those other documents part of this series.

-   Part 1 - Microsoft cloud security integration map against Threats     \<link\>

-   Part 2 - Business IT environment VS Attackers \<link\>

-   Part 4 - Building the second layer of defense with Microsoft 365     Defender services \<link\>

-   Part 5 - Integration between Azure and Microsoft 365 Defender     services \<link\>

## Related resources

This document refers to a variety of links and references throughout it. But you may want to check out more about other topics mentioned in this document.

-   Microsoft Azure public cloud: [Public Cloud vs Private Cloud vs Hybrid Cloud \| Microsoft Azure](https://azure.microsoft.com/en-us/overview/what-are-private-public-hybrid-clouds/)

-   Azure Security services: [Overview of the Azure Security Benchmark v3](https://docs.microsoft.com/en-us/security/benchmark/azure/overview)

-   Microsoft Zero Trust: [Zero Trust Model - Modern Security Architecture](https://www.microsoft.com/en-us/security/business/zero-trust)

-   Microsoft office 365: [Microsoft 365 - Subscription for Office Apps](https://www.microsoft.com/en-us/microsoft-365)

-   Microsoft 365 Defender: [Microsoft 365 Defender - Threat Protection](https://www.microsoft.com/en-us/security/business/threat-protection/microsoft-365-defender)
