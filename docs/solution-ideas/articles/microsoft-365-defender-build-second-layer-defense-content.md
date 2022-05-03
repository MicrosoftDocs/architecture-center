It is very common for companies to run a hybrid environment, with resources running on Azure and on premises, and with Microsoft 365, which has some applications such as Word, Excel, Powerpoint, and Exchange online. These services are covered in more detail in [Map threats to your IT environment](./map-threats-it-environment.yml), the second article in this series of five articles. 

Most of Azure resources, such as VMs, Azure applications, and Azure AD, may be protected by security services running on Azure as described in details in [Building the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml), the third article in this series.

But you can also consider security services provided by Microsoft 365 to build an additional security layer for some of the most used Azure resources, and still include protection for your on-premises and Office 365 environments.

Let's see how that is possible and so let's start understanding about some terminology and the structure of Microsoft 365 services.

Microsoft 365 and Office 365 are cloud-based services that are designed to help customers meet their organization's needs for robust security, reliability, and user productivity. Microsoft 365 includes services like Power Automate, Forms, Stream, Sway, and Office 365. Office 365 includes several services like Word, Excel, PowerPoint, Outlook, OneNote, SharePoint, Teams, and OneDrive.

Depending on the license that you acquire for Microsoft 365, you may also get the security services for Microsoft 365. (For more information about subscription options, see [Microsoft 365 and Office 365 plan options](/office365/servicedescriptions/office-365-platform-service-description/office-365-plan-options)). These security services are called Microsoft 365 Defender, which provides multiple services:

-   Microsoft Defender for Endpoint
-   Microsoft Defender for Identity
-   Microsoft Defender for Office 365
-   Microsoft Defender for Cloud Apps

This picture may help you understand Microsoft 365 set of solution and some of the main services it contains:

:::image type="content" alt-text="Image alt text." source="../media/microsoft-365-defender-build-second-layer-defense-azure-services.png":::

## Potential use case

Companies and professionals sometimes have confusion about Microsoft 365 security services and their role in IT Cybersecurity. The main reasons are because we have some names that are very similar among them, including some security services that runs on Azure, such as Microsoft Defender for Cloud (formerly known as Azure Security Center) and Microsoft Defender for Cloud Apps (formerly known as Microsoft Cloud Application Security).

But the confusion is not only about terminologies. Some services deliver similar protection but for different resources, such as Microsoft Defender for Identity and Azure Identity Protection. Both services offer protection for your identity services, but Microsoft Defender for Identity protects your identity on premises (Active Directory Domain Services, based on Kerberos authentication) while Azure Identity Protection protects your identity in the cloud (Azure AD, based on OAuth authentication).

These examples show that if you understand how Microsoft 365 security services work and the differences compared to Azure security services, you are able to plan your strategy for security on the Microsoft cloud in an effective way and still provide to your environment a great security posture.

That is the purpose of this article!

In the diagram below we added the Microsoft 365 Defender security services layer to build a better defense in depth for an IT environment. That layer may work along with Azure security services.

:::image type="content" alt-text="Image alt text." source="../media/microsoft-365-defender-build-second-layer-defense-architecture.png" lightbox="../media/microsoft-365-defender-build-second-layer-defense-architecture.png":::

©2021 The MITRE Corporation. This work is reproduced and distributed with the permission of The MITRE Corporation.

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components.vsdm) of this architecture.*

## Components

1.  **Microsoft Defender for endpoint**. Microsoft Defender for Endpoint secures endpoints in your enterprise and is designed to help networks prevent, detect, investigate, and respond to advanced threats. It creates a layer of protection for VMs that run on Azure and on premises. For more information about what it may protect, see [Microsoft Defender for Endpoint](/microsoft-365/security/defender-endpoint/microsoft-defender-endpoint).

2.  **Microsoft Defender for Cloud Apps**. Microsoft Defender for Cloud Apps (formerly known as Microsoft Cloud Application Security or simply MCAS) is a cloud access security broker (CASB) that supports various deployment modes including log collection, API connectors, and reverse proxy. It provides rich visibility, control over data travel, and sophisticated analytics to identify and combat cyberthreats across all your Microsoft and third-party cloud services. In other words, it provides protection and risk mitigation for Cloud Apps and even for some apps that run on premises. It also provides a protection layer for users who access those apps.

    It is very important not confuse Microsoft Defender for Cloud Apps with the Microsoft Defender for Cloud, a solution from Azure (that was formerly known as Azure Security Center) that provides recommendation and a security posture score for servers, apps, storage accounts, and other Azure resources. For more information, see [Microsoft Defender for Cloud Apps overview](/defender-cloud-apps/what-is-defender-for-cloud-apps).

3.  **Microsoft Defender for Office 365**. Microsoft Defender for Office 365 safeguards your organization against malicious threats that are posed by email messages, links (URLs), and collaboration tools. It provides protection for email and collaboration. Depending on the license, you are able to add post-breach investigation, hunting, and response, as well as automation, and simulation (for training). For more information about licensing options, see [Microsoft Defender for Office 365 security overview](/microsoft-365/security/office-365-security/overview?view=o365-worldwide).

