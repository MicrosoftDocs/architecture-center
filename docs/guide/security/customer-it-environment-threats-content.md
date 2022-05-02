This is the second article in a series of five articles, which are introduced in the first article, [Use Azure monitoring to integrate security components](./azure-monitor-integrate-security-components.yml). This article explains how to diagram the essential IT environment of a business and develop a threat map. Having these diagrams helps you to plan and build your defensive layer of security.

Understanding your IT environment and how it is architected is essential to defining the security services that are required to get the level of protection that you need. Information that is contained in computer systems is of great value to the companies that produce it—but it can also be valuable to malicious actors.

A malicious actor, sometimes called a *hacker*, can be an individual or a group of people who perform malicious acts against a person or organization. Their efforts can cause harm to the computers, devices, systems, and networks of companies. Their goals are to compromise or steal valuable information by using threats, like malware, or brute force attacks.

In this article, we look at a way to map those threats against your IT environment so that you can plan your security strategy with Microsoft security services. The good news is that you don't need to create a threat map from scratch. The MITRE ATT&CK matrix is a great solution to help you develop a threat map.

MITRE ATT&CK is a global knowledge database that maps threats that are based on the tactics and techniques that are observed in the real world. The MITRE Corporation catalogs every threat available and discovers many details of how those threats work and how you may defend against them. It is a public service that you can access online at [MITRE ATT&CK®](https://attack.mitre.org/).

This article uses a subset of those threats to present an example of how you could map threats against your business IT environment.


## Potential use cases

Some threats are widespread regardless of the industry segment, such as ransomware, DDoS attacks, cross-site scripting, SQL injection, and so on. However, some organizations have concerns about specific types of threats that are based on their industry or on their experiences with cyber-attacks in the past. The diagram presented in this article may help you map such threats for your organization according to the area that malicious actors are likely to attack. Developing a threat map helps you to plan the layers of defense that are necessary to have a more secure environment.

You can use this diagram with different combinations of attacks to understand how to avoid and mitigate those attacks. You don't necessarily need to use the MITRE ATT&CK framework. The framework is only an example. Microsoft Sentinel, and other Microsoft security services, have worked with MITRE to provide insightful information regarding threats.

Some organizations use Cyber Kill Chain®, a methodology from Lockheed Martin, to map and understand how an attack or a series of attacks are performed against an IT environment. Cyber Kill Chain organizes threats and attacks by considering fewer tactics and techniques than the MITRE ATT&CK framework. Still, it is as effective in helping you to understand threats and how they might be executed. For more information about this methodology, see [Cyber Kill Chain](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html).


## Architecture

:::image type="content" alt-text="Diagram of three categories of services (on-premises, Office 365, and Azure), top techniques of attack, and the resource categories of the Zero Trust model that are threatened by those techniques." source="images/customer-it-environment-threats-architecture.png" lightbox="images/customer-it-environment-threats-architecture.png":::

©2021 The MITRE Corporation. This work is reproduced and distributed with the permission of The MITRE Corporation.

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components.vsdm) of this architecture.*


### Workflow

