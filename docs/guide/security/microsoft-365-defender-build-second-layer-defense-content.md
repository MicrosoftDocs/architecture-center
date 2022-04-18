It is very common Companies run a hybrid environment, with resources running on Azure, on-premises and with Microsoft 365, which has some applications such as Word, Excel, Powerpoint, Exchange online and more. You may read more about it in the article 2, that is part of a series of docs about Microsoft Cloud Security.

Most of Azure resources, such as VMs, Azure applications, Azure AD and more may be protected by security services running on Azure as described in details in the article 3.

But you can also consider security services provided by Microsoft 365 to build an additional security layer for some of the most used Azure resources, and still include protection for your on-premises and Office 365 environment.

Let's see how that is possible and so let's start understanding about some terminology and the structure of Microsoft 365 services.

**Microsoft 365** and **Office 365** are cloud-based services designed to help customers to meet your organization\'s needs for robust security, reliability, and user productivity.

**Microsoft 365** includes services like Power Automate, Forms, Stream, Sway and **Office 365**.

**Office 365** includes several known services like Word, Excel, PowerPoint, Outlook, OneNote, SharePoint, Teams and OneDrive

Depending on the license you acquire for **Microsoft 365** ([Microsoft 365 and Office 365 plan options - Service Descriptions](https://docs.microsoft.com/en-us/office365/servicedescriptions/office-365-platform-service-description/office-365-plan-options)), you may also get the Security services for Microsoft 365. These set of Security services are called **Microsoft 365 Defender**. It is part of Microsoft 365 Defender:

-   Microsoft Defender for Endpoint

-   Microsoft Defender for Identity

-   Microsoft Defender for Office 365

-   Microsoft Defender for Cloud Apps

This picture may help you understand Microsoft 365 set of solution and some of the main services it contains:

:::image type="content" alt-text="Image alt text." source="images/microsoft-365-defender-build-second-layer-defense-azure-services.png" lightbox="images/microsoft-365-defender-build-second-layer-defense-azure-services.png":::

## Potential use case

Some Companies and professionals sometimes make confusion about Microsoft 365 security services and their role in IT Cybersecurity. The main reasons are because we have some names that are very similar among them, including some Security services that runs on Azure, such as Microsoft Defender for Cloud, formerly known as Azure Security Center and Microsoft Defender for Cloud Apps, formerly known as Microsoft Cloud Application Security or simply MCAS.

But the confusion is not only about terminologies as some services deliver similar protection but for different resources, as Microsoft Defender for Identity and Azure ID protection services, where both offer protection for your Identity services, but the first one protects your Identity on-premises (ADDS, based on Kerberos authentication) while the second protects your Identity on the cloud (Azure AD, based on OAuth authentication).

These were some examples to show you that if you understand how Microsoft 365 security services works and what is the difference that exist when you compare them to Azure security services, you will be able to plan your strategy for Security on the Microsoft cloud in an effective way and still provide to your environment a great security posture.

That is the purpose of this article!

In the diagram below we added the Microsoft 365 Defender security services layer to build a better defense in depth for an IT environment. That layer may work along with Azure security services..

:::image type="content" alt-text="Image alt text." source="images/microsoft-365-defender-build-second-layer-defense-architecture.png" lightbox="images/microsoft-365-defender-build-second-layer-defense-architecture.png":::

## Components

1.  **Microsoft Defender for endpoint**

    Microsoft Defender for Endpoint is an enterprise endpoint security platform designed to help enterprise networks prevent, detect, investigate, and respond to advanced threats. It will create a layer of protection for VMs running on Azure and on-premises. For more details about what it may protect, see it here: [Microsoft Defender for Endpoint](https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/microsoft-defender-endpoint?view=o365-worldwide)

2.  **Microsoft Defender for Cloud Apps**

    Microsoft Defender for Cloud Apps *(formerly known as Microsoft Cloud Application Security or simply MCAS)* is a Cloud Access Security Broker (CASB) that supports various deployment modes including log collection, API connectors, and reverse proxy. It provides rich visibility, control over data travel, and sophisticated analytics to identify and combat cyberthreats across all your Microsoft and third-party cloud services. In other words, it is going to provide protection and risk mitigation for Cloud Apps or even for some Apps running on-premises. It will also provide a protection layer for users that access those Apps.

    It is very important not confuse it with the "**Microsoft Defender for Cloud**" that is a solution from Azure, formerly known as **Azure Security Center**, which provides recommendation and a security posture score for Servers, Apps, Storage accounts and other Azure resources.

    See more details on that page: [What is Defender for Cloud Apps?](https://docs.microsoft.com/en-us/defender-cloud-apps/what-is-defender-for-cloud-apps)

3.  **Microsoft Defender for Office 365**

    Microsoft Defender for Office 365 safeguards your organization against malicious threats posed by email messages, links (URLs), and collaboration tools. It will provide protection for email and collaboration. Depending on the license you have, you will be able to add post-breach investigation, hunting, and response, as well as automation, and simulation (for training). You may see more about the license options on this website:

    [Office 365 Security including Microsoft Defender for Office 365 and Exchange Online Protection - Office 365](https://docs.microsoft.com/en-us/microsoft-365/security/office-365-security/overview?view=o365-worldwide)

4.  **Microsoft Defender for Identity**

    Microsoft Defender for Identity *(formerly Azure Advanced Threat Protection, also known as Azure ATP)* is a cloud-based security solution that leverages your on-premises Active Directory signals to identify, detect, and investigate advanced threats, compromised identities, and malicious insider actions directed at your organization. It will protect ADDS (Active Directory Domains Services) running on-premises. Even though this service runs on the cloud, it works to protect Identities on-premises.

    If you need protection for identities provided by Azure AD, that runs natively on the cloud, you will have to consider Azure AD Identity Protection service.

    See more details on that page: [What is Microsoft Defender for Identity?](https://docs.microsoft.com/en-us/defender-for-identity/what-is)

5.  **Microsoft Endpoint Manager**

    Microsoft Endpoint Manager provides services for cloud and on-premises, including multiple services such as **Microsoft Intune** that allows you control features and settings on Android, Android Enterprise, iOS/iPadOS, macOS, and Windows 10 and 11 devices. It integrates with other services, including Azure Active Directory (AD), mobile threat defenders, ADMX templates, Win32 and custom LOB apps, and more.

    Another known service that is now part of Microsoft Endpoint Manager is **Configuration Manager**, an on-premises management solution, that allow you to manage desktops, servers, and laptops that are on your network or internet-based. You can cloud-enable it to integrate with Intune, Azure Active Directory (AD), Microsoft Defender for Endpoint, and other cloud services. Use Configuration Manager to deploy apps, software updates, and operating systems. You can also monitor compliance, query, and act on clients in real time, and much more.

    There are still other services that are part of Microsoft Endpoint Manager. To see all of them, look at this website: [Microsoft Endpoint Manager overview](https://docs.microsoft.com/en-us/mem/endpoint-manager-overview)

## Microsoft 365 Defender security services use case

Let's see a real use case where Companies may consider using Microsoft 365 Defender security services and what resources they may protect.

:::image type="content" alt-text="Image alt text." source="images/microsoft-365-defender-build-second-layer-defense-attack-order.png" lightbox="images/microsoft-365-defender-build-second-layer-defense-attack-order.png":::

In the use case above represented by the diagram, you see some potential threats in the bottom, the Microsoft 365 Defender services in the second layer and on the top, the services running on customer environment that those threats try to reach, which are defended by Microsoft 365 Defender.

We have: a malicious user (1) that has sent a phishing email with a malware attached to it. Let's suppose that the company's end user opened the malware (2) and the malware was installed in the backend without end user has noticed (3). Once the malware is installed, it will be able to steal some users credentials (4) that was used to move laterally (5) and then finally, through a new user credential with super privileges, the company data was compromised (6).

You may see through the diagram which Microsoft 365 Defender services may be used to monitor and mitigate those attacks (layer in the center), adding an additional layer of security to work along Azure security services (described in details in the document 2) that also may offer protection for the resources presented in the top of the diagram.

You may find more details about Microsoft 365 Defender in this link:

[Microsoft 365 Defender](https://docs.microsoft.com/en-us/microsoft-365/security/defender/microsoft-365-defender?view=o365-worldwide).

## How to access and manage Microsoft 365 Defender Security services

Currently, you may consider some Portals to manage Microsoft 365 Defender services. However, Microsoft is working to have as much functionalities as possible to be centralized in a few or in a soon future, in a single Portal.

We built this diagram below to make easier for you to understand what Portals are currently available and what is the relationship they have each other.

**Security.microsoft.com** is currently the most important portal available as it brings functionalities from Microsoft Defender for Office (1) and from Microsoft Defender for Endpoint (2).

However, at the time of writing this article (March of 2022) you may still access the **Protection.office.com** for security functionalities regarding Office 365 (3).

For Microsoft Defender for Endpoint, if you try to access the old portal **Securitycenter.windows.com**, you will be redirected to the new on "security.microsoft.com" (7).

**Portal.cloudappsecurity.com** is used mainly by the Microsoft Defender for Cloud Apps (4) and allows you to manage your cloud apps and even some apps that you may run on-premises, shadow IT and manage the user signals sent by Azure AD Identity protection. This portal may be used to manage many signals and features from Identity on-premises as well, allowing you to consolidate many functionalities from **portal.atp.azure.com** (6) on the Microsoft Defender for Cloud Apps portal. But you may still access it if you need it.

Lastly, we have the **endpoint.microsoft.com** that brings functionalities mainly regarding Intune and Configuration Manager, but also from others services that is part of Microsoft Endpoint Manager.

As both portals "security.microsoft.com" and "endpoint.microsoft.com" deliver security protection for endpoints, they have lots of interaction between them (9) to offer a great security posture for your endpoints.

:::image type="content" alt-text="Image alt text." source="images/microsoft-365-defender-build-second-layer-defense-portals.png" lightbox="images/microsoft-365-defender-build-second-layer-defense-portals.png":::

## Next steps

To get all details regarding this Architecture reference, see the other articles in this series:

- Part 1: [Use Azure monitoring to integrate security components](./azure-monitor-integrate-security-components.yml)
- Part 2: [Customer IT environment and the threats](./customer-it-environment-threats.yml)
- Part 3: [Building the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)
- Part 5: [Integration between Azure and Microsoft 365 Defender security services](./microsoft-365-defender-security-integrate-azure.yml)