4.  **Microsoft Defender for Identity**. Microsoft Defender for Identity *(formerly Azure Advanced Threat Protection, also known as Azure ATP)* is a cloud-based security solution that leverages your on-premises Active Directory signals to identify, detect, and investigate advanced threats, compromised identities, and malicious insider actions directed at your organization. It will protect ADDS (Active Directory Domains Services) running on-premises. Even though this service runs on the cloud, it works to protect Identities on-premises.

    If you need protection for identities provided by Azure AD, that runs natively on the cloud, you will have to consider Azure AD Identity Protection. For more information, see [What is Microsoft Defender for Identity](/defender-for-identity/what-is)?

5.  **Microsoft Endpoint Manager**. Microsoft Endpoint Manager provides services for cloud and on-premises services, including Microsoft Intune, which allows you to control features and settings on Android, Android Enterprise, iOS, iPadOS, macOS, and Windows 10 and 11 devices. It integrates with other services, including Azure Active Directory (Azure AD), mobile threat defenders, ADMX templates, Win32, custom LOB apps, and more.

    Another known service that is now part of Microsoft Endpoint Manager is Configuration Manager, an on-premises management solution that allow you to manage desktops, servers, and laptops that are on your network or connected via the internet. You can cloud-enable it to integrate with Intune, Azure AD, Microsoft Defender for Endpoint, and other cloud services. Use Configuration Manager to deploy apps, software updates, and operating systems. You can also monitor compliance, query, act on clients in real time, and much more. To learn about all of the services that are available, see [Microsoft Endpoint Manager overview](/mem/endpoint-manager-overview).

## Microsoft 365 Defender security services use case

Let's see a real use case where companies may consider using Microsoft 365 Defender security services and what resources they may protect.

:::image type="content" alt-text="Image alt text." source="../media/microsoft-365-defender-build-second-layer-defense-attack-order.png" lightbox="../media/microsoft-365-defender-build-second-layer-defense-attack-order.png":::

In the use case that is represented in the diagram, you see some potential threats at the bottom. In the middle are the Microsoft 365 Defender services. On the top, are the services that run in the customer's environment that those threats try to reach, which are defended by Microsoft 365 Defender.

The diagram shows a malicious user (1) that has sent a phishing email with a malware attached to it. Let's suppose that the company's end user opened the malware and (2) the malware was installed in the backend without the end user having noticed (3). After the malware is installed, it will be able to steal some users credentials (4) that was used to move laterally (5) and then finally, through a new user credential with super privileges, the company data was compromised (6).

You may see through the diagram which Microsoft 365 Defender services may be used to monitor and mitigate those attacks (layer in the center), adding an additional layer of security to work along Azure security services (described in details in the document 2) that also may offer protection for the resources presented in the top of the diagram.

For more information about Microsoft 365 Defender, see [Microsoft 365 Defender](https://docs.microsoft.com/en-us/microsoft-365/security/defender/microsoft-365-defender?view=o365-worldwide).

## How to access and manage Microsoft 365 Defender Security services

Currently, you may need to use multiple portals to manage Microsoft 365 Defender services. However, Microsoft is working to centralize functionality as much as possible. The following diagram shows which portals are currently available and their relationships with each other.

:::image type="content" alt-text="A diagram that shows the current relationship of portals to services." source="../media/microsoft-365-defender-build-second-layer-defense-portals.png" lightbox="../media/microsoft-365-defender-build-second-layer-defense-portals.png":::

*Security.microsoft.com* is currently the most important portal available, because it brings functionalities from Microsoft Defender for Office (1) and from Microsoft Defender for Endpoint (2). However, at the time of writing this article (March 2022) you may still access the *protection.office.com* for security functionalities regarding Office 365 (3).

For Microsoft Defender for Endpoint, if you try to access the old portal, *securitycenter.windows.com*, you are redirected to the new portal at *security.microsoft.com* (7).

*Portal.cloudappsecurity.com* is used mainly by the Microsoft Defender for Cloud Apps (4) and allows you to manage your cloud apps and even some apps that you may run on premises, shadow IT and manage the user signals sent by Identity Protection. You can use this portal to manage many signals and features from Identity Protection on premises as well, allowing you to consolidate many functions from *portal.atp.azure.com* (6) on the portal for Microsoft Defender for Cloud Apps. However, you may still access it if you need it.

Lastly, *endpoint.microsoft.com* provides functionality mainly for Intune and Configuration Manager, but also from others services that are part of Microsoft Endpoint Manager.

Because *security.microsoft.com* and *endpoint.microsoft.com* deliver security protection for endpoints, they have lots of interaction between them (9) to offer a great security posture for your endpoints.


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

 * [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-r-oliveira-69443523) | Senior Customer Engineer

Other contributors: 

 * [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
 * [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager


## Next steps

To get all details regarding this Architecture reference, see the other articles in this series:

- Part 1: [Use Azure monitoring to integrate security components](../../guide/security/azure-monitor-integrate-security-components.yml)
- Part 2: [Map threats to your IT environment](./map-threats-it-environment.yml)
- Part 3: [Building the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)
- Part 5: [Integration between Azure and Microsoft 365 Defender security services](./microsoft-365-defender-security-integrate-azure.yml)
