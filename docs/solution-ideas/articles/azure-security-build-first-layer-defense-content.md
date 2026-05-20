[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article is the second in a series of four that explains how to design a layered security architecture by using Microsoft security solutions.

The first article describes how to [map ransomware threats across a hybrid enterprise environment](map-threats-it-environment.yml) by using the MITRE ATT&CK framework. That article demonstrates how attackers typically gain initial access, escalate privileges, move laterally, and ultimately affect identities, infrastructure, applications, and data.

This second article builds directly on that foundation and focuses on the first layer of defense: pre-breach security.

## Architecture

:::image type="complex" source="../media/azure-monitor-integrate-security-components-2.svg" alt-text="Microsoft Zero Trust pillars mapped to Azure security controls and ATT&CK techniques." border="false" lightbox="../media/azure-monitor-integrate-security-components-2.svg"::: 

Diagram that shows how Zero Trust pillars map to Azure security controls across a hybrid environment. The following labels designating the pillars appear across the top of the diagram: 2. Network, 3. Infrastructure and endpoints, 4. Application and data, 5. Identity. Across the upper rows, the customer environment begins on the left with on-premises assets such as firewall, DNS, VLANs, servers, clients, applications, file servers, databases, and an AD DS domain controller. Below those services are Microsoft 365 Apps and Azure resources such as public IPs, load balancers, a virtual network, servers, AKS, Virtual Desktop, Web Apps, Azure Storage, SQL Database, and Entra ID. On-premises AD DS connects via Entra Connect to Entra ID in Microsoft 365 and Azure. Beneath those resource rows, Azure security services are grouped under the same pillars. Below the services, the controls used to protect each pillar are shown. For network security, the controls are WAF, DDoS protection, TLS/SSL, Private Link, Azure Firewall, NSGs, VPN, and NVA. For infrastructure and endpoints, the controls are Bastion, anti-malware, disk encryption, Key Vault, Application Gateway, a privilege cluster, Conditional Access, MFA, RDP Shortpath, and reverse connect. For application and data, the controls are Azure Front Door with Web Application Firewall, API Management, Application Gateway with Web Application Firewall,  SAS tokens, Private Endpoint, storage firewalls, encryption, SQL audit, and vulnerability assessment. For identity, the controls are MFA, RBAC, Identity Protection, PIM, and Conditional Access. The bottom half is labeled as a MITRE ATT&CK matrix and breaks attacks into network attacks, infrastructure and process attacks, application and storage attacks, and identity compromise. The following example ATT&CK techniques are shown: Remote System Discovery, Remote Access Tools, Create and Modify System Process, System Information Discovery, Virtualization Evasion, Process Injection, Scheduled Task / Job, Signed Binary Process Execution, Command and Scripting Interpreter, File and Directory Discovery, Masquerading, Ingress Tool Transfer, Obfuscated Files, Account Manipulation, and OS Credential Dumping.

:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components-2.vsdx) of this architecture.*

