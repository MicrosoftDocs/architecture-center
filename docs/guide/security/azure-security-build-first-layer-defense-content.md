Every business IT infrastructure running on-premises or on the Cloud may have vulnerabilities and breaches that may compromise your information and make it fail. Azure public cloud has many services available so that you may build an entire IT infrastructure to run your business leveraging a variety of infrastructure and platform services. Those components contain resources for your network, compute, storage, applications, databases, and identity services.

Microsoft Azure offers a great list of security services to protect those resources and then allow you to improve your security posture by avoiding and mitigating vulnerabilities and breaches. These security services need to be well architected and follow some recommendations from Microsoft to work correctly.

Interestingly, some of those security services are free of cost, such as NSG (Network Security Group), Storage encryption, TLS/SSL, shared access signature (SAS) token, and many others that we will cover with more details in this document.

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

    Review all the details about security controls in [Overview of the Azure Security Benchmark (v3)](/security/benchmark/azure/overview).

2.  **Network security services**
 
    1.  **Network Security Group (NSG)** -- This is a free service that you attach on a network card or subnet and allows you to filter TCP or UDP protocol with IP address ranges and ports for inbound and outbound connections. For more information about NSGs, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

    1.  **Virtual Private Network (VPN)** -- A VPN gateway that delivers a tunnel with IPSEC (IKE v1/v2) protection. For more information about site-to-site and point-to-site VPNs, see [VPN Gateway](https://azure.microsoft.com/en-us/services/vpn-gateway/).

    1.  **Azure Firewall** -- A PaaS that delivers protection in layer four
    and is attached to an entire VNET. For more information about this firewall service, see [What is Azure Firewall](/azure/firewall/overview)?

    1.  **Application Gateway with Web Application Firewall (WAF)** -- a load balancer that works in layer seven and adds a Web Application Firewall to protect HTTP and HTTPS applications. For more information about Application Gateway, see [What is Azure Application Gateway](/azure/application-gateway/overview)?

    1.  **Network Virtual Appliance (NVA)** -- NVAs are virtual security services from the marketplace provisioned on VMs on Azure. For more information about NVAs, see [Network Virtual Appliances](https://azure.microsoft.com/solutions/network-appliances/).

    1.  **DDoS standard** --DDOS protection implemented on the virtual network to help you mitigate different types of DDoS attacks. For more information about this service, see [Azure DDoS Protection Standard overview](/azure/ddos-protection/ddos-protection-overview).

    1.  **TLS/SSL** -- encryption in transit is delivered through TLS/SSL for most Azure services that exchange information, such as Azure Storage and Web Apps. For more information about TLS with Application Gateway, see [Configure end to end TLS by using Application Gateway with PowerShell](/azure/application-gateway/application-gateway-end-to-end-ssl-powershell).

    1.  **Private Link** -- this service allows you to create a private network for an Azure service that initially is exposed to the internet. For more information about implementing private link service, see [What is Azure Private Link](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview)?

    1.  **Private Endpoint** -- part of Private Link, Private Endpoint creates a network card and attaches it to the Azure service. This configuration lets the service with a private endpoint be part of your virtual network. For more information about using private endpoints, see [What is a private endpoint](azure/private-link/private-endpoint-overview)?

3.  **Infrastructure and Endpoint**

    1.  **Bastion** -- in a simple word, Bastion works as "Jump Server" as a Service. This service allows you to access your VMs through RDP or SSH without exposing your VMs to the internet. For more information about Bastion, see [What is Azure Bastion](/azure/bastion/bastion-overview)?

    1.  **Anti-malware** -- Microsoft Defender is part of Windows 10, 11 and Windows Server 2016, 2019. For more information about Microsoft Defender Antivirus, see [Microsoft Defender Antivirus in Windows](/microsoft-365/security/defender-endpoint/microsoft-defender-antivirus-windows?view=o365-worldwide).

    1.  **VM disk encryption** -- this is a feature from VM that allows you to encrypt VM disk. For more information about using BitLocker to secure storage on your VMs, see [Azure Disk Encryption for Windows VMs](/azure/virtual-machines/windows/disk-encryption-overview).

    1.  **Key Vault** -- a service to store keys, secrets, and certificates with FIPS 140-2 Level 2 or 3. For more information about using Key Vault to store secrets, see [Azure Key Vault basic concepts](/azure/key-vault/general/basic-concepts).

    1.  **Azure Virtual Desktop RDP Short path** -- part of Azure Virtual Desktop architecture, this feature allows remote users to connect to the Virtual Desktop service from a private network. For more information about using Azure Virtual Desktop over RDP, see [Azure Virtual Desktop RDP Shortpath for managed networks](https://docs.microsoft.com/en-us/azure/virtual-desktop/shortpath).

    1.  **Azure Virtual Desktop Reverse Connect** -- a built-in security feature from Azure Virtual Desktop. Reverse connect guarantees that remote users only receive pixel streams and don't reach the host VMs. For more information about reverse connect transport, see [Understanding Azure Virtual Desktop network connectivity](/azure/virtual-desktop/network-connectivity).

4.  **Application and Data**

    1.  **Front Door + WAF** -- It is an Application Content Deliver type of service. It combines multiple points of presence to deliver a better connection for users that access the service, plus a Web Application Firewall. For more information about this content delivery network, see [What is Azure Front Door](/azure/frontdoor/front-door-overview)?

    1.  **API Management** -- a service that delivers security for API calls. For more information about managing APIs across environments, see [About API Management](/azure/api-management/api-management-key-concepts).

    1.  **Penetration test** is a set of best practices to execute a penetration test in your environment. For more information about penetration testing on Azure, see [Penetration testing](/azure/security/fundamentals/pen-testing).

    1.  **Storage SAS Token** -- a temporary key to allow others to access your Azure storage account. For more information about using SAS tokens with Azure storage, see [Grant limited access to Azure Storage resources using shared access signatures (SAS)](/azure/storage/common/storage-sas-overview).

    1.  **Storage Private endpoint** -- create a network card and attach it to your storage account to configure it inside a private network on Azure. For more information about configuring private access or Private Link, see [Use private endpoints for Azure Storage](/azure/storage/common/storage-private-endpoints).

    1.  **Storage Firewall** -- allows you to set a range of IP addresses that can access your storage account. For more information about configuring access to your data in Azure Storage to a virtual network, see[Configure Azure Storage firewalls and virtual networks](/azure/storage/common/storage-network-security?tabs=azure-portal).

    1.  **Storage encryption** -- set your storage account with encryption at rest. For more information about encryption in Azure Storage, see [Azure Storage encryption for data at rest](/azure/storage/common/storage-service-encryption).

    1.  **SQL Audit** -- tracks database events and writes them to an audit log in your Azure storage account.  For more information about tracking and logging database events, see [Auditing for Azure SQL Database and Azure Synapse Analytics](/azure/azure-sql/database/auditing-overview).

    1.  **SQL Vulnerability Assessment** is a service that helps you discover, track, and remediate potential database vulnerabilities. For more about assessing vulnerabilities in databases, see [SQL vulnerability assessment helps you identify database vulnerabilities](/azure/azure-sql/database/sql-vulnerability-assessment?tabs=azure-powershell).

    1.  **SQL Encryption** -- Transparent data encryption (TDE) helps protect Azure SQL database services by encrypting data at rest. For more information about TDE, see [Transparent data encryption for SQL Database, SQL Managed Instance, and Azure Synapse Analytics](/azure/azure-sql/database/transparent-data-encryption-tde-overview?tabs=azure-portal).

5.  **Identity**

    1.  **Azure role-based access control (Azure RBAC)** -- Azure Azure RBAC helps you provide granular permissions to different Azure services based on Azure AD user's credentials. For more about managing access and permissions, see [What is Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview)?

    1.  **Multi-factor authentication** -- Multi-factor authentication offers additional authentication types on top of traditional user name and password authentication. For more information about requiring additional forms of authentication, see [How it works: Azure AD Multi-Factor Authentication](/azure/active-directory/authentication/concept-mfa-howitworks).

    1.  **Identity Protection** -- this is a security service from Azure AD. It analyses trillions of signals per day to identify and protect users from threats. For more information about the benefits of using Identity Protection, see [What is Identity Protection](/azure/active-directory/identity-protection/overview-identity-protection)?

    1.  **Privileged Identity Management (PIM)** -- this is another security service from Azure AD. It helps you to provide "super" user privileges temporarily for Azure AD (e.g., Global Admin) and Azure subscriptions (e.g., owner or contributor). For more information about PIM's time-based and approval-based role activation, see [What is Azure AD Privileged Identity Management](/azure/active-directory/privileged-identity-management/pim-configure)?

    1.  **Conditional Access** is an intelligent security service based on policies that you define to create rules that will allow or deny users to access Azure based on different conditions. For more information about making access conditional, see [What is Conditional Access?](/azure/active-directory/conditional-access/overview).

All security services named in the preceding text that are part of the architecture diagram may work together in any combination according to your business IT environment and your security requirements.

Anyway, Microsoft has other documents that may help you in your security journey for your business IT environment. Here are some of them:

- **Cloud Adoption Framework**

  The Cloud Adoption Framework provides security guidance for your cloud journey by clarifying the processes, best practices, models, and experience. More information about the framework, see [Security in the Microsoft Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/secure/).

- **Azure Well-Architected Framework**

  The Azure Well-Architected Framework is a set of guiding tenets that can be used to improve the quality of a workload. The framework is based on five pillars: reliability, security, cost optimization, operational excellence, and performance efficiency. More information about the framework, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/).

- **Microsoft Security Best Practices**

  This is one of the best Microsoft security documents available. Microsoft Security Best Practices (formerly known as the Azure Security Compass or Microsoft Security Compass) is a collection of best practices that provide clear, actionable guidance for security-related decisions. For a document that brings together all Microsoft security guidance, see [Microsoft Security Best Practices](/security/compass/compass).

- **Microsoft Cybersecurity Reference Architectures (MCRA)**

  This is a compilation of a variety of Microsoft security Reference architectures. For more information about Microsoft security capabilities, see [Microsoft Cybersecurity Reference Architectures](https://aka.ms/mcra).

## Next step

To get all details regarding this Architecture reference, see the other articles in this series:

- Part 1: [Use Azure monitoring to integrate security components](./azure-monitor-integrate-security-components.yml)
- Part 3: [Building the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)
- Part 4: [Build the second layer of defense with Microsoft 365 Defender Security services](./microsoft-365-defender-build-second-layer-defense.yml)
- Part 5: [Integration between Azure and Microsoft 365 Defender security services](./microsoft-365-defender-security-integrate-azure.yml)

## Related resources

This document refers to some services, technologies, and terminologies. You may find more information in the following resources:

- [What are public, private, and hybrid clouds?](https://azure.microsoft.com/overview/what-are-private-public-hybrid-clouds/)
- [Overview of the Azure Security Benchmark (v3)](/security/benchmark/azure/overview)
- [Embrace proactive security with Zero Trust](/security/business/zero-trust)
- [Microsoft 365](/microsoft-365) subscription information
- [Microsoft 365 Defender](/security/business/threat-protection/microsoft-365-defender)
