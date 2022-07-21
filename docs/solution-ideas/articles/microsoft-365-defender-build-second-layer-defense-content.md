[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

It's common for organizations to use a hybrid environment, with resources running both on Azure and on-premises. Most Azure resources, such as virtual machines (VMs), Azure applications, and Azure Active Directory (Azure AD), can be protected by security services that run on Azure. 

Organizations often also subscribe to Microsoft 365 to provide users with applications like Word, Excel, PowerPoint, and Exchange online. Microsoft 365 also offers security services that you can use to build an additional layer of security for some of the most used Azure resources.

To consider using security services from Microsoft 365, it's helpful to know some terminology and understand the structure of Microsoft 365 services. This fourth article in a series of five can help with that. This article builds on topics that are covered in the previous articles, particularly:

- [Map threats to your IT environment](./map-threats-it-environment.yml)
- [Build the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)

Microsoft 365 and Office 365 are cloud-based services that are designed to help you meet your organization's needs for robust security, reliability, and user productivity. Microsoft 365 includes services like Power Automate, Forms, Stream, Sway, and Office 365. Office 365 includes the well-known suite of productivity applications. For more information about subscription options for these two services, see [Microsoft 365 and Office 365 plan options](/office365/servicedescriptions/office-365-platform-service-description/office-365-plan-options).

Depending on the license that you acquire for Microsoft 365, you can also get the security services for Microsoft 365. These security services are called Microsoft 365 Defender, which provides multiple services:

-   Microsoft Defender for Endpoint
-   Microsoft Defender for Identity
-   Microsoft Defender for Office 365
-   Microsoft Defender for Cloud Apps

The following diagram illustrates the relationship of solutions and main services that Microsoft 365 offers, though not all services are listed.

:::image type="content" alt-text="Diagram of services and products that are part of Microsoft 365." source="../media/microsoft-365-defender-build-second-layer-defense-services-diagram.png":::

## Potential use case

People are sometimes confused about Microsoft 365 security services and their role in IT cybersecurity. The main causes are names that are similar to each other, including some security services that run on Azure, such as Microsoft Defender for Cloud (formerly known as Azure Security Center) and Defender for Cloud Apps (formerly known as Microsoft Cloud Application Security).

But the confusion isn't only about terminology. Some services deliver similar protection but for different resources, such as Defender for Identity and Azure Identity Protection. Both services offer protection for identity services, but Defender for Identity protects identity on-premises (through Active Directory Domain Services, based on Kerberos authentication) while Azure Identity Protection protects identity in the cloud (through Azure AD, based on OAuth authentication).

These examples show that if you understand how Microsoft 365 security services work and the differences compared to Azure security services, you're able to plan your strategy for security in the Microsoft cloud in an effective way and still provide a great security posture for your IT environment. That is the purpose of this article.

The following diagram illustrates a real use case in which you might consider using Microsoft 365 Defender security services. The diagram shows the resources that need to be protected. The services that run in the environment are shown on top. Some potential threats are shown at the bottom. Microsoft 365 Defender services are in the middle, defending the organization's resources from potential threats.

:::image type="content" alt-text="Diagram that shows threats, their attack order, the targeted resources, and the services of Microsoft 365 Defender that can provide protection." source="../media/microsoft-365-defender-build-second-layer-defense-attack-order.png" lightbox="../media/microsoft-365-defender-build-second-layer-defense-attack-order.png":::

## Architecture

The following diagram shows a layer, labeled as **DEFENDER**, that represents the Microsoft 365 Defender security services. Adding these services to your IT environment helps you to build better defense for your environment. The services in the Defender layer can work with Azure security services.

:::image type="content" alt-text="Diagram of services, threats, and the security services that you can configure to provide protection to the resources in your I T environment." source="../media/microsoft-365-defender-build-second-layer-defense-architecture.png" lightbox="../media/microsoft-365-defender-build-second-layer-defense-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components.vsdm) of this architecture.*

*©2021 The MITRE Corporation. This work is reproduced and distributed with the permission of The MITRE Corporation.*

### Workflow

1.  **Microsoft Defender for Endpoint**

    Defender for Endpoint secures endpoints in your enterprise and is designed to help networks prevent, detect, investigate, and respond to advanced threats. It creates a layer of protection for VMs that run on Azure and on-premises. For more information about what it can protect, see [Microsoft Defender for Endpoint](/microsoft-365/security/defender-endpoint/microsoft-defender-endpoint).

2.  **Microsoft Defender for Cloud Apps**

    Formerly known as Microsoft Cloud Application Security, Defender for Cloud Apps is a cloud access security broker (CASB) that supports multiple deployment modes. Those modes include log collection, API connectors, and reverse proxy. It provides rich visibility, control over data travel, and sophisticated analytics to identify and combat cyberthreats across all your Microsoft and third-party cloud services. It provides protection and risk mitigation for Cloud Apps and even for some apps that run on-premises. It also provides a protection layer for users who access those apps. For more information, see [Microsoft Defender for Cloud Apps overview](/defender-cloud-apps/what-is-defender-for-cloud-apps).

    It's important to not confuse Defender for Cloud Apps with Microsoft Defender for Cloud, which provides recommendations and a score of the security posture of servers, apps, storage accounts, and other resources running in Azure, on-premises, and in other clouds. Defender for Cloud consolidates two previous services, Azure Security Center and Azure Defender. 

3.  **Microsoft Defender for Office 365**

    Defender for Office 365 safeguards your organization against malicious threats that are posed by email messages, links (URLs), and collaboration tools. It provides protection for email and collaboration. Depending on the license, you're able to add post-breach investigation, hunting, and response, as well as automation and simulation (for training). For more information about licensing options, see [Microsoft Defender for Office 365 security overview](/microsoft-365/security/office-365-security/overview?view=o365-worldwide).

4.  **Microsoft Defender for Identity**

    Defender for Identity is a cloud-based security solution that uses your on-premises Active Directory signals to identify, detect, and investigate advanced threats, compromised identities, and malicious insider actions that are directed at your organization. It protects Active Directory Domain Services (AD DS) that run on-premises. Even though this service runs on the cloud, it works to protect identities on-premises. Defender for Identity was formerly named Azure Advanced Threat Protection. For more information, see [What is Microsoft Defender for Identity](/defender-for-identity/what-is)?

    If you need protection for identities that are provided by Azure AD and that runs natively on the cloud, consider Azure AD Identity Protection.

5.  **Microsoft Endpoint Manager**

    Endpoint Manager provides services for cloud services, on-premises services, and for Microsoft Intune, which allows you to control features and settings on Android, Android Enterprise, iOS, iPadOS, macOS, Windows 10, and Windows 11 devices. It integrates with other services, including:
    - Azure AD.
    - Mobile threat defenders.
    - Administrative (ADMX) templates.
    - Win32 apps.
    - Custom line-of-business apps.

    Another service that is now part of Endpoint Manager is Configuration Manager, an on-premises management solution that allows you to manage client and server computers that are on your network, connected directly or via the internet. You can enable cloud functionality to integrate Configuration Manager with Intune, Azure AD, Defender for Endpoint, and other cloud services. Use it to deploy apps, software updates, and operating systems. You can also monitor compliance, query for objects, act on clients in real time, and much more. To learn about all the services that are available, see [Microsoft Endpoint Manager overview](/mem/endpoint-manager-overview).

### Attack order of example threats

The threats named in the diagram follow a common attack order:

1. An attacker sends a phishing email with malware attached to it. 

2. An end user opens the attached malware.

3. The malware installs in the back end without the user noticing. 

4. The installed malware steals some users' credentials.

5. The attacker uses the credentials to gain access to sensitive accounts. 

6. If the credentials provide access to an account that has elevated privilege, the attacker compromises additional systems.

The diagram also shows in the layer labeled as **DEFENDER** which Microsoft 365 Defender services can monitor and mitigate those attacks. This is an example of how Defender provides an additional layer of security that works with Azure security services to offer additional protection of the resources that are shown in the diagram. For more information about how potential attacks threaten your IT environment, see the second article in this series, [Map threats to your IT environment](../../solution-ideas/articles/map-threats-it-environment.yml). For more information about Microsoft 365 Defender, see [Microsoft 365 Defender](/microsoft-365/security/defender/microsoft-365-defender?view=o365-worldwide).

### Access and manage Microsoft 365 Defender Security services

Currently, you might need to use multiple portals to manage Microsoft 365 Defender services. However, Microsoft is working to centralize functionality as much as possible. The following diagram shows which portals are currently available and their relationships with each other.

:::image type="content" alt-text="A diagram that shows the current relationship of portals to services." source="../media/microsoft-365-defender-build-second-layer-defense-portals.png" lightbox="../media/microsoft-365-defender-build-second-layer-defense-portals.png":::

*Security.microsoft.com* is currently the most important portal available because it brings functionalities from Microsoft Defender for Office 365 (1) and from Defender for Endpoint (2). However, as of March 2022, you can still access *protection.office.com* for security functionalities regarding Office 365 (3). For Defender for Endpoint, if you try to access the old portal, *securitycenter.windows.com*, you're redirected to the new portal at *security.microsoft.com* (7).

The primary use of *Portal.cloudappsecurity.com* is to manage (4) Defender for Cloud Apps. It allows you to manage cloud apps and some apps that run on-premises, manage unauthorized apps (shadow IT), and review user signals from Identity Protection. You can also use this portal to manage many signals and features from (5) Identity protection on-premises, which allows you to consolidate many functions from (6) *portal.atp.azure.com* on (4) the portal for Defender for Cloud Apps. However, you can still access (6) *portal.atp.azure.com* if you need it.

Lastly, *endpoint.microsoft.com* provides functionality mainly for Intune and Configuration Manager, but also for other services that are part of Endpoint Manager. Because *security.microsoft.com* and *endpoint.microsoft.com* deliver security protection for endpoints, they have many interactions between them (9) to offer a great security posture for your endpoints.

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

 * [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-r-oliveira-69443523) | Senior Customer Engineer

Other contributors: 

 * [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
 * [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager

## Next steps

- [Defend against threats with Microsoft 365](/learn/paths/m365-security-threat-protection)
- [Detect and respond to cyber attacks with Microsoft 365 Defender](/learn/paths/defender-detect-respond)
- [Get started with Microsoft 365 Defender](/microsoft-365/security/defender/get-started)
- [Implement threat intelligence in Microsoft 365](/learn/paths/implement-microsoft-365-threat-intelligence)
- [Manage security with Microsoft 365](/learn/paths/m365-security-management)
- [Protect against malicious threats with Microsoft Defender for Office 365](/learn/paths/defender-office-365-malicious-threats)
- [Protect on-premises identities with Microsoft Defender for Cloud for Identity](/learn/paths/defender-identity-protect-on-premises)

## Related resources

For more details about this reference architecture, see the other articles in this series:

- Part 1: [Use Azure monitoring to integrate security components](../../guide/security/azure-monitor-integrate-security-components.yml)
- Part 2: [Map threats to your IT environment](./map-threats-it-environment.yml)
- Part 3: [Build the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)
- Part 5: [Integration between Azure and Microsoft 365 Defender security services](./microsoft-365-defender-security-integrate-azure.yml)