*This image incorporates concepts and terminology from the MITRE ATT&CK® Framework developed by [The MITRE Corporation](https://attack.mitre.org/index.html). ATT&CK® is a registered trademark of The MITRE Corporation.*

The Azure security layer shown in this diagram aligns with the Azure Security Benchmark (ASB) v3, which defines the Microsoft recommended security controls across identity, networking, compute, data, and governance.

Currently, these controls are primarily implemented and monitored via:

- Azure Policy.
- Microsoft Defender for Cloud.
- Built-in platform security defaults.

The diagram doesn't include every available service. Instead, it includes commonly deployed, high-impact controls that directly mitigate ransomware attack paths.

### Workflow

The following workflow corresponds to the previous diagram:

1. Azure security services contribute to pre-breach protection for each of the following Zero Trust pillars: network, infrastructure and endpoints, application and data, and identity.
1. Network services in the architecture include network security groups (NSG), a virtual private network (VPN) gateway, Azure Firewall, Azure Application Gateway with Azure Web Application Firewall, a network virtual appliance (NVA), Azure DDoS Network Protection, TLS/SSL, which provide encryption, Azure Private Link, and private endpoints.
1. Infrastructure and endpoint services in the architecture include Azure Bastion, Microsoft Defender anti-malware service, disk encryption, Azure Key Vault, Azure Virtual Desktop RDP Shortpath, and Virtual Desktop reverse connect.
1. Application and data services in the diagram include Azure Front Door with Web Application Firewall, Azure API Management, penetration testing, Azure Storage shared access signatures (SAS), private endpoints, an Azure Storage firewall, Azure Storage encryption, SQL auditing, SQL vulnerability assessment, and encryption for Azure SQL Database services.
1. Identity services in the architecture include Azure role-based access control (Azure RBAC), Microsoft Entra multifactor authentication, Microsoft Entra ID Protection, Microsoft Entra Privileged Identity Management (PIM), and Microsoft Entra Conditional Access.

The numbers in the ATT&CK matrix correspond to technique numbers assigned by [MITRE](https://attack.mitre.org/techniques/enterprise/).

### Components

- [Microsoft Entra ID](/entra/fundamentals/what-is-entra) is an identity and access management service. In this architecture, it manages user identities and access to external resources such as Microsoft 365 and the Azure portal, and internal resources such as apps on your corporate intranet network.

- [Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service that provides secure communication between Azure resources, the internet, and on-premises networks. In this architecture, it provides the private network infrastructure that supports secure connectivity and isolation for workloads.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a low-latency layer-4 load balancing service for UDP and TCP traffic. Load Balancer is a zone-redundant service that can handle millions of concurrent flows. In this architecture, it ensures high availability and scalability by distributing inbound and outbound traffic across resources in the virtual network.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure as a service (IaaS) offering that provides scalable compute resources. In this architecture, virtual machines host workloads that require direct control over the operating system and security configurations.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed container orchestration service that simplifies deploying and managing Kubernetes clusters. In this architecture, AKS runs containerized applications and provides built-in features for security, governance, and continuous integration/continuous delivery (CI/CD).

- [Virtual Desktop](/azure/virtual-desktop/overview) is a desktop and app virtualization service that you can use to create remote desktops from the cloud. In this architecture, it provides secure access to corporate desktops for remote users. The architecture uses built-in features like [RDP Shortpath](/azure/virtual-desktop/shortpath) and [reverse connect](/azure/virtual-desktop/network-connectivity).

- [The Web Apps feature of Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) hosts web applications, REST APIs, and mobile back ends. In this architecture, Web Apps hosts HTTP-based applications and provides security features like TLS and [private endpoints](/azure/private-link/private-endpoint-overview). You can develop applications in the language of your choice. Applications run and scale in both Windows and Linux-based environments.

- [Azure Storage](/azure/storage/common/storage-introduction) is a scalable and secure storage solution for various data types, including blobs, files, queues, and tables. In this architecture, it stores application and system data with encryption at rest and supports secure access via [SAS tokens](/azure/storage/common/storage-sas-overview) and [private endpoints](/azure/private-link/private-endpoint-overview).

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a managed relational database service that automates patching, backups, and monitoring. In this architecture, it provides secure and compliant data storage via features like [transparent data encryption](/azure/azure-sql/database/transparent-data-encryption-tde-overview), [auditing](/azure/azure-sql/database/auditing-overview), and [vulnerability assessments](/azure/defender-for-cloud/sql-azure-vulnerability-assessment-overview).

- [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is a unified SaaS analytics platform that brings together data engineering, data warehousing, real-time analytics, and business intelligence. In this architecture, you can use Fabric for analytics workloads that need governed workspaces, OneLake encryption at rest, item-level role-based access, and centralized activity logging while operational data remains in services like SQL Database.

- [Network security group (NSG)](/azure/virtual-network/network-security-groups-overview) is a free service that you attach to a network interface or subnet. An NSG allows you to filter TCP or UDP protocol traffic by using IP address ranges and ports for inbound and outbound connections.

- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a virtual private network (VPN) gateway that provides a tunnel with IPSEC (IKE v1/v2) protection.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a platform as a service (PaaS) that provides protection in layer 4 and is attached to an entire virtual network.

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a load balancer for web traffic that works in layer 7 and adds Azure Web Application Firewall to protect applications that use HTTP and HTTPS.

- [Network virtual appliance (NVA)](../../networking/guide/network-virtual-appliance-high-availability.md) is a virtual security service from the marketplace that's provisioned on VMs on Azure.

- [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) implements DDoS protection on the virtual network to help you mitigate various types of DDoS attacks.

- [Private Link](/azure/private-link/private-link-overview) enables you to create a private network for an Azure service that's initially exposed to the internet.

- [Azure Bastion](/azure/bastion/bastion-overview) provides jump server functionality. You can use this service to access your VMs through remote desktop protocol (RDP) or SSH without exposing them to the internet.

- [Microsoft Defender Antivirus in Windows](/microsoft-365/security/defender-endpoint/microsoft-defender-antivirus-windows) provides anti-malware services. It's part of Windows 10, Windows 11, Windows Server 2016, and Windows Server 2019.

- [Encryption at host](/azure/virtual-machines/disk-encryption#encryption-at-host---end-to-end-encryption-for-your-vm-data) is an optional enhancement to Azure managed disks that provides end-to-end encryption for VM data, including temporary disks and disk caches, for supported VM sizes. Azure managed disks are encrypted at rest by default with server-side encryption (SSE).

- [Key Vault](/azure/key-vault/general/overview) is a service for storing keys, secrets, and certificates with FIPS 140-2 Level 2 or 3.

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) is a content delivery network (CDN). It combines multiple points of presence to deliver a better connection for users who access the service. It also adds Azure Web Application Firewall.

- [API Management](/azure/well-architected/service-guides/azure-api-management) is a service that provides security for API calls and manages APIs across environments.

- [Azure RBAC](/azure/role-based-access-control/overview) helps you manage access to Azure services by using granular permissions that are based on users' Microsoft Entra credentials.

- [Microsoft Entra multifactor authentication](/entra/identity/authentication/concept-mfa-howitworks) provides other types of authentication beyond user names and passwords.

- [Privileged Identity Management (PIM)](/entra/id-governance/privileged-identity-management/pim-configure) helps you to provide superuser privileges temporarily for Microsoft Entra ID (for example, User Administrator) and Azure subscriptions (for example, Role Based Access Control Administrator or Key Vault Administrator).

- [Conditional Access](/entra/identity/conditional-access/overview) is an intelligent security service that uses policies that you define for various conditions to block or grant user access.

## Scenario details

Pre-breach controls are designed to reduce attack surface, eliminate common misconfigurations, and block attackers before an intrusion begins. These controls align closely with Microsoft Zero Trust principles. Zero Trust is based on the philosophy that no resource is implicitly trusted and access is continuously verified.

The goal of this article is to show how you can combine foundational Azure security services to disrupt common ransomware entry points identified in the threat map in the first article in this series, [Map threats to your IT environment](./map-threats-it-environment.yml).

As pointed out in that article, ransomware attacks rarely start with sophisticated exploits. In most real-world incidents, attackers succeed because of:

- Exposed services.
- Weak identity controls.
- Excessive privileges.
- Flat networks.
- Unencrypted data paths.

The controls described in this article aren't advanced detection or response tools. Instead, they form the baseline security posture that makes ransomware campaigns significantly harder to run.

When these controls are missing or misconfigured, attackers often succeed before detection tools even have a chance to send alerts.

### Azure Security Benchmark

Each security control in the Azure Security Benchmark refers to one or more specific Azure security services. The architecture reference in this article shows some of them. The controls include:

- Network security.
- Identity management.
- Privileged access.
- Data protection.
- Asset management.
- Logging and threat detection.
- Incident response.
- Posture and vulnerability management.
- Endpoint security.
- Backup and recovery.
- DevOps security.
- Governance and strategy.

For more information about security controls, see [Overview of the Azure security controls (v3)](/security/benchmark/azure/overview-v3).

### Potential use cases

This article organizes Azure security services by resource type so you can directly map them to ransomware techniques identified earlier, such as:

- Initial access through exposed services.
- Credential theft and brute-force attacks.
- Lateral movement across networks.
- Unauthorized access to data stores.
  
The architecture diagram at the start of this article highlights how these services protect identities, networks, compute, applications, and data before an attacker establishes persistence.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-oliveira-69443523/) | Senior Azure Security Engineer

Other contributors:

- [Gary Moore](https://www.linkedin.com/in/gwmoore/) | Programmer/Writer
- [Filipe Moreira](https://www.linkedin.com/in/filipefumaux/) | Cloud Solution Architect
- [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan/) | Senior Customer Engineering Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

This article focuses on preventing attacks before they start by applying foundational Azure security controls.

[The next article in the series](./microsoft-365-defender-build-second-layer-defense.yml) assumes that some attacks will still succeed and focuses on:

- Advanced threat detection.
- Behavioral analytics.
- Incident response and investigation.

## Related resources

For more information about this reference architecture, see the other articles in this series:

- Part 1: [Map threats to your IT environment](./map-threats-it-environment.yml)
- Part 3: [Build the second layer of defense with Microsoft Defender XDR Security services](./microsoft-365-defender-build-second-layer-defense.yml)
- Part 4: [Integrate Azure and Microsoft Defender XDR security services](./microsoft-365-defender-security-integrate-azure.yml)
