This is the second document from a series of 5. If you would like to review the first document with the introduction about this series, you may check this \<LINK\>. This document intends to explain how to diagram an essential business IT environment and a threat map that will help you to plan and build your security defense layer with Microsoft cloud security services.

Understanding your IT environment and how it is architected is essential to define the security services required to get the right level of protection you need. Information contained in computer systems is of great value to the companies that produce it, but it can also be valuable to malicious actors.

Malicious actors (sometimes referred to as "hackers") can be an individual or a group of people that performs malicious acts against a person or organization by causing harm to the cyber realm of computers, devices, systems, and network of companies to compromise or steal valuable information using threats like malware or brute force attacks.

In this document, we will see a way to map those threats against your IT environment so that you may plan for your security strategy with Microsoft security services. The good news is that you don't need to start that threat map from scratch. MITRE ATT&CK matrix is a great solution to help you on that matter.

MITRE ATT&CK is a global knowledge database that maps threats based on the tactics and techniques observed in the real world. MITRE catalogs every threat available and discovers many details of how those threats work and how you may defend against them. It is a public service that you may access through this link [MITRE ATT&CK®](https://attack.mitre.org/).

This document uses a small subset of those threats (the bottom part of the diagram) to present you with an example of how you could map threats against your business IT environment.

:::image type="content" alt-text="Image alt text." source="images/customer-it-environment-threats-architecture.png" lightbox="images/customer-it-environment-threats-architecture.png":::

## Potential use cases

Some threats are widespread regardless of the industry segment, such as Ransomware, DDOS attacks, Cross-site scripting, SQL injection, etc. However, specific companies may have particular concerns about some types of threats, based on their type of industry or based on the experience they have already had in the past with cyber-attack. The diagram presented in this article may help you map those threats according to the area that malicious actors intend to attack and allow your organization to plan the layers of defense necessary to build a more secure environment.

You may use this diagram with different combinations of attacks to understand how to avoid and mitigate those attacks. You don't necessarily have to use the MITRE ATT&CK framework. This is only an example as Microsoft Sentinel and other Microsoft security services have worked with MITRE to provide insightful information regarding threats.

Another option used by some companies to map and understand how an attack or a series of attacks are performed against a business IT environment is through cyber kill chain ([Cyber Kill Chain® \| Lockheed Martin](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html)) methodology, which organizes threats and attacks by considering fewer tactics and techniques than MITRE. Still, it is as effective as MITRE to help you understand an attack or series of attacks and how the malicious actors against your environment may execute them.

To understand which piece of your environment those threats usually attack, it was considered on this diagram a typical Business IT environment with an On-premises, an Office 365 subscription, and an Azure subscription layer. The resources in each layer are very common services that you may find in many companies. They are classified according to the pillars of Microsoft Zero Trust: Network, Infrastructure, Endpoint, Application, Data, and Identity. See more about Microsoft Zero Trust at this link:

[Zero Trust Model - Modern Security Architecture](https://www.microsoft.com/en-us/security/business/zero-trust)

Here is the business IT environment we consider as an example and used in this series of documents.

1.  **on-premises:** it was considered in the diagram some essential services such as Servers (VMs), Network appliances, and services such as DNS. It is also ubiquitous that most IT environments contain Applications running in virtual machines or physical servers, Databases of different technologies provided by other companies, like MS SQL Server, Oracle DB, and various flavors of non-SQL Databases. Companies usually have a File server that shares files throughout the company. Lastly, a widespread infrastructure component, the ADDS (Active Directory Domain Service), handles user's credentials. All those components together will represent in this diagram the on-premises environment.

2.  **Office 365 environment:** this environment contains traditional office applications including Word, Excel, PowerPoint, Outlook, OneNote, and depending on the type of license, may also include other apps such as OneDrive, Exchange, Sharepoint, and Teams. It is represented on this diagram with a unique icon plus Azure AD, a cloud identity provider required to run Office 365 to authenticate users that access the Office 365 applications. For those starting with Azure, it is interesting mentioning that Office 365 shows users against the same type of Azure AD that Azure uses. In most companies, the Azure AD, also called Azure AD Tenant, is the same for both Azure and Office 365.

3.  **Azure environment:** this is the public cloud service that contains services very similar to an on-premises, like Servers (VMs), Workstations (VDI), Network components, services called PaaS like Web Applications, Databases and Storage service, and the Azure AD. This Azure AD will provide credentials for users to create Azure resources.

4.  **MITRE ATT&CK tactics and techniques:** This diagram compiles the top 16 threats described according to its tactics and techniques published by MITRE. In red lines, you may see an example of a blended attack, which means that a malicious actor may coordinate multiple attacks simultaneously.

## Components of the diagrams

For the Business IT environment, we will specify the components only for the Azure and Office 365 environment as on-premises may run various devices, appliances, and technologies from different technology providers.

For the **Azure environment**, the diagram shows:

- **VNET**. Azure Virtual Network. For more information, see [What is Azure Virtual Network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)?

- **LBS**. Load Balancer. For more information, see [What is Azure Load Balancer](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)?

- **PIPS**. Public IP addresses. For more information, see [Public IP addresses](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses).

- **Servers**. Virtual machines. For more information, see [Virtual Machines](https://azure.microsoft.com/en-us/services/virtual-machines/).

- **K8S**. Kubernetes services. For more information, see [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes).

- **VDI**. Azure Virtual Desktop. For more information, see [What is Azure Virtual Desktop?](https://docs.microsoft.com/en-us/azure/virtual-desktop/overview).

- **Web Apps**. Azure App Service with Web App. For more information, see [App Service overview](https://docs.microsoft.com/en-us/azure/app-service/overview).

- **Azure Storage**. Azure Storage could be blob (object storage) or file storage. For more information, see [Introduction to Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-introduction).

- **DB**. Azure SQL database. For more information, see [What is Azure SQL Database?](https://docs.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview).

- **Azure AD**. Azure Active Directory (Azure AD). For more information, see [What is Azure Active Directory](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis)?

For **Office 365**, the diagram represents the service through two different components:

- **O365**. Office 365 services. The applications that Office 365 makes available depends on the type of license. For more information about licenses and subscriptions, see [Microsoft 365 - Subscription for Office Apps](https://www.microsoft.com/en-us/microsoft-365).

- **Azure**. Azure AD, the same one utilized by Azure. It is important to note that many companies use the same Azure AD for Azure and Office 365. For more information, see [What is Azure Active Directory?](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis).

## How to use MITRE ATT&CK framework

You may start with a simple search for the name of the threat of the attack code on the main web page, [MITRE ATT&CK®](https://attack.mitre.org/).

You can also browse threats on the tactics or techniques pages:

  - [Enterprise tactics](https://attack.mitre.org/tactics/enterprise/)
  - [Enterprise techniques](https://attack.mitre.org/techniques/enterprise/)

You can still use MITRE ATT&CK navigator, [MITRE ATT&CK® Navigator](https://mitre-attack.github.io/attack-navigator/), an intuitive tool provided by MITRE that facilitates your navigation through tactics, techniques, and all details about threats.

## Next steps

To get all details regarding this Architecture reference, see the other articles in this series:

- Part 1: [Use Azure monitoring to integrate security components](./azure-monitor-integrate-security-components.yml)
- Part 2: [Customer IT environment and the threats](./customer-it-environment-threats.yml)
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
