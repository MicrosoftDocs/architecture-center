You can build an entire IT infrastructure to run your organization by using a variety of Azure services. Azure also offers security services to protect your infrustructure. Through using Azure security services, you can improve the security posture of your IT environment. You can mitigate vulnerabilities and avoid breaches by implementing a well-architected solution that follows recommendations from Microsoft. Some security services incur fees while others have no additional charges. Free services include network security groups (NSGs), storage encryption, TLS/SSL, shared access signature (SAS) tokens, and many others. This article covers such services.

This is the third article that is part of a series of five. To review the previous two articles in this series, including the introduction and a review of how you can map threats against an IT environment, see the following articles:

- [Use Azure monitoring to integrate security components](../../guide/security/azure-monitor-integrate-security-components.yml)
- [Map threats to your IT environment](./map-threats-it-environment.yml)

## Potential use cases

This article presents Azure security services according to each Azure service. In this way, you can think of a specific threat against resource—a VM, an operating system, an Azure network, an application—or an attack that might compromise users and passwords. Then use the diagram in this article to help you understand which Azure security services to use to protect resources and user identities from that type of threat.

The Azure security layer in this diagram is based on Azure Security Benchmark (ASB) v3, which is a set of security rules that are implemented through Azure policies. ASB is based on a combination of rules from [CIS Center for Internet Security](https://www.cisecurity.org/) and [National Institute of Standards and Technology](https://www.nist.gov/). For more information about ASB, see [Overview of the Azure Security Benchmark v3](/security/benchmark/azure/overview).

The following diagram doesn't contain all of the Azure security services that are available, but it shows the security services that are most commonly used by organizations. In the diagram, many of the services are labeled with their ASB control codes, in addition to abbreviated names. The control codes correspond to the control domains that are listed in [Controls](/security/benchmark/azure/overview#controls).

:::image type="content" alt-text="A diagram of on-premises resources, Microsoft 365 services, Azure services, Azure security services, and threats. In the diagram, there are 16 types of threats as classified by the MITRE ATTACK matrix." source="../media/azure-security-build-first-layer-defense-architecture.png" lightbox="../media/azure-security-build-first-layer-defense-architecture.png":::

©2021 The MITRE Corporation. This work is reproduced and distributed with the permission of The MITRE Corporation.

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components.vsdm) of this architecture.*

ASB and Azure Security Baselines ([Azure Security Benchmark overview](/security/benchmark/azure/security-baselines-overview)) describe Azure security services. In this article, we highlight only the services that are presented in the diagram.

