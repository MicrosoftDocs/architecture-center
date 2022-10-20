[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article explains how to diagram the essential IT environment of your organization and develop a threat map. These diagrams can help you to plan and build your defensive layer of security. Understanding your IT environment and how it's architected is essential to defining the security services that the environment requires for necessary levels of protection.

Computer systems contain information that is valuable to the organizations that produce it—and to malicious actors. A malicious actor can be an individual or a group of people who perform malicious acts against a person or organization. Their efforts can cause harm to the computers, devices, systems, and networks of companies. Their goals are to compromise or steal valuable information by using threats like malware or brute force attacks.

In this article, we look at a way to map the threats against your IT environment so that you can plan how to use Microsoft security services to implement your security strategy. This is the second article in a series of five articles that are introduced in [Use Azure monitoring to integrate security components](../../guide/security/azure-monitor-integrate-security-components.yml).

The good news is that you don't need to create a threat map from scratch. The MITRE ATT&CK matrix is a great solution to help you develop a threat map. MITRE ATT&CK is a global knowledge database that maps threats that are based on the tactics and techniques that are observed in the real world. The MITRE Corporation catalogs every threat available and discovers many details of how those threats work and how you can defend against them. It's a public service that you can access online at [MITRE ATT&CK®](https://attack.mitre.org).

This article uses a subset of those threats to present an example of how you could map threats against your IT environment.

## Potential use cases

Some threats are widespread regardless of the industry segment, such as ransomware, DDoS attacks, cross-site scripting, SQL injection, and so on. However, some organizations have concerns about specific types of threats that are particular to their industry or that were the basis of cyber-attacks that they've experienced. The diagram presented in this article can help you map such threats for your organization according to the area that malicious actors are likely to attack. Developing a threat map helps you to plan the layers of defense that are necessary to have a more secure environment.

You can use this diagram with different combinations of attacks to understand how to avoid and mitigate those attacks. You don't necessarily need to use the MITRE ATT&CK framework. The framework is only an example. Microsoft Sentinel, and other Microsoft security services, have worked with MITRE to provide insightful information regarding threats.

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
| **AZURE AD** | [What is Azure Active Directory](/azure/active-directory/fundamentals/active-directory-whatis)? |

The diagram represents Microsoft 365 through the components listed in the following table.

| Label | Description | Documentation |
|---|---|---|
| **OFFICE 365** | Microsoft 365 services (formerly Office 365). The applications that Microsoft 365 makes available depends on the type of license. | [Microsoft 365 - Subscription for Office Apps](https://www.microsoft.com/microsoft-365) |
| **AZURE AD** | Azure AD, the same one utilized by Azure. Many companies use the same Azure AD service for Azure and Microsoft 365. | [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis) |

### Workflow

To help you understand which part of your IT environment those threats are likely to attack, the architecture diagram in this article is based on a typical IT environment for an organization that has on-premises systems, a Microsoft 365 subscription, and an Azure subscription. The resources in each of these layers are services that are common to many companies. They're classified in the diagram according to the pillars of Microsoft Zero Trust: network, infrastructure, endpoint, application, data, and identity. For more information about Zero Trust, see [Embrace proactive security with Zero Trust](https://www.microsoft.com/security/business/zero-trust).

The architecture diagram includes the following layers:

1. **On-premises**

    The diagram includes some essential services such as servers (VMs), network appliances, and DNS. It includes common applications that are found in most IT environments and run on virtual machines or physical servers. It also includes various types of databases, both SQL and non-SQL. Organizations usually have a file server that shares files throughout the company. Lastly, the Active Directory Domain Service, a widespread infrastructure component, handles user credentials. The diagram includes all these components in the on-premises environment.

2. **Office 365 environment**

    This example environment contains traditional office applications, such as Word, Excel, PowerPoint, Outlook, and OneNote. Depending on the type of license, it might also include other applications, such as OneDrive, Exchange, Sharepoint, and Teams. In the diagram, these are represented by an icon for Microsoft 365 (formerly Office 365) apps and an icon for Azure Active Directory (Azure AD). Users must be authenticated to obtain access to Microsoft 365 applications, and Azure AD acts as the identity provider. Microsoft 365 authenticates users against the same type of Azure AD that Azure uses. In most organizations, the [Azure AD *tenant*](/microsoft-365/education/deploy/intro-azure-active-directory) is the same for both Azure and Microsoft 365.

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

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-r-oliveira-69443523) | Senior Customer Engineer

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
- Part 4: [Build the second layer of defense with Microsoft 365 Defender Security services](./microsoft-365-defender-build-second-layer-defense.yml)
- Part 5: [Integrate Azure and Microsoft 365 Defender security services](./microsoft-365-defender-security-integrate-azure.yml)
