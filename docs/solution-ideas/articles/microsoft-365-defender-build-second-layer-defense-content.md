[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Many organizations operate in a hybrid environment, with resources hosted both on Azure and on-premises. Most Azure resources, such as virtual machines (VMs), Azure applications, and Microsoft Entra ID, can be secured using Azure’s built-in security services.

In addition, organizations frequently subscribe to Microsoft 365 to provide users with applications like Word, Excel, PowerPoint, and Exchange Online. Microsoft 365 also offers security services that can be used to add an extra layer of protection to some of the most widely used Azure resources.

To effectively utilize Microsoft 365 security services, it's important to understand key terminology and the structure of Microsoft 365 services. This fourth article in a series of five explores these topics in greater detail, building on concepts covered in previous articles, particularly:

- [Map threats to your IT environment](./map-threats-it-environment.yml)
- [Build the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)

Microsoft 365 and Office 365 are cloud-based services designed to address your organization's needs for strong security, reliability, and enhanced user productivity. Microsoft 365 encompasses services such as Power Automate, Forms, Stream, Sway, and Office 365. Office 365 specifically includes the familiar suite of productivity applications. For more information about subscription options for these two services, see [Microsoft 365 and Office 365 plan options](/office365/servicedescriptions/office-365-platform-service-description/office-365-plan-options).

Depending on the license that you acquire for Microsoft 365, you can also get the security services for Microsoft 365. These security services are called Microsoft Defender XDR, which provides multiple services:

-   Microsoft Defender for Endpoint
-   Microsoft Defender for Identity
-   Microsoft Defender for Office
-   Microsoft Defender for Cloud Apps

* "Microsoft Defender for Cloud Apps" accessed through "security.microsoft.com" is different from "Microsoft Defender for Cloud" that is another security solution accessed through "portal.azure.com."

The following diagram illustrates the relationship of solutions and main services that Microsoft 365 offers, though not all services are listed.

:::image type="content" alt-text="Diagram of services and products that are part of Microsoft 365." source="../media/microsoft-365-defender-build-second-layer-defense-services-diagram.png":::

## Potential use case

People often get confused about Microsoft 365 security services and their role in IT cybersecurity. A major cause of this confusion stems from the similarity in names, including some Azure security services like Microsoft Defender for Cloud (formerly Azure Security Center) and Defender for Cloud Apps (formerly Microsoft Cloud App Security).

However, the confusion goes beyond terminology. Some services provide similar protections but for different resources. For example, Defender for Identity and Azure Identity Protection both safeguard identity services, but Defender for Identity secures on-premises identities (via Active Directory Domain Services and Kerberos authentication), while Azure Identity Protection secures cloud identities (via Microsoft Entra ID and OAuth authentication).

These examples highlight the importance of understanding how Microsoft 365 security services differ from Azure security services. By gaining this understanding, you can more effectively plan your security strategy in the Microsoft cloud while maintaining a strong security posture for your IT environment. This article aims to help you achieve that.

The following diagram presents a real-world use case for Microsoft Defender XDR security services. It shows the resources that need protection, the services running in the environment, and some potential threats. Microsoft Defender XDR services are positioned in the middle, defending the organization's resources from those threats.

:::image type="content" alt-text="Diagram that shows threats, their attack order, the targeted resources, and the services of Microsoft Defender XDR that can provide protection." source="../media/microsoft-365-defender-build-second-layer-defense-attack-order.png" lightbox="../media/microsoft-365-defender-build-second-layer-defense-attack-order.png":::

## Architecture

Microsoft's Extended Detection and Response (XDR) solution, known as Microsoft Defender XDR, integrates multiple security tools and services to provide unified protection, detection, and response across endpoints, identities, email, applications, and cloud environments. It combines advanced threat intelligence, automation, and AI-driven analytics to detect and respond to sophisticated cyber threats in real-time, enabling security teams to quickly mitigate risks and reduce the impact of attacks. By consolidating security data from various sources, Microsoft Defender XDR helps organizations achieve comprehensive, streamlined defense across their entire IT infrastructure.

The following diagram shows a layer, labeled as **DEFENDER**, that represents the **Microsoft Defender XDR** security services. Adding these services to your IT environment helps you to build better defense for your environment. The services in the Defender layer can work with Azure security services.

:::image type="content" alt-text="Diagram of services, threats, and the security services that you can configure to provide protection to the resources in your I T environment." source="../media/microsoft-365-defender-build-second-layer-defense-architecture.png" lightbox="../media/microsoft-365-defender-build-second-layer-defense-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components.vsdm) of this architecture.*

*©2021 The MITRE Corporation. This work is reproduced and distributed with the permission of The MITRE Corporation.*

### Workflow

1.  **Microsoft Defender for Endpoint**

    Defender for Endpoint secures endpoints in your enterprise and is designed to help networks prevent, detect, investigate, and respond to advanced threats. It creates a layer of protection for VMs that run on Azure and on-premises. For more information about what it can protect, see [Microsoft Defender for Endpoint](/microsoft-365/security/defender-endpoint/microsoft-defender-endpoint).

2.  **Microsoft Defender for Cloud Apps**

    Formerly known as Microsoft Cloud Application Security, Defender for Cloud Apps is a cloud access security broker (CASB) that supports multiple deployment modes. Those modes include log collection, API connectors, and reverse proxy. It provides rich visibility, control over data travel, and sophisticated analytics to identify and combat cyberthreats across all your Microsoft and third-party cloud services. It provides protection and risk mitigation for Cloud Apps and even for some apps that run on-premises. It also provides a protection layer for users who access those apps. For more information, see [Microsoft Defender for Cloud Apps overview](/defender-cloud-apps/what-is-defender-for-cloud-apps).

    It's important to not confuse Defender for Cloud Apps with Microsoft Defender for Cloud, which provides recommendations and a score of the security posture of servers, apps, storage accounts, and other resources running in Azure, on-premises, and in other clouds. Defender for Cloud consolidates two previous services, Azure Security Center and Azure Defender. 

3.  **Microsoft Defender for Office**

    Defender for Office 365 safeguards your organization against malicious threats that are posed by email messages, links (URLs), and collaboration tools. It provides protection for email and collaboration. Depending on the license, you're able to add post-breach investigation, hunting, and response, as well as automation and simulation (for training). For more information about licensing options, see [Microsoft Defender for Office 365 security overview](/microsoft-365/security/office-365-security/overview?view=o365-worldwide).

4.  **Microsoft Defender for Identity**

    Defender for Identity is a cloud-based security solution that uses your on-premises Active Directory signals to identify, detect, and investigate advanced threats, compromised identities, and malicious insider actions that are directed at your organization. It protects Active Directory Domain Services (AD DS) that run on-premises. Even though this service runs on the cloud, it works to protect identities on-premises. Defender for Identity was formerly named Azure Advanced Threat Protection. For more information, see [What is Microsoft Defender for Identity](/defender-for-identity/what-is)?

    If you need protection for identities that are provided by Microsoft Entra ID and that runs natively on the cloud, consider Microsoft Entra ID Protection.

5.  **Intune (formerly part of the Microsoft Endpoint Manager**

Microsoft Intune is a cloud-based service that helps organizations manage and secure their devices, apps, and data. It allows IT administrators to control how company devices such as laptops, smartphones, and tablets are used, ensuring compliance with security policies. With Intune, you can enforce device configurations, deploy software, manage mobile applications, and protect corporate data by using features like Conditional Access and remote wipe. It is particularly useful for enabling secure remote work, managing both corporate-owned and personal (BYOD) devices, and ensuring data security across diverse platforms like Windows, iOS, Android, and macOS.

Another service that was part of Endpoint Manager is the Configuration Manager, an on-premises management solution that allows you to manage client and server computers that are on your network, connected directly or via the internet. You can enable cloud functionality to integrate Configuration Manager with Intune, Microsoft Entra ID, Defender for Endpoint, and other cloud services. Use it to deploy apps, software updates, and operating systems. You can also monitor compliance, query for objects, act on clients in real time, and much more. To learn about all the services that are available, see [Microsoft Endpoint Manager overview](/mem/endpoint-manager-overview).

### Attack order of example threats

The threats named in the diagram follow a common attack order:

1. An attacker sends a phishing email with malware attached to it. 

2. An end user opens the attached malware.

3. The malware installs in the back end without the user noticing. 

4. The installed malware steals some users' credentials.

5. The attacker uses the credentials to gain access to sensitive accounts. 

6. If the credentials provide access to an account that has elevated privilege, the attacker compromises additional systems.

The diagram also shows in the layer labeled as **DEFENDER** which Microsoft Defender XDR services can monitor and mitigate those attacks. This is an example of how Defender provides an additional layer of security that works with Azure security services to offer additional protection of the resources that are shown in the diagram. For more information about how potential attacks threaten your IT environment, see the second article in this series, [Map threats to your IT environment](../../solution-ideas/articles/map-threats-it-environment.yml). For more information about Microsoft Defender XDR, see [Microsoft Defender XDR](/microsoft-365/security/defender/microsoft-365-defender?view=o365-worldwide).

### Access and manage Microsoft Defender XDR Security services

The following diagram shows which portals are currently available and their relationships with each other. In the time of the update for this articles, some of those portals might be already deprecated.

:::image type="content" alt-text="A diagram that shows the current relationship of portals to services." source="../media/microsoft-365-defender-build-second-layer-defense-portals.png" lightbox="../media/microsoft-365-defender-build-second-layer-defense-portals.png":::

*Security.microsoft.com* is currently the most important portal available because it brings functionalities from Microsoft Defender for Office 365 (1), from Defender for Endpoint (2), from Defender for Office (3), Defender for Identity (5), Defender for Apps (4) and also for Microsoft Sentinel. 

It is important to mention that Microsoft Sentinel has some features that still run only on the Azure Portal (portal.azure.com). 

Lastly, `endpoint.microsoft.com` provides functionality mainly for Intune and Configuration Manager, but also for other services that are part of Endpoint Manager. Because `security.microsoft.com` and `endpoint.microsoft.com` deliver security protection for endpoints, they have many interactions between them (9) to offer a great security posture for your endpoints.

### Components

The example architecture in this article uses the following Azure components:

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based identity and access management service. Microsoft Entra ID helps users access external and internal resources. In this architecture, Microsoft Entra ID authenticates users that access Microsoft 365, Azure, and software as a service (SaaS) applications. It serves as the identity foundation for threat detection and response.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service in Azure that enables secure communication between Azure resources, the internet, and on-premises networks. In this architecture, it provides the private network infrastructure that supports secure connectivity and segmentation of workloads that Microsoft Defender XDR protects.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a high-performance, layer-4 load balancing service for Transmission Control Protocol (TCP) and User Datagram Protocol (UDP) traffic. In this architecture, it ensures high availability and scalability for services that run in Azure by distributing traffic across VMs and containers.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure-as-a-service (IaaS) offering that provides scalable compute resources. In this architecture, VMs host workloads that Microsoft Defender for Endpoint monitors and protects as part of the Microsoft Defender XDR solution.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service for deploying and managing containerized applications. In this architecture, AKS runs containerized workloads that integrate into the Microsoft Defender XDR threat detection and response framework.

- [Azure Virtual Desktop](/azure/virtual-desktop/overview) is a desktop and app virtualization service that provides secure remote access to cloud-hosted desktops. In this architecture, it supports remote users. Defender for Endpoint monitors Virtual Desktop to detect and respond to endpoint threats.

- The [Web Apps feature of Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) hosts web applications, REST APIs, and mobile back ends. You can develop in your chosen language. Applications run and scale with ease on both Windows and Linux-based environments. In this architecture, Web Apps hosts HTTP-based applications that are protected through integrated security features and monitored for threats.

- [Azure Storage](/azure/storage/common/storage-introduction) is a scalable and secure storage service for various data objects in the cloud, including object, blob, file, disk, queue, and table storage. Azure Storage encrypts all data written to an Azure storage account. It provides fine-grained control over access to your data. In this architecture, it stores application and system data and is protected by Defender for Cloud to ensure data integrity and access control.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a managed relational database engine that automates patching, backups, and monitoring. In this architecture, it stores structured data and benefits from built-in security features that align with Microsoft for Defender XDR threat protection capabilities.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-oliveira-69443523/) | Senior Customer Engineer

Other contributors:

- [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
- [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager

## Next steps

- [Defend against threats with Microsoft 365](/training/paths/m365-security-threat-protection)
- [Detect and respond to cyber attacks with Microsoft Defender XDR](/training/paths/defender-detect-respond)
- [Get started with Microsoft Defender XDR](/microsoft-365/security/defender/get-started)
- [Implement threat intelligence in Microsoft 365](/training/paths/implement-microsoft-365-threat-intelligence)
- [Manage security with Microsoft 365](/training/paths/m365-security-management)
- [Protect against malicious threats with Microsoft Defender for Office 365](/training/paths/defender-office-365-malicious-threats)
- [Protect on-premises identities with Microsoft Defender for Cloud for Identity](/training/paths/defender-identity-protect-on-premises)

## Related resources

For more information about this reference architecture, see the other articles in this series:

- Part 1: [Map threats to your IT environment](./map-threats-it-environment.yml)
- Part 2: [Build the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)
- Part 4: [Integration between Azure and Microsoft Defender XDR security services](./microsoft-365-defender-security-integrate-azure.yml)
