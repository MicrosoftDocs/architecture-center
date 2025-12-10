[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

You can use various Azure services to create a complete IT infrastructure for your organization. Azure also provides security services that help you protect that infrastructure. By using Azure security solutions, you can enhance your environment's security posture, mitigate vulnerabilities, and reduce breach risk via a well-architected solution based on Microsoft best practices.

Although some security services incur associated costs, many are available at no additional charge. Free services include network security groups (NSGs), storage encryption, TLS/SSL, shared access signature tokens, and more. This article focuses on these cost-free services.

This article is the third in a series of five. To review the previous two articles in this series, including the introduction and a review of how you can map threats against an IT environment, see the following article:

- [Map threats to your IT environment](./map-threats-it-environment.yml)

## Potential use cases

This article organizes Azure security services by Azure resource so you can focus on specific threats that target resources like virtual machines (VMs), operating systems, Azure networks, or applications, in addition to attacks that can compromise users and passwords. The following diagram can help you identify the Azure security services that help protect resources and user identities against these types of threats.

## Architecture

:::image type="content" alt-text="A diagram of on-premises resources, services from Microsoft 365 and Azure, and 16 types of threats as classified by the MITRE ATTACK matrix." source="../media/azure-security-build-first-layer-defense-architecture.png" lightbox="../media/azure-security-build-first-layer-defense-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components.vsdm) of this architecture.*

*©2021 The MITRE Corporation. This work is reproduced and distributed with the permission of The MITRE Corporation.*

The Azure security layer in this diagram is based on Azure Security Benchmark (ASB) v3, which is a set of security rules that are implemented through Azure policies. ASB is based on a combination of rules from [CIS Center for Internet Security](https://www.cisecurity.org) and [National Institute of Standards and Technology](https://www.nist.gov). For more information about ASB, see [Overview of the Azure Security Benchmark v3](/security/benchmark/azure/overview).

The diagram doesn't include every Azure security service available, but it does highlight the services that are used most commonly. All the security services shown in the architectural diagram can be combined and configured to work together with your IT environment and your organization's specific security needs.

### Workflow

This section describes the components and services that appear in the diagram. Many of those are labeled with their ASB control codes, in addition to their abbreviated labels. The control codes correspond to the control domains that are listed in [Controls](/security/benchmark/azure/overview#controls). 

1. **Azure Security Benchmark**

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

1. **Network**

    The following table describes the network services in the diagram.
    
    | Label | Description | Documentation |
    |---|---|---|
    | **NSG** | A free service that you attach to a network interface or subnet. An NSG allows you to filter TCP or UDP protocol traffic by using IP address ranges and ports for inbound and outbound connections. | [Network security groups](/azure/virtual-network/network-security-groups-overview) |
    | **VPN** | A virtual private network (VPN) gateway that delivers a tunnel with IPSEC (IKE v1/v2) protection. | [VPN Gateway](https://azure.microsoft.com/services/vpn-gateway) |
    | **Azure Firewall** | A platform as a service (PaaS) that delivers protection in layer 4 and is attached to an entire virtual network. | [What is Azure Firewall?](/azure/firewall/overview) |
    | **App GW + WAF** | Azure Application Gateway with Web Application Firewall (WAF). Application Gateway is a load balancer for web traffic that works in layer 7 and adds WAF to protect applications that use HTTP and HTTPS. | [What is Azure Application Gateway?](/azure/application-gateway/overview)|
    | **NVA** | Network virtual appliance (NVA). A virtual security service from the marketplace that's provisioned on VMs on Azure. | [Network virtual appliances](https://azure.microsoft.com/solutions/network-appliances) |
    | **DDOS** | DDoS protection implemented on the virtual network to help you mitigate different types of DDoS attacks. | [Azure DDoS Network Protection overview](/azure/ddos-protection/ddos-protection-overview) |
    | **TLS/SSL** | TLS/SSL deliver encryption in transit for most Azure services that exchange information, such as Azure Storage and Web Apps. | [Configure end-to-end TLS by using Application Gateway with PowerShell](/azure/application-gateway/application-gateway-end-to-end-ssl-powershell) |
    | **Private Link** | Service that allows you to create a private network for an Azure service that initially is exposed to the internet. | [What is Azure Private Link?](/azure/private-link/private-link-overview) |
    | **Private endpoint** | Creates a network interface and attaches it to the Azure service. Private Endpoint is part of Private Link. This configuration lets the service become part of your virtual network through a private endpoint. | [What is a private endpoint?](/azure/private-link/private-endpoint-overview) |

1. **Infrastructure and endpoints**

    The following table describes infrastructure and endpoint services that are shown in the diagram.

    | Label | Description | Documentation |
    |---|---|---|
    | **Bastion** | Bastion provides jump server functionality. This service allows you to access your VMs through remote desktop protocol (RDP) or SSH without exposing your VMs to the internet. | [What is Azure Bastion?](/azure/bastion/bastion-overview) |
    | **Antimalware** | Microsoft Defender provides antimalware service and is part of Windows 10, Windows 11, Windows Server 2016, and Windows Server 2019. | [Microsoft Defender Antivirus in Windows](/microsoft-365/security/defender-endpoint/microsoft-defender-antivirus-windows?view=o365-worldwide) |
    | **Disk encrypt** | Disk Encryption allows you to encrypt the disk of a VM. | [Azure Disk Encryption for Windows VMs](/azure/virtual-machines/windows/disk-encryption-overview) |
    | **Keyvault** | Key Vault, a service to store keys, secrets, and certificates with FIPS 140-2 Level 2 or 3. | [Azure Key Vault basic concepts](/azure/key-vault/general/basic-concepts) |
    | **RDP Short** | Azure Virtual Desktop RDP Shortpath. This feature allows remote users to connect to the Virtual Desktop service from a private network. | [Azure Virtual Desktop RDP Shortpath for managed networks](/azure/virtual-desktop/shortpath) |
    | **Reverse connect** | A built-in security feature from Azure Virtual Desktop. Reverse connect guarantees that remote users receive only pixel streams and don't reach the host VMs. | [Understanding Azure Virtual Desktop network connectivity](/azure/virtual-desktop/network-connectivity) |

1. **Application and data**

    The following table describes application and data services that are shown in the diagram.

    | Label | Description | Documentation |
    |---|---|---|
    | **Frontdoor + WAF** | A content delivery network (CDN). Front Door combines multiple points of presence to deliver a better connection for users who access the service and adds WAF. | [What is Azure Front Door?](/azure/frontdoor/front-door-overview) |
    | **API Management** | A service that delivers security for API calls and manages APIs across environments. | [About API Management](/azure/api-management/api-management-key-concepts) |
    | **PenTest** | A set of best practices to execute a penetration test in your environment, including Azure resources. | [Penetration testing](/azure/security/fundamentals/pen-testing) |
    | **Storage SAS token** | A shared access token using expiration policies to allow others to access your Azure storage account. | [Grant limited access to Azure Storage resources using shared access signatures (SAS)](/azure/storage/common/storage-sas-overview) |
    | **Private endpoint** | Create a network interface and attach it to your storage account to configure it inside a private network on Azure. | [Use private endpoints for Azure Storage](/azure/storage/common/storage-private-endpoints) |
    | **Storage firewall** | Firewall that allows you to set a range of IP addresses that can access your storage account. | [Configure Azure Storage firewalls and virtual networks](/azure/storage/common/storage-network-security?tabs=azure-portal) |
    | **Encryption**<br/>(Azure Storage) | Protects your storage account with encryption at rest. | [Azure Storage encryption for data at rest](/azure/storage/common/storage-service-encryption) |
    | **SQL audit** | Tracks database events and writes them to an audit log in your Azure storage account. For analytics scenarios that use Microsoft Fabric warehouses or lakehouses, use Fabric workspace activity logs and Microsoft Purview (when enabled) to monitor access and classification. | [Auditing for Azure SQL Database](/azure/azure-sql/database/auditing-overview)<br/><br/>[Microsoft Purview overview](/azure/purview/overview) |
    | **Vulnerability assessment** | Service that helps you discover, track, and remediate potential database vulnerabilities. | [SQL vulnerability assessment helps you identify database vulnerabilities](/azure/azure-sql/database/sql-vulnerability-assessment?tabs=azure-powershell) |
    | **Encryption**<br/>(Azure SQL) | Transparent data encryption (TDE) encrypts data at rest for Azure SQL Database services. Microsoft Fabric data stored in OneLake is encrypted at rest by default with platform-managed encryption, aligned with Fabric security fundamentals. | [Transparent data encryption for SQL Database and SQL Managed Instance](/azure/azure-sql/database/transparent-data-encryption-tde-overview?tabs=azure-portal)<br/><br/>[Security in Microsoft Fabric](/fabric/security/security-overview) |

1. **Identity**

    The following table describes identity services that are shown in the diagram.

    | Label | Description | Documentation |
    |---|---|---|
    | **RBAC** | Azure role-based access control (Azure RBAC) helps you manage access to Azure services by using granular permissions that are based on users' Microsoft Entra credentials. | [What is Azure role-based access control (Azure RBAC)?](/azure/role-based-access-control/overview) |
    | **MFA** | Multifactor authentication offers additional types of authentication beyond user names and passwords. | [How it works: Microsoft Entra multifactor authentication](/entra/identity/authentication/concept-mfa-howitworks) |
    | **ID protection** | Identity Protection, a security service from Microsoft Entra ID, analyzes trillions of signals per day to identify and protect users from threats. | [What is Identity Protection?](/entra/id-protection/overview-identity-protection) |
    | **PIM** | Privileged Identity Management (PIM), a security service from Microsoft Entra ID. It helps you to provide superuser privileges temporarily for Microsoft Entra ID (for example, User Administrator) and Azure subscriptions (for example, Role Based Access Control Administrator or Key Vault Administrator). | [What is Microsoft Entra Privileged Identity Management?](/entra/id-governance/privileged-identity-management/pim-configure) |
    | **Cond Acc** | Conditional Access is an intelligent security service that uses policies that you define for various conditions to block or grant access to users. | [What is Conditional Access?](/entra/identity/conditional-access/overview) |

### Components

- [Microsoft Entra ID](/entra/fundamentals/whatis) is an identity and access management service. In this architecture, it manages user identities and access to external resources such as Microsoft 365 and the Azure portal, and internal resources such as apps on your corporate intranet network.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service  that enables secure communication between Azure resources, the internet, and on-premises networks. In this architecture, it provides the private network infrastructure that supports secure connectivity and isolation for workloads.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a low-latency layer-4 load balancing service for UDP and TCP traffic. Load Balancer is a zone-redundant service that can handle millions of concurrent flows. In this architecture, it ensures high availability and scalability by distributing inbound and outbound traffic across resources in the virtual network.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure as a service (IaaS) offering that provides scalable compute resources. In this architecture, VMs host workloads that require direct control over the operating system and security configurations.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed container orchestration service that simplifies deploying and managing Kubernetes clusters. In this architecture, AKS runs containerized applications and provides built-in features for security, governance, and continuous integration/continuous delivery (CI/CD).

- [Virtual Desktop](/azure/virtual-desktop/overview) is a desktop and app virtualization service that delivers remote desktops from the cloud. In this architecture, it provides secure access to corporate desktops for remote users and includes built-in features like RDP Shortpath and reverse connect.

- [The Web Apps feature of App Service](/azure/well-architected/service-guides/app-service-web-apps) hosts web applications, REST APIs, and mobile back ends. In this architecture, Web Apps hosts HTTP-based applications and provides security features like TLS and private endpoints. You can develop in your chosen language. Applications run and scale in both Windows and Linux-based environments.

- [Azure Storage](/azure/storage/common/storage-introduction) is a scalable and secure storage solution for various data types, including blobs, files, queues, and tables. In this architecture, it stores application and system data with encryption at rest and supports secure access via SAS tokens and private endpoints.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a managed relational database service that automates patching, backups, and monitoring. In this architecture, it provides secure and compliant data storage via features like transparent data encryption, auditing, and vulnerability assessments.

- [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is a unified SaaS analytics platform that brings together data engineering, data warehousing, real-time analytics, and business intelligence. In this architecture, you can adopt Fabric for analytics workloads that need governed workspaces, OneLake encryption at rest, item-level role-based access, and centralized activity logging while operational data remains in services such as Azure SQL Database.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-oliveira-69443523/) | Senior Azure Security Engineer

Other contributors:

- [Gary Moore](https://www.linkedin.com/in/gwmoore/) | Programmer/Writer
- [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan/) | Senior Customer Engineering Manager
- [Filipe Moreira](https://www.linkedin.com/in/filipefumaux/) | Cloud Solution Architect

## Next steps

Microsoft has more documentation that can help you secure your IT environment, and the following articles can be particularly helpful:

- [Security in the Microsoft Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/secure). The Cloud Adoption Framework provides security guidance for your cloud journey by clarifying the processes, best practices, models, and experience.
- [Microsoft Azure Well-Architected Framework](/azure/well-architected/). The Azure Well-Architected Framework is a set of guiding tenets that you can use to improve the quality of a workload. The framework is based on five pillars: reliability, security, cost optimization, operational excellence, and performance efficiency.
- [Microsoft Security Best Practices](/security/compass/compass). Microsoft Security Best Practices (formerly known as the *Azure Security Compass* or *Microsoft Security Compass*) is a collection of best practices that provide clear, actionable guidance for security-related decisions.
- [Microsoft Cybersecurity Reference Architectures (MCRA)](/security/cybersecurity-reference-architecture/mcra). MCRA is a compilation of various Microsoft security reference architectures.

In the following resources, you can find more information about the services, technologies, and terminologies that are mentioned in this article:

- [What are public, private, and hybrid clouds?](https://azure.microsoft.com/overview/what-are-private-public-hybrid-clouds)
- [Overview of the Azure Security Benchmark (v3)](/security/benchmark/azure/overview)
- [Embrace proactive security with Zero Trust](/security/zero-trust/)
- [Microsoft 365](/microsoft-365) subscription information
- [Microsoft Defender XDR](/microsoft-365/security/defender/microsoft-365-defender)

## Related resources

For more information about this reference architecture, see the other articles in this series:

- Part 1: [Map threats to your IT environment](./map-threats-it-environment.yml)
- Part 3: [Build the second layer of defense with Microsoft Defender XDR Security services](./microsoft-365-defender-build-second-layer-defense.yml)
- Part 4: [Integration between Azure and Microsoft Defender XDR security services](./microsoft-365-defender-security-integrate-azure.yml)
