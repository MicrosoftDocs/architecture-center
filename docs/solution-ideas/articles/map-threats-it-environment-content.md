[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article outlines how to diagram your organization's essential IT environment and create a threat map. These diagrams are valuable tools for planning and building a robust defensive security layer. Gaining a clear understanding of your IT environment and its architecture is crucial for determining the security services needed to achieve adequate protection levels.

Computer systems hold information that is valuable not only to the organizations that create it but also to malicious actors. These actors can be individuals or groups that engage in harmful activities against people or organizations. Their actions can damage computers, devices, systems, and networks, aiming to compromise or steal sensitive information through threats like malware or brute force attacks.

In this article, we look at a way to map the threats against your IT environment so that you can plan how to use Microsoft security services to implement your security strategy. This is the second article in a series of five articles that are introduced in [Use Azure monitoring to integrate security components](../../guide/security/azure-monitor-integrate-security-components.yml).

The good news is that you don't have to build a threat map from scratch. The MITRE ATT&CK matrix offers an excellent solution to help you create one. MITRE ATT&CK is a global knowledge base that maps real-world threats using tactics and techniques observed in practice. The MITRE Corporation documents every known threat and provides detailed insights into how these threats operate and how you can defend against them. It's a public service that you can access online at [MITRE ATT&CK®](https://attack.mitre.org).

This article uses a subset of those threats to present an example of how you could map threats against your IT environment.

## Potential use cases

Some threats are common across all industries, such as ransomware, DDoS attacks, cross-site scripting, and SQL injection. However, some organizations may face specific threats unique to their industry or based on past cyberattacks they've encountered. The diagram in this article can help you map threats that are relevant to your organization, focusing on the areas most likely to be targeted by malicious actors. Creating a threat map enables you to design the necessary layers of defense for a more secure environment.

This diagram can be adapted with various combinations of attacks to help you understand how to prevent and mitigate them. While the MITRE ATT&CK framework is a useful example, it’s not mandatory. Microsoft Sentinel and other Microsoft security services also provide valuable insights into threats, often leveraging information from the MITRE framework.

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
| **Microsoft Entra ID** | [What is Microsoft Entra ID](/azure/active-directory/fundamentals/active-directory-whatis)? |

The diagram represents Microsoft 365 through the components listed in the following table.

| Label | Description | Documentation |
|---|---|---|
| `OFFICE 365` | Microsoft 365 services (formerly Office 365). The applications that Microsoft 365 makes available depends on the type of license. | [Microsoft 365 - Subscription for Office Apps](https://www.microsoft.com/microsoft-365) |
| `Microsoft Entra ID` | Microsoft Entra ID, the same one utilized by Azure. Many companies use the same Microsoft Entra service for Azure and Microsoft 365. | [What is Microsoft Entra ID?](/azure/active-directory/fundamentals/active-directory-whatis) |

### Workflow

To help you identify which areas of your IT environment are most likely to be targeted by threats, the architecture diagram in this article is based on a typical IT setup for an organization with on-premises systems, a Microsoft 365 subscription, and an Azure subscription. The resources in each of these layers represent services commonly used by many companies. They are categorized in the diagram according to the pillars of Microsoft's Zero Trust framework: network, infrastructure, endpoint, application, data, and identity.
For more information about Zero Trust, see [Embrace proactive security with Zero Trust](https://www.microsoft.com/security/business/zero-trust).

The architecture diagram includes the following layers:

1. **On-premises**

    The diagram includes some essential services such as servers (VMs), network appliances, and DNS. It includes common applications that are found in most IT environments and run on virtual machines or physical servers. It also includes various types of databases, both SQL and non-SQL. Organizations usually have a file server that shares files throughout the company. Lastly, the Active Directory Domain Service, a widespread infrastructure component, handles user credentials. The diagram includes all these components in the on-premises environment.

2. **Office 365 environment**

    This example environment contains traditional office applications, such as Word, Excel, PowerPoint, Outlook, and OneNote. Depending on the type of license, it might also include other applications, such as OneDrive, Exchange, Sharepoint, and Teams. In the diagram, these are represented by an icon for Microsoft 365 (formerly Office 365) apps and an icon for Microsoft Entra ID. Users must be authenticated to obtain access to Microsoft 365 applications, and Microsoft Entra ID acts as the identity provider. Microsoft 365 authenticates users against the same type of Microsoft Entra ID that Azure uses. In most organizations, the [Microsoft Entra ID *tenant*](/microsoft-365/education/deploy/intro-azure-active-directory) is the same for both Azure and Microsoft 365.

3. **Azure environment**

    This layer represents Azure public cloud services, including virtual machines, virtual networks, platforms as services, web applications, databases, storage, identity services, and more. For more information about Azure, see [Azure documentation](/azure).

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

- [Microsoft Entra ID](https://azure.microsoft.com/services/active-directory) is a cloud-based identity and access management service. Microsoft Entra ID helps your users to access external resources, such as Microsoft 365, the Azure portal, and thousands of other SaaS applications. It also helps them access internal resources, like apps on your corporate intranet network.

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for your private network in Azure. Virtual Network enables many types of Azure resources to securely communicate with each other, the internet, and on-premises networks. Virtual Network provides a virtual network that benefits from Azure's infrastructure, such as scale, availability, and isolation.

- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer) is a high-performance, low-latency Layer 4 load-balancing service (inbound and outbound) for all UDP and TCP protocols. It's built to handle millions of requests per second while ensuring that your solution is highly available. Azure Load Balancer is zone-redundant, ensuring high availability across Availability Zones.

- [Virtual machines](https://azure.microsoft.com/services/virtual-machines) is one of several types of on-demand, scalable computing resources that Azure offers. An Azure virtual machine (VM) gives you the flexibility of virtualization without having to buy and maintain the physical hardware that runs it.

- [Azure Kubernetes service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. AKS provides serverless Kubernetes, continuous integration/continuous delivery (CI/CD), and enterprise-grade security and governance.

- [Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop) is a desktop and app virtualization service that runs on the cloud to provide desktops for remote users.

- [Web Apps](/azure/well-architected/service-guides/app-service-web-apps) is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. You can develop in your favorite language, and applications run and scale with ease on both Windows and Linux-based environments.

- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is highly available, massively scalable, durable, and secure storage for various data objects in the cloud, including object, blob, file, disk, queue, and table storage. All data written to an Azure storage account is encrypted by the service. Azure Storage provides you with fine-grained control over who has access to your data.

- [Azure SQL database](https://azure.microsoft.com/products/azure-sql/database) is a fully managed PaaS database engine that handles most of the database management functions such as upgrading, patching, backups, and monitoring. It provides these functions without user involvement. SQL Database provides a range of built-in security and compliance features to help your application meet security and compliance requirements.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-oliveira-69443523/) | Senior Customer Engineer

Other contributors:

- [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
- [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager

## Next steps

This document refers to some services, technologies, and terminologies. You can find more information about them in the following resources:

- [MITRE ATT&CK®](https://attack.mitre.org)
- [ATT&CK® Navigator)](https://mitre-attack.github.io/attack-navigator)
- [Public Preview: The MITRE ATT&CK Framework Blade in Microsoft Sentinel](https://azurecloudai.blog/2022/02/25/public-preview-the-mitre-attck-framework-blade-in-microsoft-sentinel), a post from the Azure Cloud & AI Domain Blog
- [The Cyber Kill Chain®](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html)
- [Embrace proactive security with Zero Trust](https://www.microsoft.com/security/business/zero-trust)
- [Blended threat](https://en.wikipedia.org/wiki/Blended_threat) on Wikipedia
- [How cyberattacks are changing according to new Microsoft Digital Defense Report](https://www.microsoft.com/security/blog/2021/10/11/how-cyberattacks-are-changing-according-to-new-microsoft-digital-defense-report) from Microsoft Security Blog

## Related resources

For more details about this reference architecture, see the other articles in this series:

- Part 1: [Use Azure monitoring to integrate security components](../../guide/security/azure-monitor-integrate-security-components.yml)
- Part 3: [Build the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)
- Part 4: [Build the second layer of defense with Microsoft Defender XDR Security services](./microsoft-365-defender-build-second-layer-defense.yml)
- Part 5: [Integrate Azure and Microsoft Defender XDR security services](./microsoft-365-defender-security-integrate-azure.yml)