To help you understand which part of your IT environment those threats are likely to attack, the architecture diagram in this article is based on a typical IT environment for a business that has on-premises systems, an Office 365 subscription, and an Azure subscription. The resources in each of these layers are services that are common in many companies. They are classified in the diagram according to the pillars of Microsoft Zero Trust: network, infrastructure, endpoint, application, data, and identity. For more information about Zero Trust, see [Embrace proactive security with Zero Trust](https://www.microsoft.com/en-us/security/business/zero-trust).

The architecture diagram includes the following layers:

1.  **On-premises**

    The diagram includes some essential services such as servers (VMs), network appliances, and DNS. It also includes common applications, found in most IT environments, that run on virtual machines or physical servers, and various types of databases, both SQL and non-SQL. Organizations usually have a file server that shares files throughout the company. Lastly, the Active Directory Domain Service, a widespread infrastructure component, handles user's credentials. The diagram includes all these components in the on-premises environment.

2.  **Office 365 environment**

    This example environment contains traditional office applications, such as Word, Excel, PowerPoint, Outlook, and OneNote. Depending on the type of license, it might also include other applications, such as OneDrive, Exchange, Sharepoint, and Teams. In the diagram, these are represented by an icon for Office 365 apps and an icon for Azure AD. Users must be authenticated to receive access to Office 365 applications, and Azure AD acts as the identity provider. Office 365 authenticates users against the same type of Azure AD that Azure uses. In most organizations, the [Azure AD *tenant*](/microsoft-365/education/deploy/intro-azure-active-directory) is the same for both Azure and Office 365.

3.  **Azure environment**

    This is the public cloud service that contains services that are very similar to on-premises services, like servers (VMs), workstations (VDI), and network components. It also includes platforms as services (PaaS), such as web applications, databases, and storage, and Azure AD. This Azure AD provides credentials for users to create Azure resources.

4.  **MITRE ATT&CK tactics and techniques** 
 
    This diagram shows the top 16 threats, according to the tactics and techniques as published by The MITRE Corporation. In red lines, you can see an example of a blended attack, which means that a malicious actor might coordinate multiple attacks simultaneously.



### Components

For the business IT environment, we specify the components only for the Azure and Office 365 environment as on-premises may run various devices, appliances, and technologies from different technology providers.

For the Azure environment, the diagram shows the components that are listed in the following table.

| Label | Component | Documentation |
|---|---|---|
| **VNET** | [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) | [What is Azure Virtual Network](https://azure.microsoft.com/en-us/services/virtual-network)? |
| **LBS** | [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer) | [What is Azure Load Balancer](/azure/load-balancer/load-balancer-overview)? |
| **PIPS** | Public IP addresses. | [Public IP addresses](/azure/virtual-network/ip-services/public-ip-addresses) |
| **Servers** | [Virtual machines](https://azure.microsoft.com/services/virtual-machines) | [Virtual Machines](/services/virtual-machines/) |
| **K8S** | [Azure Kubernetes service](https://azure.microsoft.com/services/kubernetes-service) | [Azure Kubernetes Service](/azure/aks/intro-kubernetes) |
| **VDI** | [Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop) | [What is Azure Virtual Desktop?](/azure/virtual-desktop/overview) |
| **Web Apps** | Azure App Service with [Web Apps](https://azure.microsoft.com/services/app-service/web) | [App Service overview](/azure/app-service/overview) |
| **Azure Storage** | [Azure Storage](https://azure.microsoft.com/product-categories/storage), could be a blob or file storage. | [Introduction to Azure Storage](/azure/storage/common/storage-introduction) |
| **DB** | [Azure SQL database](https://azure.microsoft.com/products/azure-sql/database) | [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview) |
| **Azure AD** | [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory). | [What is Azure Active Directory](/azure/active-directory/fundamentals/active-directory-whatis)? |


For Office 365, the diagram represents the service through the components listed in the following table.

| Label | Description | Documentation |
|---|---|---|
| **O365** | Office 365 services. The applications that Office 365 makes available depends on the type of license. | [Microsoft 365 - Subscription for Office Apps](https://www.microsoft.com/en-us/microsoft-365) |
| **Azure** | Azure AD, the same one utilized by Azure. It is important to note that many companies use the same Azure AD for Azure and Office 365. | [What is Azure Active Directory?](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis) |


## How to use the MITRE ATT&CK framework

You may start with a simple search for the name of the threat of the attack code on the main web page, [MITRE ATT&CK®](https://attack.mitre.org/).

You can also browse threats on the tactics or techniques pages:

  - [Enterprise tactics](https://attack.mitre.org/tactics/enterprise/)
  - [Enterprise techniques](https://attack.mitre.org/techniques/enterprise/)

You can still use MITRE ATT&CK navigator, [MITRE ATT&CK® Navigator](https://mitre-attack.github.io/attack-navigator/), an intuitive tool provided by MITRE that facilitates your navigation through tactics, techniques, and all details about threats.


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

 * [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-r-oliveira-69443523) | Senior Customer Engineer

Other contributors: 

 * [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
 * [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager


## Next steps

To get all details regarding this Architecture reference, see the other articles in this series:

- Part 1: [Use Azure monitoring to integrate security components](./azure-monitor-integrate-security-components.yml)
- Part 2: [Map threats to your IT environment](./customer-it-environment-threats.yml)
- Part 4: [Build the second layer of defense with Microsoft 365 Defender Security services](./microsoft-365-defender-build-second-layer-defense.yml)
- Part 5: [Integration between Azure and Microsoft 365 Defender security services](./microsoft-365-defender-security-integrate-azure.yml)

## Related resources

This document refers to some services, technologies, and terminologies. You may find more information related to it in the links below.

- [MITRE ATT&CK®](https://attack.mitre.org/)
- [ATT&CK® Navigator)](https://mitre-attack.github.io/attack-navigator/)
- [Public Preview: The MITRE ATT&CK Framework Blade in Microsoft Sentinel](https://azurecloudai.blog/2022/02/25/public-preview-the-mitre-attck-framework-blade-in-microsoft-sentinel/), a post from the Azure Cloud & AI Domain Blog
- [The Cyber Kill Chain®](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html)
- [Embrace proactive security with Zero Trust](https://www.microsoft.com/security/business/zero-trust)
- [Blended threat](https://en.wikipedia.org/wiki/Blended_threat) on Wikipedia
- [How cyberattacks are changing according to new Microsoft Digital Defense Report](https://www.microsoft.com/security/blog/2021/10/11/how-cyberattacks-are-changing-according-to-new-microsoft-digital-defense-report/) from Microsoft Security Blog
