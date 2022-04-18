This is the second document from a series of 5. If you would like to review the first document with the introduction about this series, you may check this \<LINK\>. This document intends to explain how to diagram an essential business IT environment and a threat map that will help you to plan and build your security defense layer with Microsoft cloud security services.

Understanding your IT environment and how it is architected is essential to define the security services required to get the right level of protection you need. Information contained in computer systems is of great value to the companies that produce it, but it can also be valuable to malicious actors.

Malicious actors (sometimes referred to as "hackers") can be an individual or a group of people that performs malicious acts against a person or organization by causing harm to the cyber realm of computers, devices, systems, and network of companies to compromise or steal valuable information using threats like malware or brute force attacks.

In this document, we will see a way to map those threats against your IT environment so that you may plan for your security strategy with Microsoft security services. The good news is that you don't need to start that threat map from scratch. Mitre Att&ck matrix is a great solution to help you on that matter.

Mitre Att&ck is a global knowledge database that maps threats based on the tactics and techniques observed in the real world. Mitre catalogs every threat available and discovers many details of how those threats work and how you may defend against them. It is a public service that you may access through this link [MITRE ATT&CK®](https://attack.mitre.org/).

This document uses a small subset of those threats (the bottom part of the diagram) to present you with an example of how you could map threats against your business IT environment.

:::image type="content" alt-text="Image alt text." source="images/customer-it-environment-threats-architecture.png" lightbox="images/customer-it-environment-threats-architecture.png":::

## Potential use cases

Some threats are widespread regardless of the industry segment, such as Ransomware, DDOS attacks, Cross-site scripting, SQL injection, etc. However, specific companies may have particular concerns about some types of threats, based on their type of industry or based on the experience they have already had in the past with cyber-attack. The diagram presented in this article may help you map those threats according to the area that malicious actors intend to attack and allow your organization to plan the layers of defense necessary to build a more secure environment.

You may use this diagram with different combinations of attacks to understand how to avoid and mitigate those attacks. You don't necessarily have to use the Mitre Att&ck framework. This is only an example as Microsoft Sentinel and other Microsoft security services have worked with Mitre to provide insightful information regarding threats.

Another option used by some companies to map and understand how an attack or a series of attacks are performed against a business IT environment is through cyber kill chain ([Cyber Kill Chain® \| Lockheed Martin](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html)) methodology, which organizes threats and attacks by considering fewer tactics and techniques than Mitre. Still, it is as effective as Mitre to help you understand an attack or series of attacks and how the malicious actors against your environment may execute them.

To understand which piece of your environment those threats usually attack, it was considered on this diagram a typical Business IT environment with an On-premises, an Office 365 subscription, and an Azure subscription layer. The resources in each layer are very common services that you may find in many companies. They are classified according to the pillars of Microsoft Zero Trust: Network, Infrastructure, Endpoint, Application, Data, and Identity. See more about Microsoft Zero Trust at this link:

[Zero Trust Model - Modern Security Architecture \| Microsoft Security](https://www.microsoft.com/en-us/security/business/zero-trust)

Here is the business IT environment we consider as an example and used in this series of documents.

1.  **on-premises:** it was considered in the diagram some essential services such as Servers (VMs), Network appliances, and services such as DNS. It is also ubiquitous that most IT environments contain Applications running in virtual machines or physical servers, Databases of different technologies provided by other companies, like MS SQL Server, Oracle DB, and various flavors of non-SQL Databases. Companies usually have a File server that shares files throughout the company. Lastly, a widespread infrastructure component, the ADDS (Active Directory Domain Service), handles user's credentials. All those components together will represent in this diagram the on-premises environment.

2.  **Office 365 environment:** this environment contains traditional office applications including Word, Excel, PowerPoint, Outlook, OneNote, and depending on the type of license, may also include other apps such as OneDrive, Exchange, Sharepoint, and Teams. It is represented on this diagram with a unique icon plus Azure AD, a cloud identity provider required to run Office 365 to authenticate users that access the Office 365 applications. For those starting with Azure, it is interesting mentioning that Office 365 shows users against the same type of Azure AD that Azure uses. In most companies, the Azure AD, also called Azure AD Tenant, is the same for both Azure and Office 365.

3.  **Azure environment:** this is the public cloud service that contains services very similar to an on-premises, like Servers (VMs), Workstations (VDI), Network components, services called PaaS like Web Applications, Databases and Storage service, and the Azure AD. This Azure AD will provide credentials for users to create Azure resources.

4.  **Mitre Att&ck tactics and techniques:** This diagram compiles the top 16 threats described according to its tactics and techniques published by Mitre. In red lines, you may see an example of a blended attack, which means that a malicious actor may coordinate multiple attacks simultaneously.

## Components of the diagrams

For the Business IT environment, we will specify the components only for the Azure and Office 365 environment as on-premises may run various devices, appliances, and technologies from different technology providers.

For the **Azure environment**, the diagram shows:

- Azure Virtual Network, represented as "VNET."

  [Azure Virtual Network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)

- Load Balancer, represented as "LBS."

  [What is Azure Load Balancer? - Azure Load Balancer](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview)

- Public IPs, represented as "PIPS."

  [Public IP addresses in Azure - Azure Virtual Network](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses)

- Virtual Machines, represented as "Servers."

  [Virtual Machines (VMs) for Linux and Windows \| Microsoft Azure](https://azure.microsoft.com/en-us/services/virtual-machines/)

- Kubernetes services, represented as "k8s."

  [Introduction to Azure Kubernetes Service - Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes)

- Azure Virtual Desktop (AVD), represented as "VDI."

  [What is Azure Virtual Desktop? - Azure](https://docs.microsoft.com/en-us/azure/virtual-desktop/overview)

- Azure App Service with Web App, represented simply as "Web Apps."

  [Overview - Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/overview)

- Azure Storage could be blob (object storage) or file storage represented as "Azure Storage."

  [Introduction to Azure Storage - Cloud storage on Azure](https://docs.microsoft.com/en-us/azure/storage/common/storage-introduction)

- Azure SQL DB, represented as "DB."

  [What is the Azure SQL Database service? - Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview)

- Azure Active Directory, or simply Azure AD, represented as "Azure AD."

  [What is Azure Active Directory?](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis)

For **Office 365**, the diagram represents the service through two different components:

- Office 365 services, which applications available will depend on the type of license being used

  [Microsoft 365 - Subscription for Office Apps \| Microsoft 365](https://www.microsoft.com/en-us/microsoft-365)

- Azure Active Directory, the same one utilized by Azure. It is important to note that many companies utilize the same Azure Active Directory for Azure and Office 365.

  [What is Azure Active Directory?](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis)

## How to use Mitre Att&ck framework

- You may start with a simple search for the name of the threat of the attack code on this main page:

  [MITRE ATT&CK®](https://attack.mitre.org/)

- You can also browse threats through tactics or techniques pages:

  - For tactics: [Tactics - Enterprise \| MITRE ATT&CK®](https://attack.mitre.org/tactics/enterprise/)

  - For techniques: [Techniques - Enterprise \| MITRE ATT&CK®](https://attack.mitre.org/techniques/enterprise/)

- You can still use Mitre Att&ck navigator, [ATT&CK® Navigator (mitre-attack.github.io)](https://mitre-attack.github.io/attack-navigator/), an intuitive tool provided by Mitre that facilitates your navigation through tactics, techniques, and all details about threats.

## Next steps

To get all details regarding this Architecture reference, you may review those other documents part of this series.

-   Part 1 - Microsoft cloud security integration map against Threats \<link\>

-   Part 3 - Building the first layer of defense with Azure Security services \<link\>

-   Part 4 - Building the second layer of defense with Microsoft 365 Defender services \<link\>

-   Part 5 - Integration between Azure and Microsoft 365 Defender services \<link\>

## Related resources

This document refers to some services, technologies, and terminologies. You may find more information related to it in the links below.

- Mitre att&ck: [MITRE ATT&CK®](https://attack.mitre.org/)

- Mitre att&ck navigator: [ATT&CK® Navigator (mitre-attack.github.io)](https://mitre-attack.github.io/attack-navigator/)

- Microsoft Sentinel and Mitre workbook:

  [Public Preview: The MITRE ATT&CK Framework Blade in Microsoft Sentinel -- Azure Cloud & AI Domain Blog (azurecloudai. blog)](https://azurecloudai.blog/2022/02/25/public-preview-the-mitre-attck-framework-blade-in-microsoft-sentinel/)

- Cyber kill chain: [Cyber Kill Chain® \| Lockheed Martin](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html)

- Microsoft Zero Trust: [Zero Trust Model - Modern Security     Architecture \| Microsoft     Security](https://www.microsoft.com/en-us/security/business/zero-trust)

- Threat blended attacks: [Blended threat -     Wikipedia](https://en.wikipedia.org/wiki/Blended_threat)

- Most common attacks:

  [How cyberattacks are changing according to new Microsoft Digital Defense Report - Microsoft Security Blog](https://www.microsoft.com/security/blog/2021/10/11/how-cyberattacks-are-changing-according-to-new-microsoft-digital-defense-report/)
