[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article outlines how to diagram your organization's core IT environment and create a threat map. These diagrams are valuable tools for planning and building a robust defensive security layer. Understanding your IT environment and its architecture is crucial for identifying the security services needed to provide adequate protection.

Computer systems hold information that isn't only valuable to the organizations that generate it but also to malicious actors. These actors, whether individuals or groups, engage in harmful activities aimed at compromising or damaging the computers, devices, systems, and networks of companies. Their goal is often to steal or corrupt sensitive data using threats like malware or brute force attacks.

In this article, we explore a method for mapping threats to your IT environment, enabling you to plan the implementation of Microsoft security services as part of your security strategy. 

The good news is that you don’t need to create a threat map from scratch. The MITRE ATT&CK matrix offers an excellent resource to help you develop one. MITRE ATT&CK is a global knowledge base that maps real-world threats based on observed tactics and techniques. The MITRE Corporation documents every known threat in detail, providing valuable insights into how these threats operate and how you can defend against them. This publicly accessible resource is available online at MITRE ATT&CK®.

In this article, we use a subset of these threats to illustrate how you can map threats to your IT environment.

## Potential use cases

Some threats are common across all industries, such as ransomware, DDoS attacks, cross-site scripting, and SQL injection. However, many organizations face specific threats unique to their industry or based on past cyberattacks they’ve encountered. The diagram in this article can help you map those threats for your organization by identifying the areas most likely to be targeted by malicious actors. Creating a threat map enables you to plan the necessary defense layers for a more secure environment.

You can adapt this diagram to model different combinations of attacks and better understand how to prevent and mitigate them. While the MITRE ATT&CK framework is a useful reference, it’s not required. Microsoft Sentinel and other Microsoft security services also collaborate with MITRE to provide valuable insights into various threats.

Some organizations use Cyber Kill Chain®, a methodology from Lockheed Martin, to map and understand how an attack or a series of attacks are performed against an IT environment. Cyber Kill Chain organizes threats and attacks by considering fewer tactics and techniques than the MITRE ATT&CK framework. Still, it's effective in helping you to understand threats and how they might be executed. For more information about this methodology, see [Cyber Kill Chain](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html).

## Architecture

:::image type="content" alt-text="Diagram of three categories of services, top techniques of attack, and categories of the Zero Trust model that are threatened by those techniques." source="../media/map-threats-it-environment-architecture.png" lightbox="../media/map-threats-it-environment-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components.vsdm) of this architecture.*

*©2021 The MITRE Corporation. This work is reproduced and distributed with the permission of The MITRE Corporation.*

For the IT environment of organizations, we specify the components only for Azure and Microsoft 365. Your specific IT environment might include devices, appliances, and technologies from different technology providers.

For the Azure environment, the diagram shows the components that are listed in the following table.

| Label | Documentation |
|---|---|---|
| **VNET** | [What is Azure Virtual Network](https://azure.microsoft.com/services/virtual-network)? |
| **LBS** | [What is Azure Load Balancer](/azure/load-balancer/load-balancer-overview)? |
| **PIPS** | [Public IP addresses](/azure/virtual-network/ip-services/public-ip-addresses) |
| **SERVERS** | [Virtual Machines](https://azure.microsoft.com/services/virtual-machines) |
| **K8S** | [Azure Kubernetes Service](/azure/aks/intro-kubernetes) |
| **VDI** | [What is Azure Virtual Desktop?](/azure/virtual-desktop/overview) |
| **WEB APPS** | [App Service overview](/azure/app-service/overview) |
| **AZURE STORAGE** | [Introduction to Azure Storage](/azure/storage/common/storage-introduction) |
| **DB** | [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview) |
| **Microsoft Entra ID** | [What is Microsoft Entra ID](/entra/fundamentals/whatis)? |

The diagram represents Microsoft 365 through the components listed in the following table.

| Label | Description | Documentation |
|---|---|---|
| `OFFICE 365` | Microsoft 365 services (formerly Office 365). The applications that Microsoft 365 makes available depends on the type of license. | [Microsoft 365 - Subscription for Office Apps](https://www.microsoft.com/microsoft-365) |
| `Microsoft Entra ID` | Microsoft Entra ID, the same one utilized by Azure. Many companies use the same Microsoft Entra service for Azure and Microsoft 365. | [What is Microsoft Entra ID?](/entra/fundamentals/whatis) |

### Workflow

To help you understand which part of your IT environment those threats are likely to attack, the architecture diagram in this article is based on a typical IT environment for an organization that has on-premises systems, a Microsoft 365 subscription, and an Azure subscription. The resources in each of these layers are services that are common to many companies. They're classified in the diagram according to the pillars of Microsoft Zero Trust: network, infrastructure, endpoint, application, data, and identity. For more information about Zero Trust, see [Embrace proactive security with Zero Trust](https://www.microsoft.com/security/business/zero-trust).

The architecture diagram includes the following layers:

1. **On-premises**

    The diagram includes some essential services such as servers (VMs), network appliances, and Domain Name System (DNS). It includes common applications that are found in most IT environments and run on virtual machines (VMs) or physical servers. It also includes various types of databases, both SQL and non-SQL. Organizations usually have a file server that shares files throughout the company. Lastly, the Active Directory Domain Service, a widespread infrastructure component, handles user credentials. The diagram includes all these components in the on-premises environment.

2. **Office 365 environment**

    This example environment contains traditional office applications, such as Word, Excel, PowerPoint, Outlook, and OneNote. Depending on the type of license, it might also include other applications, such as OneDrive, Exchange, Sharepoint, and Teams. In the diagram, these are represented by an icon for Microsoft 365 (formerly Office 365) apps and an icon for Microsoft Entra ID. Users must be authenticated to obtain access to Microsoft 365 applications, and Microsoft Entra ID acts as the identity provider. Microsoft 365 authenticates users against the same type of Microsoft Entra ID that Azure uses. In most organizations, the [Microsoft Entra ID *tenant*](/microsoft-365/education/deploy/intro-azure-active-directory) is the same for both Azure and Microsoft 365.

3. **Azure environment**

    This layer represents Azure public cloud services, including VMs, virtual networks, platforms as services, web applications, databases, storage, identity services, and more. For more information about Azure, see [Azure documentation](/azure).

4. **MITRE ATT&CK tactics and techniques**

    This diagram shows the top 16 threats, according to the tactics and techniques as published by The MITRE Corporation. In red lines, you can see an example of a blended attack, which means that a malicious actor might coordinate multiple attacks simultaneously.

### How to use the MITRE ATT&CK framework

You can start with a simple search for the name of the threat or of the attack code on the main web page, [MITRE ATT&CK®](https://attack.mitre.org).

You can also browse threats on the tactics or techniques pages:

- [Enterprise tactics](https://attack.mitre.org/tactics/enterprise)
- [Enterprise techniques](https://attack.mitre.org/techniques/enterprise)

You can still use [MITRE ATT&CK® Navigator](https://mitre-attack.github.io/attack-navigator), an intuitive tool provided by MITRE that helps you discover tactics, techniques, and details about threats.

### Components

The example architecture in this article uses the following Azure components:

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based identity and access management service that enables secure access to internal and external resources. In this architecture, it authenticates users for both Azure and Microsoft 365 services. It serves as the central identity provider across the environment.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service in Azure that enables secure communication between Azure resources, the internet, and on-premises networks. In this architecture, it provides isolated and scalable network infrastructure for hosting workloads and enforcing traffic control.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a high-performance layer-4 load balancing service for Transmission Control Protocol (TCP) and User Datagram Protocol (UDP) traffic. In this architecture, it ensures high availability and scalability by distributing inbound and outbound traffic across VMs and services.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure as a service (IaaS) offering that provides flexible, on-demand compute resources. In this architecture, VMs host applications and services that are part of the organization's IT environment and are subject to threat mapping.

- [Azure Kubernetes service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service for deploying and managing containerized applications. In this architecture, it runs containerized applications and supports enterprise-grade security and governance as part of the threat surface.

- [Virtual Desktop](/azure/virtual-desktop/overview) is a desktop and app virtualization service that runs on the cloud to provide desktops for remote users. In this architecture, it provides secure access for remote users and is included in the threat map as a potential attack vector.

- The [Web Apps feature of Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) hosts web applications, REST APIs, and mobile back ends. You can develop in your chosen language. Applications run and scale with ease on both Windows and Linux-based environments. In this architecture, Web Apps hosts HTTP-based applications that are protected via integrated security features such as Transport Layer Security (TLS) and private endpoints.

- [Azure Storage](/azure/storage/common/storage-introduction) is a scalable and secure storage service for various data objects in the cloud, including object, blob, file, disk, queue, and table storage. Azure Storage encrypts all data written to a Storage account. It provides fine-grained control over access to your data. In this architecture, it stores application and system data and is included in the threat map because of its role in data protection and access control.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a managed relational database engine that automates patching, backups, and monitoring. In this architecture, it stores structured data and supports built-in security and compliance features to mitigate threats.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-oliveira-69443523/) | Senior Azure Security Engineer

Other contributors:

- [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
- [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager

## Next steps

This document refers to some services, technologies, and terminologies. You can find more information about them in the following resources:

- [MITRE ATT&CK®](https://attack.mitre.org)
- [ATT&CK® Navigator)](https://mitre-attack.github.io/attack-navigator)
- [The Cyber Kill Chain®](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html)
- [Embrace proactive security with Zero Trust](https://www.microsoft.com/security/business/zero-trust)
- [Blended threat](https://en.wikipedia.org/wiki/Blended_threat) on Wikipedia
- [How cyberattacks are changing according to new Microsoft Digital Defense Report](https://www.microsoft.com/security/blog/2021/10/11/how-cyberattacks-are-changing-according-to-new-microsoft-digital-defense-report) from Microsoft Security Blog

## Related resources

For more information about this reference architecture, see the other articles in this series:

- Part 2: [Build the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)
- Part 3: [Build the second layer of defense with Microsoft Defender XDR Security services](./microsoft-365-defender-build-second-layer-defense.yml)
- Part 4: [Integrate Azure and Microsoft Defender XDR security services](./microsoft-365-defender-security-integrate-azure.yml)