Let's review some details presented in the diagram.

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

    - **NSG**
    
      A free service that you attach to a network interface or subnet. An NSG allows you to filter TCP or UDP protocol traffic by using IP address ranges and ports for inbound and outbound connections. For more information about NSGs, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

    - **VPN**

      A virtual private network (VPN) gateway that delivers a tunnel with IPSEC (IKE v1/v2) protection. For more information about site-to-site and point-to-site VPNs, see [VPN Gateway](https://azure.microsoft.com/en-us/services/vpn-gateway/).

    - **AZURE FIREWALL**
    
      A platform as a service (PaaS) that delivers protection in layer four and is attached to an entire VNET. For more information, see [What is Azure Firewall](/azure/firewall/overview)?

    - **APP GW + WAF**

      Azure Application Gateway with Web Application Firewall (WAF). Application Gateway is a load balancer for web traffic that works in layer seven and adds WAF to protect applications that use HTTP and HTTPS. For more information, see [What is Azure Application Gateway](/azure/application-gateway/overview)?

    - **NVA**

      Network Virtual Appliance (NVA), a virtual security services from the marketplace that is provisioned on VMs on Azure. For more information, see [Network Virtual Appliances](https://azure.microsoft.com/solutions/network-appliances/).

    - **DDOS**

      DDoS protection implemented on the virtual network to help you mitigate different types of DDoS attacks. For more information, see [Azure DDoS Protection Standard overview](/azure/ddos-protection/ddos-protection-overview).

    - **TLS/SSL**

      TLS/SSL deliver encryption in transit for most Azure services that exchange information, such as Azure Storage and Web Apps. For more information, see [Configure end-to-end TLS by using Application Gateway with PowerShell](/azure/application-gateway/application-gateway-end-to-end-ssl-powershell).

    - **PRIVATE LINK**

      Service that allows you to create a private network for an Azure service that initially is exposed to the internet. For more information, see [What is Azure Private Link](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview)?

    - **PRIVATE ENDPOINT**

      Creates a network interface and attaches it to the Azure service. Private Endpoint is part of Private Link. This configuration lets the service, by using a private endpoint, be part of your virtual network. For more information, see [What is a private endpoint](/azure/private-link/private-endpoint-overview)?

3.  **INFRASTRUCTURE AND ENDPOINT**

    - **BASTION**

      Bastion provides jump server functionality. This service allows you to access your VMs through RDP or SSH without exposing your VMs to the internet. For more information, see [What is Azure Bastion](/azure/bastion/bastion-overview)?

    - **ANTIMALWARE**

      Microsoft Defender provide anti-malware service and is part of Windows 10, Windows 11, Windows Server 2016, and Windows Server 2019. For more information, see [Microsoft Defender Antivirus in Windows](/microsoft-365/security/defender-endpoint/microsoft-defender-antivirus-windows?view=o365-worldwide).

    - **DISK ENCRYPT**

      Disk Encryption allows you to encrypt the disk of a VM. For more information about using BitLocker to secure storage on your VMs, see [Azure Disk Encryption for Windows VMs](/azure/virtual-machines/windows/disk-encryption-overview).

    - **KEYVAULT**

      Key Vault, a service to store keys, secrets, and certificates with FIPS 140-2 Level 2 or 3. For more information about using Key Vault to store secrets, see [Azure Key Vault basic concepts](/azure/key-vault/general/basic-concepts).

    - **RDP SHORT**

      Azure Virtual Desktop RDP Shortpath. This feature allows remote users to connect to the Virtual Desktop service from a private network. For more information about using Azure Virtual Desktop over RDP, see [Azure Virtual Desktop RDP Shortpath for managed networks](https://docs.microsoft.com/en-us/azure/virtual-desktop/shortpath).

    - **Reverse Connect**

      A built-in security feature from Azure Virtual Desktop. Reverse connect guarantees that remote users only receive pixel streams and don't reach the host VMs. For more information, see [Understanding Azure Virtual Desktop network connectivity](/azure/virtual-desktop/network-connectivity).

4.  **Application and Data**

    - **FRONTDOOR + WAF**

      A content delivery network (CDN). Front Door combines multiple points of presence to deliver a better connection for users who access the service and adds WAF. For more information about this CDN, see [What is Azure Front Door](/azure/frontdoor/front-door-overview)?

    - **API MANAGEMENT**

      A service that delivers security for API calls. For more information about managing APIs across environments, see [About API Management](/azure/api-management/api-management-key-concepts).

    - **PENTEST**

      A set of best practices to execute a penetration test in your environment. For more information about penetration testing on Azure, see [Penetration testing](/azure/security/fundamentals/pen-testing).

    - **Storage SAS Token**

      a temporary key to allow others to access your Azure storage account. For more information about using SAS tokens with Azure storage, see [Grant limited access to Azure Storage resources using shared access signatures (SAS)](/azure/storage/common/storage-sas-overview).

    - **Storage Private endpoint**

      create a network card and attach it to your storage account to configure it inside a private network on Azure. For more information about configuring private access or Private Link, see [Use private endpoints for Azure Storage](/azure/storage/common/storage-private-endpoints).

    - **Storage Firewall**

      allows you to set a range of IP addresses that can access your storage account. For more information about configuring access to your data in Azure Storage to a virtual network, see [Configure Azure Storage firewalls and virtual networks](/azure/storage/common/storage-network-security?tabs=azure-portal).

    - **Storage encryption**

      set your storage account with encryption at rest. For more information about encryption in Azure Storage, see [Azure Storage encryption for data at rest](/azure/storage/common/storage-service-encryption).

    - **SQL Audit**

      tracks database events and writes them to an audit log in your Azure storage account.  For more information about tracking and logging database events, see [Auditing for Azure SQL Database and Azure Synapse Analytics](/azure/azure-sql/database/auditing-overview).

    - **SQL Vulnerability Assessment**

      is a service that helps you discover, track, and remediate potential database vulnerabilities. For more about assessing vulnerabilities in databases, see [SQL vulnerability assessment helps you identify database vulnerabilities](/azure/azure-sql/database/sql-vulnerability-assessment?tabs=azure-powershell).

    - **SQL Encryption**

      Transparent data encryption (TDE) helps protect Azure SQL database services by encrypting data at rest. For more information about TDE, see [Transparent data encryption for SQL Database, SQL Managed Instance, and Azure Synapse Analytics](/azure/azure-sql/database/transparent-data-encryption-tde-overview?tabs=azure-portal).

5.  **Identity**

    - **Azure role-based access control (Azure RBAC)**

      Azure Azure RBAC helps you provide granular permissions to different Azure services based on Azure AD user's credentials. For more about managing access and permissions, see [What is Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview)?

    - **Multi-factor authentication**

      Multi-factor authentication offers additional authentication types on top of traditional user name and password authentication. For more information about requiring more forms of authentication, see [How it works: Azure AD Multi-Factor Authentication](/azure/active-directory/authentication/concept-mfa-howitworks).

    - **Identity Protection**

      this is a security service from Azure AD. It analyses trillions of signals per day to identify and protect users from threats. For more information about the benefits of using Identity Protection, see [What is Identity Protection](/azure/active-directory/identity-protection/overview-identity-protection)?

    - **Privileged Identity Management (PIM)**

      this is another security service from Azure AD. It helps you to provide "super" user privileges temporarily for Azure AD (for example, Global Admin) and Azure subscriptions (for example, owner or contributor). For more information about PIM's time-based and approval-based role activation, see [What is Azure AD Privileged Identity Management](/azure/active-directory/privileged-identity-management/pim-configure)?

    - **Conditional Access**

      is an intelligent security service based on policies that you define to create rules that allow or deny users to access Azure based on different conditions. For more information about making access conditional, see [What is Conditional Access?](/azure/active-directory/conditional-access/overview).

All security services named in the preceding text that are part of the architecture diagram can work together in any combination according to your business IT environment and your security requirements.

Anyway, Microsoft has other documents that can help you in your security journey for your business IT environment. Here are some of them:

- **Cloud Adoption Framework**

  The Cloud Adoption Framework provides security guidance for your cloud journey by clarifying the processes, best practices, models, and experience. More information about the framework, see [Security in the Microsoft Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/secure/).

- **Azure Well-Architected Framework**

  The Azure Well-Architected Framework is a set of guiding tenets that can be used to improve the quality of a workload. The framework is based on five pillars: reliability, security, cost optimization, operational excellence, and performance efficiency. More information about the framework, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/).

- **Microsoft Security Best Practices**

  This is one of the best Microsoft security documents available. Microsoft Security Best Practices (formerly known as the Azure Security Compass or Microsoft Security Compass) is a collection of best practices that provide clear, actionable guidance for security-related decisions. For a document that brings together all Microsoft security guidance, see [Microsoft Security Best Practices](/security/compass/compass).

- **Microsoft Cybersecurity Reference Architectures (MCRA)**

  This is a compilation of various Microsoft security Reference architectures. For more information about Microsoft security capabilities, see [Microsoft Cybersecurity Reference Architectures](https://aka.ms/mcra).


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

 * [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-r-oliveira-69443523) | Senior Customer Engineer

Other contributors: 

 * [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
 * [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager


## Next steps

This document refers to some services, technologies, and terminologies. You can find more information about them in the following resources:

- [What are public, private, and hybrid clouds?](https://azure.microsoft.com/overview/what-are-private-public-hybrid-clouds/)
- [Overview of the Azure Security Benchmark (v3)](/security/benchmark/azure/overview)
- [Embrace proactive security with Zero Trust](/security/business/zero-trust)
- [Microsoft 365](/microsoft-365) subscription information
- [Microsoft 365 Defender](/security/business/threat-protection/microsoft-365-defender)

## Related resources

